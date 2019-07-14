//
//  NetworkManager.swift
//  BlissApplicationsTest
//
//  Created by Henrique Ormonde on 07/07/19.
//  Copyright © 2019 Rick. All rights reserved.
//

import Foundation
import Network

class NetworkManager {
    
    var questions : [QuestionModel]
    var genresList : [Int : [QuestionModel]]
    
    var currentQuestionListOffset : Int
    var currentSearchOffset : Int
    
    let monitor = NWPathMonitor()
    
    var appSingleton: AppSingleton?
    
    private static var sharedNetworkManager: NetworkManager = {
        let questionManager = NetworkManager()
        return questionManager
    }()
    
    let healthService = HealthNetworkService()
    let questionService = QuestionNetworkService()
    let shareService = ShareNetworkService()
    
    private init() {
        self.questions = []
        self.genresList = [:]
        
        self.currentQuestionListOffset = 0
        self.currentSearchOffset = 0
        
        self.appSingleton = AppSingleton.shared()
        
        self.monitor.pathUpdateHandler = { [unowned self] path in
            
            if path.status == .satisfied {
                print("We're connected!")
                self.appSingleton?.masterContainer?.connectionChanged(isConnected: true)
            } else {
                print("No connection.")
                self.appSingleton?.masterContainer?.connectionChanged(isConnected: false)
            }
            
            print(path.isExpensive)
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    // Accessors
    class func shared() -> NetworkManager {
        return sharedNetworkManager
    }
    
    // MARK: - Health Check
    
    func checkService(completion: ((Bool) ->())?) {
        
        healthService.getHealthState { (result, data) in
            
            if result.code != 200 || data == nil {
                completion?(false)
                return
            }
            print("checking")
            
            if data?.status?.uppercased() == "OK" {
                completion?(true)
            } else {
                completion?(false)
            }
        }
        
    }
    
    // MARK: - Questions
    
    func getQuestion(id: Int, completion: ((QuestionModel?)->())?) {
        
        if self.questions.count > 0 {
            let index = self.questions.firstIndex { (question) -> Bool in
                question.id == id
            }
            if index != nil {
                completion?(self.questions[index!])
                return
            }
        }
        
        questionService.getQuestion(questionID: id) { (result, data) in
            
            if result.code != 200 || data == nil {
                completion?(nil)
                return
            }
            print("reading questions")
            
            if let question = data{
                completion?(question)
                return
            }
            completion?(nil)
        }
    
    }

    
    func getQuestionList(completion: ((Bool)->())?) {
        questionService.getQuestionList(limit: 10, offset: self.currentQuestionListOffset, filter: nil) { [unowned self] (result, data) in
            
            if result.code != 200 || data == nil {
                completion?(false)
                return
            }
            print("reading questions")
            
            if let question = data{
                question.forEach{
                    print($0.id ?? "")
                    
                    self.questions.append($0)
//                    This would prevent duplicated IDs to be added to the list, since this is a mocked API I'll ignore this and add repeated questions
//                    let q0 = $0
//                    if (!self.questions.contains(where: { (q) -> Bool in
//                        q.id == q0.id
//                    })) {
//                        self.questions.append(q0)
//                    }
                }
            }
            self.currentQuestionListOffset = self.currentQuestionListOffset + 10
            self.appSingleton?.delegate?.refreshQuestionList()
            completion?(true)
        }
    }
    
    func updateAnswers(for question: QuestionModel, completion: ((Bool)->())?) {
        
        questionService.updateQuestion(question: question) { (result, data) in
            
            if result.code != 200 || data == nil {
                completion?(false)
                return
            }
            print("updating question \(String(describing: question.id))")
            
            completion?(true)
        }
    }
    

    // MARK: - Share
    
    func share(email: String, content: String, completion: ((Bool)->())?) {
        
        shareService.shareQuestion(destinationEmail: email, contentUrl: content) { (result, data)  in
            
            if result.code != 200 || data == nil {
                completion?(false)
                return
            }
            print("sharing")
            
            if data?.status?.uppercased() == "OK" {
                completion?(true)
            } else {
                completion?(false)
            }
        }
        
    }
    
    
    // MARK: - Search
    
    func search(term: String, completion: (([QuestionModel])->())?) {
        
        questionService.getQuestionList(limit: 10, offset: self.currentSearchOffset, filter: nil) { [unowned self] (result, data) in
            
            if result.code != 200 || data == nil {
                completion?([])
                return
            }
            print("reading questions")
            
            var searchResult = [QuestionModel]()
            if let question = data{
                question.forEach{
                    print($0.id ?? "")
                    
                    searchResult.append($0)
                }
            }
            self.currentSearchOffset = self.currentSearchOffset + 10
            self.appSingleton?.delegate?.refreshQuestionList()
            completion?(searchResult)
        }
        
    }
}
