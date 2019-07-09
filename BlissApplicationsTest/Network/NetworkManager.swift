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
    
    var totalGenreListPage : [Int : Int]
    var totalTopRatedPage : Int

    let monitor = NWPathMonitor()
    
    var masterContainerVC : MasterContainerViewController?
    
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
        
        self.monitor.pathUpdateHandler = { path in
            
            if path.status == .satisfied {
                print("We're connected!")
                self.masterContainerVC?.connectionChanged(isConnected: true)
            } else {
                print("No connection.")
                self.masterContainerVC?.connectionChanged(isConnected: false)
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
                    let g0 = $0
                    if (!self.questions.contains(where: { (g) -> Bool in
                        g.id == g0.id
                    })) {
                        self.questions.append(g0)
                    }
                }
            }
            self.currentQuestionListOffset = self.questions.last?.id ?? self.currentQuestionListOffset + 10
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
