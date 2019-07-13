//
//  QuestionDetailsViewController.swift
//  BlissApplicationsTest
//
//  Created by Henrique Ormonde on 09/07/19.
//  Copyright © 2019 Rick. All rights reserved.
//

import UIKit

class QuestionDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var question:QuestionModel?
    
    @IBOutlet weak var questionTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var alreadyAnswered:Bool = false
    var networkManager: NetworkManager?
    
    var tapped: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.networkManager = NetworkManager.shared()
        
        if let q = question {
            self.questionTitle.text = q.question
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Table view delegates
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return question?.choices?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.question?.choices?.count ?? 0 > indexPath.item {
            return AnswerTableViewCell().createCellOnTable(tableView, answer: (self.question?.choices?[indexPath.item])!, showingVotes: self.alreadyAnswered)
        }
        
        return AnswerTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return !alreadyAnswered
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if alreadyAnswered {
            return
        }
        alreadyAnswered = true
        
        if let votes = self.question?.choices![indexPath.item].votes {
            self.question?.choices![indexPath.item].votes = votes + 1
        } else {
            alreadyAnswered = false
            return
        }
        
        self.networkManager?.updateAnswers(for: self.question!, completion: { [weak self] (success) in
            if success {
                print("updated")
                self?.tableView.reloadData()
            } else {
                print("update failed")
                self?.alreadyAnswered = false
            }
        })
    }
    
    
    // MARK: - Actions
    
    @IBAction func shareButtonTap(_ sender: Any) {
        
        if tapped {
            return
        }
        tapped = true
        
        let viewController:ShareViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShareViewController") as! ShareViewController
        viewController.question = question
        self.navigationController?.show(viewController, sender: self)
        
        tapped = false
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
