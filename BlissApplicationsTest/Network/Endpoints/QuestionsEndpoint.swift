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
                    print("Network Error: Failed to decode Question List JSON")
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
    
    func searchQuestion(filter: String?, limit: Int? = 10, offset: Int? = 0, update:@escaping (NetworkResponse, [QuestionModel]?)->Void) {
        
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
                    print("Network Error: Failed to decode Search Question List JSON")
                    update(response, nil)
                }
                
            }, onError: { error in
                print(error)
                
            }).disposed(by: DISPOSABLE_BAG)
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
                    print("Network Error: Failed to decode Create Question JSON")
                    update(response, nil)
                }
                
            }, onError: { error in
                print(error)
                
            }).disposed(by: DISPOSABLE_BAG)
    }
    
    func updateQuestion(question: QuestionModel?, update:@escaping (NetworkResponse, QuestionModel?)->Void) {
        
        if let id = question?.id {
            
            var params : [String:String] = [:]
            if let title = question?.question, let imageUrl = question?.imageURL, let thumbUrl = question?.thumbURL, let choices = question?.choices {
                params["question"] = title
                params["image_url"] = imageUrl
                params["thumb_url"] = thumbUrl
                var fullJSONArray = [String]()
                for choice in choices {
                    fullJSONArray.append(choice.json())
                }
                params["choices"] = fullJSONArray.description
            } else {
                update(NetworkResponse(code: 400), nil)
                return
            }
            
            let routeQuestion = Route(target: .questionID, targetParams: [":question_id" : String(id)], params: params, method: .put)
            
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
