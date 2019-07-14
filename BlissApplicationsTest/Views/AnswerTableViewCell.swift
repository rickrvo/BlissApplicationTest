//
//  AnswerTableViewCell.swift
//  BlissApplicationsTest
//
//  Created by Henrique Ormonde on 09/07/19.
//  Copyright © 2019 Rick. All rights reserved.
//

import UIKit

class AnswerTableViewCell: UITableViewCell {
    
    var answer:Choices?
    var showVotes: Bool = false

    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var votesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func createCellOnTable(_ tableView : UITableView, answer: Choices, showingVotes: Bool) -> AnswerTableViewCell {
        let cell : AnswerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell") as! AnswerTableViewCell
        cell.answer = answer
        cell.showVotes = showingVotes
        cell.initValues()
        return cell
    }
    
    func initValues(){
        
        guard let a = answer else{
            return
        }
        
        self.answerLabel.text = a.choice
        self.votesLabel.text = "\(String(a.votes ?? 0)) votes"
        
        if showVotes {
            self.votesLabel.isHidden = false
        } else {
            self.votesLabel.isHidden = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            self.votesLabel.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                self.answerLabel.textColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                self.votesLabel.textColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            })
            
        }
    }

}
