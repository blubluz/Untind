//
//  ProfileQuestionCell.swift
//  Untind
//
//  Created by Honceriu Mihai on 14/10/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

class ProfileQuestionCell: UITableViewCell {

    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        questionView.layer.cornerRadius = 20.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWith(question: Post) {
        questionLabel.text = question.questionText
        commentsLabel.text = "\(question.answers?.count ?? 0) COMMENTS"
    }
}
