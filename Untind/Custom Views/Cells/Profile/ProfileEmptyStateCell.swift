//
//  ProfileEmptyStateCell.swift
//  Untind
//
//  Created by Mihai Honceriu on 30/01/2020.
//  Copyright © 2020 FincPicsels. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

protocol ProfileEmptyStateDelegate : NSObject {
    func didTapButton()
}

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
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
    weak var delegate : ProfileEmptyStateDelegate?
    var mode : EmptyStateCellMode = .leftOriented
    var isLoading = true {
        didSet {
            if isLoading {
                self.setOutletsAlpha(alpha: 0)
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
                UIView.animate(withDuration: 1.2, delay: 0, options: .curveEaseOut, animations: {
                    self.titleLabel.alpha = 1
                    self.messageLabel.alpha = 1
                    self.rightImageView.alpha = 1
                    self.leftImageView.alpha = 1
                    self.bottomButton.alpha = 1
                })
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setOutletsAlpha(alpha: CGFloat) {
        self.titleLabel.alpha = alpha
        self.messageLabel.alpha = alpha
        self.bottomButton.alpha = alpha
        self.rightImageView.alpha = alpha
        self.leftImageView.alpha = alpha
    }
    
    @discardableResult
    func update(withTitle title: String, message: String, buttonTitle: String?, mode: EmptyStateCellMode, image: UIImage?, isLoading : Bool) -> ProfileEmptyStateCell {
        self.mode = mode
        self.titleLabel.text = title
        self.messageLabel.attributedText = NSAttributedString(string: message).withLineSpacing(6)
        
        if buttonTitle == nil {
            bottomButton.isHidden = true
        } else {
            bottomButton.isHidden = false
            bottomButton.setTitle(buttonTitle, for: .normal)
        }
        
        switch mode {
        case .leftOriented:
            activityIndicator.color = UIColor.flatOrange
            titleLabel.textColor = UIColor.flatOrange
            bottomButton.backgroundColor = UIColor.flatOrange
            titleLabel.textAlignment = .left
            messageLabel.textAlignment = .left
            leftImageView.isHidden = true
            rightImageView.image = image
        case .rightOriented:
            activityIndicator.color = UIColor.teal2
            titleLabel.textColor = UIColor.teal2
            bottomButton.backgroundColor = UIColor.teal2
            titleLabel.textAlignment = .right
            messageLabel.textAlignment = .right
            rightImageView.isHidden = true
            leftImageView.image = image
        }
        
        self.isLoading = isLoading
        return self
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        self.delegate?.didTapButton()
    }
    
    override func prepareForReuse() {
        leftImageView.isHidden = false
        rightImageView.isHidden = false
        self.isLoading = true
        self.setOutletsAlpha(alpha: 0)
    }
}
