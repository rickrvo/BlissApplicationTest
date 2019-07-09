//
//  APIConstants.swift
//  BlissApplicationsTest
//
//  Created by Henrique Ormonde on 06/07/19.
//  Copyright © 2019 Rick. All rights reserved.
//

import Foundation
import RxSwift

let DEFAULT_PROTOCOL: NetworkProtocol = .https

let DEFAULT_NETWORK_TIMEOUT: TimeInterval = 31
let DEFAULT_NETWORK_REQUEST_INTERVAL: TimeInterval = 15

let DISPOSABLE_BAG: DisposeBag = DisposeBag()


enum Endpoint:String, NetworkEndpoint {
    
    var endpoint: String {
        return self.rawValue
    }
    
    case health = "health"
    case questions = "questions"
    case questionID = "questions/:question_id"
    case share = "share"
    
}

enum searchType: String {
    
    var type: String {
        return self.rawValue
    }
    
    case movie = "movie"
    case tv = "tv"
    case people = "person"
    case keywords = "keyword"
    case companies = "company"
}
