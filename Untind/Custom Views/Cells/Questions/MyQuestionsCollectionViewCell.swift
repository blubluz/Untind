//
//  MyQuestionsCollectionViewCell.swift
//  Untind
//
//  Created by Honceriu Mihai on 06/08/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

class MyQuestionsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var questionLabel: VerticalAlignLabel!
    @IBOutlet weak var newQuestionsLabel: UILabel!
    @IBOutlet weak var answersNumberLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 20
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 4, height: 4)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.2
        self.layer.masksToBounds = false
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 20).cgPath
    }
    
    func configureWith(question: Question) {
        questionLabel.text = question.questionText
        answersNumberLabel.text = "\(question.answers?.count ?? 0)"
    }
}
