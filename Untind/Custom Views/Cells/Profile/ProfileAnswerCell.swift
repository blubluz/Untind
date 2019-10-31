//
//  ProfileAnswerCell.swift
//  Untind
//
//  Created by Honceriu Mihai on 15/10/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

class ProfileAnswerCell: UITableViewCell {

    @IBOutlet weak var cellContainerView: UIView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var quoteIcon: UIImageView!
    @IBOutlet weak var questionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        cellContainerView.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func stopAnimation() {
        
    }
    
    func configureWith(answer: Answer) {
        answerLabel.text = answer.answerText
        questionLabel.text = answer.question?.questionText
    }
    
}
