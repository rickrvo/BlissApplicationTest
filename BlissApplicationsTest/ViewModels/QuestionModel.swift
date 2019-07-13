//
//  QuestionModel.swift
//  BlissApplicationsTest
//
//  Created by Henrique Ormonde on 07/07/19.
//  Copyright © 2019 Rick. All rights reserved.
//

import Foundation

class QuestionModel: Codable {
    
    let id: Int?
    let question: String?
    let imageURL: String?
    let thumbURL: String?
    let publishedAt: String?
    var choices: [Choices]?
    
}

extension QuestionModel {
    enum CodingKeys: String, CodingKey {
        
        case  id
        case  question
        case  imageURL = "image_url"
        case  thumbURL = "thumb_url"
        case  publishedAt = "published_at"
        case  choices
        
    }
}

public struct Choices: Codable {
    public var choice: String?
    public var votes: Int?
    
    func toDictionary() -> [String : Any] {
        return ["choice": String(self.choice ?? ""),
                 "votes": String(self.votes ?? 0) ]
    }
    
    func json() -> String {
        return toJSON(from: toDictionary())!
    }
}
