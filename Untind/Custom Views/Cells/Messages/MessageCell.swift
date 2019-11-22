//
//  MessageCell.swift
//  Untind
//
//  Created by Honceriu Mihai on 21/11/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

enum MessageCellSender {
    case me
    case other
}
class MessageCell: UICollectionViewCell {

    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet var messageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var messageViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var msgViewLeadingOptionalConstraint: NSLayoutConstraint!
    @IBOutlet var msgViewTrailingOptionalConstraint: NSLayoutConstraint!
    
    public var sender : MessageCellSender = .me {
        didSet {
            if sender == .me {
                messageView.backgroundColor = UIColor.teal2
                messageViewTrailingConstraint.isActive = true
                messageViewLeadingConstraint.isActive = false
            } else {
                messageView.backgroundColor = UIColor.flatOrange
                messageViewTrailingConstraint.isActive = false
                messageViewLeadingConstraint.isActive = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageView.layer.cornerRadius = 16
    }
    
    func configureWithMessage(message: String) {
        cellLabel.text = message
    }

}
