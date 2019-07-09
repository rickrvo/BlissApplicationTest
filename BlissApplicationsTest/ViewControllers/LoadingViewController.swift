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
        
        self.networkManager = NetworkManager.shared()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.label.text = "Checking server..."
        
        networkManager?.checkService(completion: { [unowned self] (success) in
            
            if success {
                // working
            } else {
                self.label.alpha = 0.0
                self.label.text = "Service Unavailable. Please try again later."
                
                UIView.animate(withDuration: 0.3, animations: {
                    
                    self.label.alpha = 1.0
                    
                }, completion: { (finish) in
                    
                    self.button.isHidden = false
                    
                })
                
                self.loader.stopAnimating()
            }
        })
    }

    @IBAction func retryTap(_ sender: Any) {
        
        self.button.isHidden = true
        
        self.label.alpha = 0.0
        self.label.text = "Checking server..."
        self.loader.startAnimating()
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.label.alpha = 1.0
            
        })
        
    }
    
    
}

