//
//  QuestionsListTableViewController.swift
//  BlissApplicationsTest
//
//  Created by Henrique Ormonde on 09/07/19.
//  Copyright © 2019 Rick. All rights reserved.
//

import UIKit

class QuestionsListTableViewController: UITableViewController, AppSingletonDelegate {
    
    @IBOutlet var questionsTableView: UITableView!
    
    var appSingleton: AppSingleton?
    var networkManager: NetworkManager?
    
    var tapped:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.appSingleton = AppSingleton.shared()
        self.appSingleton?.delegate = self
        self.networkManager = NetworkManager.shared()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.networkManager?.questions.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.networkManager?.questions.count ?? 0 > indexPath.item {
            return QuestionTableViewCell().createCellOnTable(tableView, question: (self.networkManager?.questions[indexPath.item])!)
        }
        
        return QuestionTableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tapped {
            return
        }
        tapped = true
        
        if let question = self.networkManager?.questions[indexPath.item] {
            let viewController:QuestionDetailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QuestionDetailsViewController") as! QuestionDetailsViewController
            viewController.question = question
            self.navigationController?.show(viewController, sender: self)
        }
        
        tapped = false
    }
    
    
    // MARK: - App Singleton Delegate
    
    func refreshQuestionList() {
        self.tableView.reloadData()
    }
    
    func serverHealthOK() {
        self.networkManager?.getQuestionList(completion: { [weak self] (success) in
            if success {
                self?.tableView.reloadData()
            }
        })
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