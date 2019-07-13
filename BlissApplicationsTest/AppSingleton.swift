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
    weak var delegate: AppSingletonDelegate?
    
    private static var sharedAppManager: AppSingleton = {
        let appManager = AppSingleton()
        return appManager
    }()
    
    // Accessors
    class func shared() -> AppSingleton {
        return sharedAppManager
    }
    
}
