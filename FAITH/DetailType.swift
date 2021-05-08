//
//  DetailType.swift
//  FAITH
//
//  Created by Guylian Bollon on 14/03/2021.
//

import Foundation

enum DetailType{
    case AUDIO
    case DRAWING
    case PHOTO
    case TEXT
}
extension DetailType:Codable{
    enum Key:CodingKey{
        case rawValue
    }
    enum CodingError:Error{
        case unknownValue
    }
    init(from decoder:Decoder) throws{
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        switch rawValue{
        case 0:
            self = .AUDIO
        case 1:
            self = .DRAWING
        case 2:
            self = .PHOTO
        case 3:
            self = .TEXT
        default:
            throw CodingError.unknownValue
        }
    }
    func encode(to encoder:Encoder) throws{
        var container = encoder.container(keyedBy: Key.self)
        switch self{
        case .AUDIO:
            try container.encode(0, forKey:.rawValue)
        case .DRAWING:
            try container.encode(1, forKey:.rawValue)
        case .PHOTO:
            try container.encode(2, forKey:.rawValue)
        case .TEXT:
            try container.encode(3, forKey: .rawValue)
        }
    }
    func toString() -> String{
        switch self{
        case .AUDIO:
            return "AUDIO"
        case .DRAWING:
            return "DRAWING"
        case .PHOTO:
            return "PHOTO"
        case .TEXT:
            return "TEXT"
        }
    }
}
