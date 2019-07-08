//
//  QuestionsEndpoint.swift
//  BlissApplicationsTest
//
//  Created by Henrique Ormonde on 07/07/19.
//  Copyright © 2019 Rick. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import SwiftyJSON


class QuestionNetworkService: NetworkService {
    
    var questionObservable: Observable<NetworkResponse>?
    
    func getQuestionList(limit: Int? = 10, offset: Int? = 0, filter: String?, update:@escaping (NetworkResponse, [QuestionModel]?)->Void) {
        
        var params : [String:String] = [:]
        if let limit = limit {
            params["limit"] = String(limit)
        }
        if let offset = offset {
            params["offset"] = String(offset)
        }
        if let filter = filter {
            params["filter"] = String(filter)
        }
        
        let routeQuestion: NetworkRoute? = Route(target: .questions, params: params, method: .get)
        
        questionObservable = self.singleRequest(route: routeQuestion!)
        
        questionObservable?
            .subscribe(onNext: { response in
                guard let json = response.data else {
                    return
                }
                do {
                    let model = try JSONDecoder().decode([QuestionModel].self, from: json.rawData())
                    update(response, model)
                } catch {
                    print("Network Error: Failed to decode Movie JSON")
                    update(response, nil)
                }
                
            }, onError: { error in
                print(error)
                
            }).disposed(by: DISPOSABLE_BAG)
    }
    
    func getQuestion(questionID: Int? = nil, update:@escaping (NetworkResponse ,QuestionModel?)->Void) {
        
        if let id = questionID {
            
            let routeQuestion = Route(target: .questionID, targetParams: [":question_id" : String(id)], method: .get)
            
            questionObservable = self.singleRequest(route: routeQuestion)
            
            questionObservable?
                .subscribe(onNext: { response in
                    guard let json = response.data else {
                        return
                    }
                    do {
                        let model = try JSONDecoder().decode(QuestionModel.self, from: json.rawData())
                        update(response, model)
                    } catch {
                        print("Network Error: Failed to decode Question JSON")
                        update(response, nil)
                    }
                    
                }, onError: { error in
                    print(error)
                    
                }).disposed(by: DISPOSABLE_BAG)
        }
    }
    
    func createQuestion(question: String?, imageUrl: String?, thumbUrl: String?, choices: [String]?, update:@escaping (NetworkResponse, QuestionModel?)->Void) {
        
        var params : [String:String] = [:]
        if let question = question, let imageUrl = imageUrl, let thumbUrl = thumbUrl, let choices = choices {
            params["question"] = question
            params["image_url"] = imageUrl
            params["thumb_url"] = thumbUrl
            params["choices"] = JSON.init(arrayLiteral: choices).stringValue
        } else {
            update(NetworkResponse(code: 400), nil)
            return
        }
        
        let routeQuestion = Route(target: .questions, params: params, method: .post)
        
        questionObservable = self.singleRequest(route: routeQuestion)
        
        questionObservable?
            .subscribe(onNext: { response in
                guard let json = response.data else {
                    return
                }
                do {
                    let model = try JSONDecoder().decode(QuestionModel.self, from: json.rawData())
                    update(response, model)
                } catch {
                    print("Network Error: Failed to decode MovieForGenre JSON")
                    update(response, nil)
                }
                
            }, onError: { error in
                print(error)
                
            }).disposed(by: DISPOSABLE_BAG)
    }
    
    func updateQuestion(questionID: String?, question: String?, imageUrl: String?, thumbUrl: String?, choices: [String]?, update:@escaping (NetworkResponse, QuestionModel?)->Void) {
        
        if let id = questionID {
            
            var params : [String:String] = [:]
            if let question = question, let imageUrl = imageUrl, let thumbUrl = thumbUrl, let choices = choices {
                params["question"] = question
                params["image_url"] = imageUrl
                params["thumb_url"] = thumbUrl
                params["choices"] = JSON.init(arrayLiteral: choices).stringValue
            } else {
                update(NetworkResponse(code: 400), nil)
                return
            }
            
            let routeQuestion = Route(target: .questionID, targetParams: [":question_id" : id], params: params, method: .put)
            
            questionObservable = self.singleRequest(route: routeQuestion)
            
            questionObservable?
                .subscribe(onNext: { response in
                    guard let json = response.data else {
                        return
                    }
//                    if let success = json["success"].bool {
//                        if success == false {
//                            update(response, nil)
//                            return
//                        }
//                    }
                    do {
                        let model = try JSONDecoder().decode(QuestionModel.self, from: json.rawData())
                        update(response, model)
                    } catch {
                        print("Network Error: Failed to decode Search JSON")
                        update(response, nil)
                    }
                    
                }, onError: { error in
                    print(error)
                    
                }).disposed(by: DISPOSABLE_BAG)
        }
    }
    
}
