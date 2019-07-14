//
//  APIService.swift
//  BlissApplicationsTest
//
//  Created by Henrique Ormonde on 06/07/19.
//  Copyright © 2019 Rick. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import SwiftyJSON

class NetworkService {
    
    func singleRequest(route: NetworkRoute) -> Observable<NetworkResponse> {
        
        return
            Observable<NetworkResponse>.create({ (observable) -> Disposable in
                var response = NetworkResponse(code: 200)
                var responseError = NetworkError(code: 404, message: "not found")
                
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                }
                
                let cancel = Disposables.create {
                    print("closing stream")
                }
                
                Alamofire.request(route.stringURL,
                                  method: route.method,
                                  parameters: route.params,
                                  encoding: route.encoding,
                                  headers: ["Content-Type" : "application/json"])
                    
                    .responseJSON(completionHandler: { jsonResponse in
                        
                        if let err = jsonResponse.error {
                            responseError.code = jsonResponse.response?.statusCode ?? 500
                            responseError.message = err.localizedDescription
                            
                            observable.onError(responseError)
                        }
                        
                        if let json = jsonResponse.data {
                            do {
                                response.data = try JSON(data: json)
                            } catch {
                                print("error parsing JSON")
                            }
                        }
                        
                        DispatchQueue.main.async {
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        }
                        
                        observable.on(.next(response))
                        observable.on(.completed)
                    })
                
                return cancel
            })
    }
    
    func request(route: NetworkRoute) -> Observable<NetworkResponse>  {
        
        return Observable
            .create({ observable -> Disposable in
                var response = NetworkResponse(code: 200)
                var responseError = NetworkError(code: 404, message: "not found")
                
                let timer = DispatchSource.makeTimerSource(flags: .strict,
                                                           queue: DispatchQueue(label: "requestSchedule"))
                
                let cancel = Disposables.create {
                    print("closing stream")
                    timer.cancel()
                }
                
                timer.schedule(deadline: .now(), repeating: DEFAULT_NETWORK_REQUEST_INTERVAL)
                timer.setEventHandler(handler: {
                    if cancel.isDisposed {
                        return
                    }
                    
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = true
                    }
                    
                    Alamofire.request(route.stringURL,
                                      method: route.method,
                                      parameters: route.params,
                                      headers: ["Content-Type" : "application/json"])
                        .responseJSON(completionHandler: { jsonResponse in
                            
                            if let err = jsonResponse.error {
                                responseError.code = jsonResponse.response?.statusCode ?? 500
                                responseError.message = err.localizedDescription
                                
                                observable.onError(responseError)
                            }
                            
                            if let json = jsonResponse.data {
                                do {
                                    response.data = try JSON(data: json)
                                } catch {
                                    print("error parsing JSON")
                                }
                            }
                            
                            //response.data = jsonResponse
                            DispatchQueue.main.async {
                                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            }
                            
                            
                            observable.on(.next(response))
                        })
                    
                })
                
                timer.resume()
                
                return cancel
            })
        
    }
    
}
