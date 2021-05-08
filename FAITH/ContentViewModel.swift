//
//  ContentViewModel.swift
//  FAITH
//
//  Created by Guylian Bollon on 10/03/2021.
//

import Foundation
import FirebaseAuth

class ContentViewModel: ObservableObject{
    @Published var content: Resource? = nil
    private let url = URL(string:"http://localhost:8080/welcome")!
    private let session : URLSession
    
    init(session:URLSession = .shared){
        self.session = session
        let cookieStorage = HTTPCookieStorage.shared
        let cookies = cookieStorage.cookies(for: url) ?? []
        if(!cookies.isEmpty){
            for cookie in cookies{
                if(cookie.name.contains("session")){
                    let result = self.decode(jwtToken: cookie.value)
                    let expired = result["exp"] as! Double * 1000
                    let expiracyDate = Date(timeIntervalSince1970: expired)
                    if(expiracyDate>Date()){
                        content = Resource(resourceState: ResourceState.SUCCESS, message: nil)
                    }
                    else{
                        for cookie in cookieStorage.cookies! {
                            cookieStorage.deleteCookie(cookie)
                        }
                    }
                }
            }
        }
    }
    func createToken(completion: @escaping(Token?) -> Void){
        var request = URLRequest(url:url)
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
          if let error = error {
            // Handle error
            return;
          }
            let token = "Bearer "+idToken!
            request.httpMethod = "GET"
            request.addValue(token, forHTTPHeaderField: "Authorization")
            let task = self.session.dataTask(with: request){
                (data,response,error) in
                guard
                    let url = response?.url,
                    let httpResponse = response as? HTTPURLResponse,
                    let fields = httpResponse.allHeaderFields as? [String: String]
                else { return }
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: fields, for: url)
                self.storeCookies(cookies: cookies, url: self.url)
                self.content = Resource(resourceState: ResourceState.SUCCESS, message: nil)
            }
            task.resume()
        }
    }
    func login(user:User){
        content = Resource(resourceState: ResourceState.LOADING, message: nil)
        Auth.auth().signIn(withEmail: user.username+"@faith.be", password: user.password){[weak self] authResult, error in
            if let error = error{
                self?.content = Resource(resourceState: ResourceState.ERROR, message: error.localizedDescription)
            }
            if let authResult = authResult{
                self?.createToken{ (token) in
                    
                }
            }
        }
    }
    func storeCookies(cookies:[HTTPCookie],url:URL) {
        let cookiesStorage = HTTPCookieStorage.shared
        let sessionTask = URLSession.shared.dataTask(with: url)
        cookiesStorage.storeCookies(cookies, for: sessionTask)
    }
    func decode(jwtToken jwt: String) -> [String: Any] {
      let segments = jwt.components(separatedBy: ".")
      return decodeJWTPart(segments[1]) ?? [:]
    }

    func base64UrlDecode(_ value: String) -> Data? {
      var base64 = value
        .replacingOccurrences(of: "-", with: "+")
        .replacingOccurrences(of: "_", with: "/")

      let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
      let requiredLength = 4 * ceil(length / 4.0)
      let paddingLength = requiredLength - length
      if paddingLength > 0 {
        let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
        base64 = base64 + padding
      }
      return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
    }

    func decodeJWTPart(_ value: String) -> [String: Any]? {
      guard let bodyData = base64UrlDecode(value),
        let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
          return nil
      }
      return payload
    }
}

