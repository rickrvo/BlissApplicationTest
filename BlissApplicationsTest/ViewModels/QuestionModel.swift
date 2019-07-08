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
    let choices: [Choices]?
}

extension QuestionModel {
    enum CodingKeys: String, CodingKey {
        
        case  id
        case  question
        case  imageURL = "image_url"
        case  thumbURL = "thumb_url"
        case  publishedAt = "published_at"
        case  posterPath = "poster_path"
        case  choices
        
    }
}

public struct Choices: Codable {
    public var choice: String?
    public var votes: Int?
}
