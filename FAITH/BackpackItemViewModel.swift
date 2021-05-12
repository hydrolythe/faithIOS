//
//  BackpackItemViewModel.swift
//  FAITH
//
//  Created by Guylian Bollon on 07/05/2021.
//

import Foundation
import AVFoundation

class BackpackItemViewModel:ObservableObject{
    private let url = URL(string:"http://localhost:8080/backpack")!
    func getResource(detail:ExpandedDetail) -> Recording{
        var request = URLRequest(url:url)
        request.httpMethod = "PUT"
        let detailFile = DetailFile(file: detail.file.replacingOccurrences(of: "_encrypted", with: ""))
        request.httpBody = try? JSONEncoder().encode(detailFile)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        var link = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        switch(detail.detailType){
        case "AUDIO": link=link.appendingPathComponent("\(detail.dateTime).mpeg")
        case "DRAWING": link=link.appendingPathComponent("\(detail.dateTime).png")
        case "PHOTO": link=link.appendingPathComponent("\(detail.dateTime).jpeg")
        case "TEXT": link=link.appendingPathComponent("\(detail.dateTime).txt")
        default: break
        }
        let task = URLSession.shared.dataTask(with: request){(data,response,error) in
            do{
            if let data = data{
                try data.write(to:link)
            }
            }
            catch{
                print("Failed to overwrite data")
            }
        }
        task.resume()
        return Recording(fileURL: link, createdAt: nil)
    }
}
