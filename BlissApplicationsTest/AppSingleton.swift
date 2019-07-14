//
//  AppSingleton.swift
//  BlissApplicationsTest
//
//  Created by Henrique Ormonde on 11/07/19.
//  Copyright © 2019 Rick. All rights reserved.
//

import Foundation

protocol AppSingletonDelegate: class {
    func refreshQuestionList()
    func serverHealthOK()
}


class AppSingleton {
    
    var masterContainer: MasterContainerViewController?
    var questionsVC: QuestionsListTableViewController?
    weak var delegate: AppSingletonDelegate?
    
    var deeplinkParameter: String?
    
    private static var sharedAppManager: AppSingleton = {
        let appManager = AppSingleton()
        return appManager
    }()
    
    // Accessors
    class func shared() -> AppSingleton {
        return sharedAppManager
    }
    
}
