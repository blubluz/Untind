//
//  MyAnswersTableViewCell.swift
//  Untind
//
//  Created by Honceriu Mihai on 07/08/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

class MyAnswersTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureDifferently() {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        
        questionLabel.attributedText = NSAttributedString(string: "Why do people in love, fight sometimes? What do you think about it?", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Bold", size: 16)!, NSAttributedString.Key.paragraphStyle : paragraphStyle])
        
        answerLabel.attributedText = NSAttributedString(string: "I think fights are as important as moments of joy. There might be hidden anger if some nuances are not solved and it can create huge problems later. Rip that bandaid off! I think fights are as important as moments of joy. There might be hidden anger if some nuances are not solved and it can create huge problems later. Rip that bandaid off!", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Italic", size: 14)!, NSAttributedString.Key.paragraphStyle : paragraphStyle])
        
        avatarImageView.image = UIImage(named: "avatar-1")
    }
    
}
