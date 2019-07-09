//
//  LoadingViewController.swift
//  BlissApplicationsTest
//
//  Created by Henrique Ormonde on 06/07/19.
//  Copyright © 2019 Rick. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var networkManager: NetworkManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.networkManager = Networ
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }


}

