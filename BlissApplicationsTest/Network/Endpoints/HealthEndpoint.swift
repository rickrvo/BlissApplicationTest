//
//  HealthEndpoint.swift
//  BlissApplicationsTest
//
//  Created by Henrique Ormonde on 07/07/19.
//  Copyright © 2019 Rick. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire


class HealthNetworkService: NetworkService {
    
    var healthObservable: Observable<NetworkResponse>?
    
    func getHealthState(update:@escaping (NetworkResponse, HealthModel?)->Void) {
        
        let routeHealth: NetworkRoute? = Route(target: .health, method: .get)

        healthObservable = self.singleRequest(route: routeHealth!)
        
        healthObservable?
            .subscribe(onNext: { response in
                guard let json = response.data else {
                    return
                }
//                let success = json["status"].stringValue
//                if success.uppercased() != "OK" {
//                    update(response, nil)
//                    return
//                }
                do {
                    let model = try JSONDecoder().decode(HealthModel.self, from: json.rawData())
                    update(response, model)
                } catch {
                    print("Network Error: Failed to decode Health JSON")
                    update(response, nil)
                }
                
            }, onError: { error in
                print(error)
                
            }).disposed(by: DISPOSABLE_BAG)
    }
    
}
