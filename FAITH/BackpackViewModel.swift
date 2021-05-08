//
//  BackpackViewModel.swift
//  FAITH
//
//  Created by Guylian Bollon on 15/03/2021.
//

import Foundation
import FirebaseAuth

class BackpackViewModel: ObservableObject{
    @Published var details:[ExpandedDetail]
    private let url = URL(string:"http://localhost:8080/backpack/"+Auth.auth().currentUser!.uid)!
    
    init() {
        self.details = []
        var request = URLRequest(url:url)
        let cookieStorage = HTTPCookieStorage.shared
        let cookies = cookieStorage.cookies(for: url) ?? []
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        for cookie in cookies{
            request.setValue(cookie.name+"="+cookie.value, forHTTPHeaderField: "Cookie")
        }
        request.httpShouldHandleCookies = true
        let task = URLSession.shared.dataTask(with: request){
            (data,response,error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
               let expandedDetails = try? jsonDecoder.decode(DetailArray.self, from:data){
                self.details = expandedDetails.details
            }
        }
        task.resume()
    }
}
