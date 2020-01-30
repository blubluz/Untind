//
//  ProfileEmptyStateCell.swift
//  Untind
//
//  Created by Mihai Honceriu on 30/01/2020.
//  Copyright © 2020 FincPicsels. All rights reserved.
//

import UIKit



class ProfileEmptyStateCell: UICollectionViewCell {

    enum EmptyStateCellMode {
        case leftOriented
        case rightOriented
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var bottomButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @discardableResult
    func update(withTitle title: String, message: String, mode: EmptyStateCellMode, image: UIImage?) -> ProfileEmptyStateCell {
        self.titleLabel.text = title
        self.messageLabel.text = message
        
        switch mode {
        case .leftOriented:
            titleLabel.textAlignment = .left
            messageLabel.textAlignment = .left
            leftImageView.isHidden = true
            rightImageView.image = image
        case .rightOriented:
            titleLabel.textAlignment = .right
            messageLabel.textAlignment = .right
            rightImageView.isHidden = true
            leftImageView.image = image
        }
        
        return self
    }
}
