//
//  ShareEndpoint.swift
//  BlissApplicationsTest
//
//  Created by Henrique Ormonde on 07/07/19.
//  Copyright © 2019 Rick. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import SwiftyJSON


class ShareNetworkService: NetworkService {
    
    var shareObservable: Observable<NetworkResponse>?
    
    func shareQuestion(destinationEmail: String? = nil, contentUrl: String? = nil, update:@escaping (NetworkResponse, ShareModel?)->Void) {
        
        var params : [String:String] = [:]
        if let destination = destinationEmail {
            params["destination_email"] = destination
        }
        if let content = contentUrl {
            params["content_url"] = content
        }
        
        let routeShare: NetworkRoute? = Route(target: .share, params: params, method: .post)
        
        shareObservable = self.singleRequest(route: routeShare!)
        
        shareObservable?
            .subscribe(onNext: { response in
                guard let json = response.data else {
                    return
                }
                do {
                    let model = try JSONDecoder().decode(ShareModel.self, from: json.rawData())
                    update(response, model)
                } catch {
                    print("Network Error: Failed to decode Share JSON")
                    update(response, nil)
                }
                
            }, onError: { error in
                print(error)
                
            }).disposed(by: DISPOSABLE_BAG)
    }
    
}
