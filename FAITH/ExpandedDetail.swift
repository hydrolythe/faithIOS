//
//  ExpandedDetail.swift
//  FAITH
//
//  Created by Guylian Bollon on 14/03/2021.
//

import Foundation

class ExpandedDetail:ObservableObject,Identifiable,Codable{
    var file: String
    var title: String
    var uuid: UUID
    var thumbnail: String?
    var dateTime: String
    var detailType: String
    init(file:String,title:String,uuid:UUID,dateTime:String,thumbnail:String?,detailType:String){
        self.file = file
        self.title = title
        self.uuid = uuid
        self.dateTime = dateTime
        self.thumbnail = thumbnail
        self.detailType = detailType
    }
    private enum CodingKeys: String, CodingKey{
        case file
        case title
        case uuid
        case dateTime
        case thumbnail
        case detailType
    }
        required init(from decoder:Decoder) throws{
            let container = try decoder.container(keyedBy: CodingKeys.self)
            file = try container.decode(String.self, forKey: .file)
            title = try container.decode(String.self, forKey: .title)
            uuid = try container.decode(UUID.self, forKey: .uuid)
            dateTime = try container.decode(String.self, forKey: .dateTime)
            thumbnail = try container.decode(String?.self, forKey: .thumbnail)
            detailType = try container.decode(String.self, forKey: .detailType)
        }
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(file, forKey: .file)
            try container.encode(title, forKey: .title)
            try container.encode(uuid, forKey: .uuid)
            try container.encode(dateTime, forKey: .dateTime)
            try container.encode(thumbnail, forKey: .thumbnail)
            try container.encode(detailType, forKey: .detailType)
        }
}

extension ExpandedDetail{
    static var detail:ExpandedDetail {
        ExpandedDetail(file: "/Users/guylianbollon/IdeaProjects/faith/pictures/1cb94ab3-1e08-42e6-aad4-33c6474002dd", title: "", uuid: UUID.init(uuidString: "b983e1a3-a79a-41ee-a328-1ebea67394c1")!, dateTime: "", thumbnail: "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", detailType: "DRAWING")
    }
}
