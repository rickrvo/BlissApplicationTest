//
//  ShareViewController.swift
//  BlissApplicationsTest
//
//  Created by Henrique Ormonde on 13/07/19.
//  Copyright © 2019 Rick. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {
    
    var question:QuestionModel?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var loaderView: UIActivityIndicatorView!
    @IBOutlet weak var confirmationLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    var networkManager: NetworkManager?
    
    var showErrorTimer:Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.networkManager = NetworkManager.shared()
        
        self.titleLabel.text = "You are about to share the question:\n\(self.question?.question ?? "")"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.emailField.becomeFirstResponder()
    }
    
    func sendEmail() {
        
        if isValidEmail(email: self.emailField.text ?? "") {
            self.sendButton.isEnabled = false
            self.loaderView.isHidden = false
            
            self.networkManager?.share(email: self.emailField.text!, content: "blissrecruitment://questions?question_id=\(String(question?.id ?? 1))", completion: { [unowned self] (success) in
                
                if success {
                    self.loaderView.isHidden = true
                    self.confirmationLabel.alpha = 0
                    self.confirmationLabel.isHidden = false
                    UIView.animate(withDuration: 0.3, animations: {
                        self.confirmationLabel.alpha = 1
                    }, completion: { (finish) in
                         self.navigationController?.popViewController(animated: true)
                    })
                } else {
                    self.sendButton.isEnabled = true
                    self.loaderView.isHidden = true
                }
            })
            
        } else {
            
            self.showErrorTimer?.invalidate()
            
            self.errorLabel.alpha = 0
            self.errorLabel.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                self.errorLabel.alpha = 1
                
            }) { (finish) in
                
                if finish {
                    self.showErrorTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true, block: { _ in
                        self.hideErrorLabel()
                    })
                }
            }
        }
        
    }
    
    func hideErrorLabel() {
        
        self.showErrorTimer?.invalidate()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.errorLabel.alpha = 0.0
        }) { (finished) in
            if finished {
                self.errorLabel.isHidden = true
            }
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func sendButtonTap(_ sender: Any) {
        self.sendEmail()
        self.view.endEditing(true)
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


extension ShareViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if isValidEmail(email: self.emailField.text ?? "") {
            self.view.endEditing(true)
        }
        self.sendEmail()
        return false
    }
    
    func isValidEmail(email: String) -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.count)) != nil
    }
}
