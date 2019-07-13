//
//  MasterContainerViewController.swift
//  BlissApplicationsTest
//
//  Created by Henrique Ormonde on 09/07/19.
//  Copyright © 2019 Rick. All rights reserved.
//

import UIKit
import Network

class MasterContainerViewController: UIViewController {

    @IBOutlet weak var noConnectionView: UIView!
    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var networkManager: NetworkManager?
    var appSingleton: AppSingleton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.networkManager = NetworkManager.shared()
        
        self.appSingleton = AppSingleton.shared()
        self.appSingleton?.masterContainer = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.label.text = "Checking server..."
        
        self.checkService()
    }
    
    func checkService() {
        
        networkManager?.checkService(completion: { [unowned self] (success) in
            
            if success {
                
                self.appSingleton?.delegate?.serverHealthOK()
                
                self.loadingView.alpha = 1
                
                UIView.animate(withDuration: 0.3, animations: {
                    
                    self.loadingView.alpha = 0
                    
                }, completion: { (finish) in
                    
                    self.loadingView.isHidden = true
                })
                
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
            
        }, completion: { (finish) in
            
            self.checkService()
        })
        
    }
    
    public func connectionChanged(isConnected: Bool) {
        if isConnected {
            self.noConnectionView.alpha = 1
            self.noConnectionView.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                self.noConnectionView.alpha = 0
            }) { (finish) in
                self.noConnectionView.isHidden = true
            }
        } else {
            self.noConnectionView.alpha = 0
            self.noConnectionView.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                self.noConnectionView.alpha = 1
            }) { (finish) in
                self.noConnectionView.isHidden = false
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
