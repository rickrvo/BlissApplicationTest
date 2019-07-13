//
//  NetworkManager.swift
//  BlissApplicationsTest
//
//  Created by Henrique Ormonde on 07/07/19.
//  Copyright © 2019 Rick. All rights reserved.
//

import Foundation

class NetworkManager {
    
    var questions : [QuestionModel]
    var genresList : [Int : [QuestionModel]]
    
    var currentQuestionListOffset : Int
    
    var totalGenreListPage : [Int : Int]
    var totalTopRatedPage : Int

    
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
    
    func getQuestion(id: Int) -> QuestionModel? {
        
        if self.questions.count > 0 {
            let index = self.questions.firstIndex { (question) -> Bool in
                question.id == id
            }
            if index != nil {
                return self.questions[index!]
            }
        }
        return nil
    }

    
    func getQuestionList(completion: ((Bool)->())?) {
        questionService.getQuestionList(limit: 10, offset: self.currentQuestionListOffset, filter: nil) { [unowned self] (result, data) in
            if result.code != 200 || data == nil {
                completion?(false)
                return
            }
            print("reading questions")
            if let genre = data{
                genre.forEach{
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
}
