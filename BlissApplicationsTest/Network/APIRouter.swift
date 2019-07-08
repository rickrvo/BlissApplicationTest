//
//  APIRouter.swift
//  BlissApplicationsTest
//
//  Created by Henrique Ormonde on 06/07/19.
//  Copyright © 2019 Rick. All rights reserved.
//

import Foundation
import Alamofire

class Route: NetworkRoute {
    
    var method: HTTPMethod = .post
    var params: NetworkParams?
    var targetParams: NetworkParams?
    var netURL: NetworkURL = NetworkURL()
    var encoding: ParameterEncoding = URLEncoding.default
    
    init(target: Endpoint, targetParams: NetworkParams? = nil, params:NetworkParams? = nil, method: HTTPMethod? = nil, encoding: ParameterEncoding = URLEncoding.default) {
        self.netURL.target = target
        self.params = params
        self.encoding = encoding
        
        if let m = method {
            self.method = m
        }
        
        if let p = params {
            self.params = p
        }
        
        if let t = targetParams {
            self.targetParams =  t
        }
    }
    
    init(target: Endpoint, params:NetworkParams? = nil, method: HTTPMethod? = nil) {
        self.netURL.target = target
        self.params = params
        
        if let m = method {
            self.method = m
        }
        
        if let p = params {
            self.params = p
        }
        
    }
    
    var stringURL: String {
        var urlString = netURL.netprotocol.asString
        urlString.append("://")
        urlString.append("private-anon-6637a44138-blissrecruitmentapi.apiary-mock.com/")
        urlString.append(transformedEndpoint())
        
        return urlString
    }
    
    func transformedEndpoint() -> String {
        if let t = targetParams {
            var endpoint = netURL.target.endpoint
            for param in t {
                endpoint = String(endpoint.replacingOccurrences(of: param.key, with: param.value as! String))
            }
            
            return endpoint
        }
        
        return netURL.target.endpoint
    }
    
    func url() -> URL {
        let url = URL(string: self.stringURL)!
        return url
    }
    
    func request() -> URLRequest {
        let request = URLRequest(url: self.url(), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: DEFAULT_NETWORK_TIMEOUT)
        
        return request
    }
    
}
