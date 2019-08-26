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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureWith(question: Question) {
        questionLabel.text = question.questionText
        answersNumberLabel.text = "\(question.answers.count)"
    }
}
