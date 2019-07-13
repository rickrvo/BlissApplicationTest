//
//  QuestionTableViewCell.swift
//  BlissApplicationsTest
//
//  Created by Henrique Ormonde on 07/07/19.
//  Copyright © 2019 Rick. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {

    @IBOutlet weak var questionLabel: UILabel!
    
    var question:QuestionModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func createCellOnTable(_ tableView : UITableView, question: QuestionModel) -> QuestionTableViewCell {
        let cell : QuestionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell") as! QuestionTableViewCell
        cell.question = question
        cell.initValues()
        return cell
    }
    
    func initValues(){
        
        guard let q = question?.question else{
            return
        }
        
        questionLabel.text = q
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
