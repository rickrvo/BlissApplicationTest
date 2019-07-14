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
    var filteredQuestions = [QuestionModel]()
    
    let searchController = UISearchController(searchResultsController: nil)
    var currentSearchString: String = ""
    var tapped: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.appSingleton = AppSingleton.shared()
        self.appSingleton?.delegate = self
        self.appSingleton?.questionsVC = self
        self.networkManager = NetworkManager.shared()
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Questions"
        navigationItem.searchController = searchController
        definesPresentationContext = true

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.checkDeeplink()
    }
    
    func checkDeeplink() {
        
        if let term = appSingleton?.deeplinkParameters {
            
            if term["question_id"] != nil {
                
                let viewController:QuestionDetailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QuestionDetailsViewController") as! QuestionDetailsViewController
                viewController.question = nil
                viewController.questionID = term["question_id"]
                self.navigationController?.show(viewController, sender: self)
                
            } else if term["question_filter"] != nil {
                
                self.searchController.searchBar.becomeFirstResponder()
                self.searchController.searchBar.text = term["question_filter"]
                
            } else {
                
                self.searchController.searchBar.becomeFirstResponder()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering() {
            return filteredQuestions.count
        }
        return self.networkManager?.questions.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isFiltering() {
            if self.filteredQuestions.count > indexPath.item {
                return QuestionTableViewCell().createCellOnTable(tableView, question: self.filteredQuestions[indexPath.item])
            }
        } else {
            if self.networkManager?.questions.count ?? 0 > indexPath.item {
                return QuestionTableViewCell().createCellOnTable(tableView, question: (self.networkManager?.questions[indexPath.item])!)
            }
        }
        
        return QuestionTableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tapped {
            return
        }
        tapped = true
        
        if isFiltering() {
            
            if self.filteredQuestions.count > indexPath.item {
                let viewController:QuestionDetailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QuestionDetailsViewController") as! QuestionDetailsViewController
                viewController.question = self.filteredQuestions[indexPath.item]
                self.navigationController?.show(viewController, sender: self)
            }
            
        } else {
            
            if let question = self.networkManager?.questions[indexPath.item] {
                let viewController:QuestionDetailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QuestionDetailsViewController") as! QuestionDetailsViewController
                viewController.question = question
                self.navigationController?.show(viewController, sender: self)
            }
        }
        
        tapped = false
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if isFiltering() {
            
            if indexPath.item >= (filteredQuestions.count - 1) {
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                
                networkManager?.search(term: self.currentSearchString, completion: { [unowned self] (result) in
                    
                    if result.count > 0 {
                        for question in result {
                            self.filteredQuestions.append(question)
                        }
                        self.tableView.reloadData()
                    }
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                })
            }
            
        } else {
            
            if indexPath.item >= ((networkManager?.questions.count ?? 0) - 1) {
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                
                self.networkManager?.getQuestionList(completion: { [unowned self] (success) in
                    if success {
                        self.tableView.reloadData()
                    }
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                })
            }
        }
    }
    
    override func tableView(_: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)  -> UISwipeActionsConfiguration {
        
        let shareAction = self.contextualToggleFlagAction(forRowAtIndexPath: indexPath)
        let swipeConfig = UISwipeActionsConfiguration(actions: [shareAction])
        return swipeConfig
    }
    
    func contextualToggleFlagAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        
        if isFiltering() {
            
            if self.filteredQuestions.count > indexPath.item {
                
                let action = UIContextualAction(style: .normal,
                                                title: "Share") { [unowned self] (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
                                                    
                                                    let viewController:ShareViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShareViewController") as! ShareViewController
                                                    viewController.question = self.filteredQuestions[indexPath.item]
                                                    self.navigationController?.show(viewController, sender: self)
                                                    completionHandler(true)
                }
                
                action.image = UIImage(named: "share")
                action.backgroundColor = UIColor.green
                
                return action
            }
            
        } else {
            
            if let question = self.networkManager?.questions[indexPath.item] {
                
                let action = UIContextualAction(style: .normal,
                                                title: "Share") { [unowned self] (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
                                                    
                                                    let viewController:ShareViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShareViewController") as! ShareViewController
                                                    viewController.question = question
                                                    self.navigationController?.show(viewController, sender: self)
                                                    completionHandler(true)
                }
                
                action.image = UIImage(named: "share")
                action.backgroundColor = UIColor.green
                
                return action
            }
        }
        
        return UIContextualAction()
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


extension QuestionsListTableViewController: UISearchResultsUpdating {
    
    // MARK: - UISearchResultsUpdating Delegate
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String) {
        self.currentSearchString = searchText
        
        if searchBarIsEmpty() {
            filteredQuestions.removeAll()
            networkManager?.currentSearchOffset = 0
            return
        }
        

        networkManager?.search(term: searchText, completion: { [unowned self] (result) in
            
            if result.count > 0 {
                for question in result {
                    self.filteredQuestions.append(question)
                }
                self.tableView.reloadData()
            }
        })
    }

    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }

}

