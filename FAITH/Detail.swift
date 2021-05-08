//
//  Detail.swift
//  FAITH
//
//  Created by Guylian Bollon on 25/04/2021.
//

import Foundation

class Detail:Codable{
    var file: String
    var title: String
    var uuid: UUID
    var thumbnail: String?
    var dateTime: String
    init(file:String,title:String,uuid:UUID,dateTime:String,thumbnail:String?){
        self.file = file
        self.title = title
        self.uuid = uuid
        self.dateTime = dateTime
        self.thumbnail = thumbnail
    }
    private enum CodingKeys: String, CodingKey{
        case file
        case title
        case uuid
        case dateTime
        case thumbnail
    }
        required init(from decoder:Decoder) throws{
            let container = try decoder.container(keyedBy: CodingKeys.self)
            thumbnail = try container.decode(String?.self, forKey: .thumbnail)
            file = try container.decode(String.self, forKey: .file)
            title = try container.decode(String.self, forKey: .title)
            uuid = try container.decode(UUID.self, forKey: .uuid)
            dateTime = try container.decode(String.self, forKey: .dateTime)
            
        }
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(file, forKey: .file)
            try container.encode(title, forKey: .title)
            try container.encode(uuid, forKey: .uuid)
            try container.encode(dateTime, forKey: .dateTime)
            try container.encode(thumbnail, forKey: .thumbnail)
        }
}
