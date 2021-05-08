//
//  SaveViewModel.swift
//  FAITH
//
//  Created by Guylian Bollon on 23/04/2021.
//

import Foundation
import FirebaseAuth

class SaveViewModel:ObservableObject{
    private let backpack = URL(string:"http://localhost:8080/backpack/"+Auth.auth().currentUser!.uid)!
    private let audio = URL(string:"http://localhost:8080/audio")!
    private let picture = URL(string:"http://localhost:8080/photo")!
    private let drawing = URL(string:"http://localhost:8080/draw")!
    private let text = URL(string:"http://localhost:8080/text")!
    private let recording : Recording
    private var type : DetailType
    init(recording:Recording,type:DetailType){
        self.recording = recording
        self.type = type
    }
    func saveItem(title:String){
        var url: URL
        let boundary = "Boundary-\(UUID().uuidString)"
        let httpBody = NSMutableData()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        switch(type){
        case DetailType.AUDIO :
            url = audio
            httpBody.append(convertFileData(fieldName: "file",
                                            filename: "audio.mpeg",
                                            mimeType: "multipart/form-data",
                                            fileData: try! Data(contentsOf: recording.fileURL!),
                                            using: boundary))
        case DetailType.DRAWING :
            url = drawing
            httpBody.append(convertFileData(fieldName: "file",
                                            filename: "imagename.png",
                                            mimeType: "image/png",
                                            fileData: try! Data(contentsOf: recording.fileURL!),
                                            using: boundary))
        case DetailType.PHOTO :
            url = picture
            httpBody.append(convertFileData(fieldName: "file",
                                            filename: "imagename.jpeg",
                                            mimeType: "image/jpeg",
                                            fileData: try! Data(contentsOf: recording.fileURL!),
                                            using: boundary))
        case DetailType.TEXT :
            url = text
            let token = Token(token: try! String(contentsOf: recording.fileURL!))
            let jsonEncoder = JSONEncoder()
            let jsonData = try? jsonEncoder.encode(token)
            httpBody.append(jsonData!)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = httpBody as Data
        if(type != DetailType.TEXT){
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        }
        else{
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        let task = URLSession.shared.dataTask(with: request){
            (data,response,error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
               let detail = try? jsonDecoder.decode(Detail.self, from:data){
                var addition = URLRequest(url:self.backpack)
                addition.httpMethod = "POST"
                let jsonEncoder = JSONEncoder()
                let typeString = self.type.toString()
                let expandedDetail = ExpandedDetail(file: detail.file, title: title, uuid: detail.uuid, dateTime: detail.dateTime, thumbnail: detail.thumbnail, detailType: typeString)
                let jsonData = try? jsonEncoder.encode(expandedDetail)
                addition.httpBody = jsonData
                addition.setValue("application/json", forHTTPHeaderField: "Content-Type")
                let result = URLSession.shared.dataTask(with: addition){
                    (data,response,error) in
                }
                result.resume()
            }
        }
        task.resume()
    }
    func convertFileData(fieldName: String, filename: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
      let data = NSMutableData()
      data.appendString("--\(boundary)\r\n")
      data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(filename)\"\r\n")
      data.appendString("Content-Type: \(mimeType)\r\n\r\n")
      data.append(fileData)
      data.appendString("\r\n")
        data.appendString("--\(boundary)--")
      return data as Data
    }
}

extension NSMutableData {
  func appendString(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}
