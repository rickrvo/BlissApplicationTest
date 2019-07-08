//
//  APIProtocol.swift
//  BlissApplicationsTest
//
//  Created by Henrique Ormonde on 06/07/19.
//  Copyright © 2019 Rick. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

typealias NetworkParams = Parameters

typealias UpdateContentSuccess<T> = (T?)->Void
typealias UpdateContentError = (Error)->Void

enum NetworkProtocol: String {
    case http
    case https
    
    var asString: String {
        return self.rawValue
    }
}

protocol NetworkEnvironment {
    var url: String { get }
}

protocol NetworkEndpoint {
    var endpoint: String { get }
}

protocol NetworkRoute {
    var params: NetworkParams? { get set }
    var netURL: NetworkURL { get set }
    var method: HTTPMethod { get set }
    var encoding: ParameterEncoding { get set }
    
    var stringURL: String { get }
    func url() -> URL
}

struct NetworkURL {
    var netprotocol: NetworkProtocol
    var target: Endpoint
    
    init() {
        netprotocol = DEFAULT_PROTOCOL
        target = .health
    }
    
    init(target: Endpoint) {
        netprotocol = DEFAULT_PROTOCOL
        self.target = target
    }
    
}

struct NetworkError:Error {
    var code: Int
    var message: String
}

struct NetworkResponse {
    
    var code: Int
    var data: JSON?
    
    init(code: Int) {
        self.code = code
    }
    
}

