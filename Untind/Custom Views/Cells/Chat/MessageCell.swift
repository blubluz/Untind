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
    
    var leadingConstraint : NSLayoutConstraint!
    var trailingConstraint : NSLayoutConstraint!
    
    public var sender : MessageCellSender = .me {
        didSet {
           
        }
    }
    
    let messageTextView : UITextView = {
        let textView = UITextView()
        textView.font = UIFont.helveticaNeue(weight: .regular, size: 16)
        textView.textColor = UIColor.darkBlue
        textView.text = "Sample message"
        textView.backgroundColor = UIColor.clear
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    let textBubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.flatOrange
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageContainer : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 47/2
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "avatar-35")
        iv.frame = CGRect(x: 0, y: 0, width: 40, height: 42)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    func setupViews() {
        addSubview(textBubbleView)
        addSubview(messageTextView)
        addSubview(profileImageContainer)
        addSubview(profileImageView)
        
        leadingConstraint = profileImageContainer.leadingAnchor.constraint(equalTo: textBubbleView.leadingAnchor, constant: -47/2 + 8)
        trailingConstraint = profileImageContainer.trailingAnchor.constraint(equalTo: textBubbleView.trailingAnchor, constant: 47/2 - 8)
        
        profileImageContainer.activateConstraints([
            profileImageContainer.heightAnchor.constraint(equalToConstant: 47),
            profileImageContainer.widthAnchor.constraint(equalToConstant: 47),
            profileImageContainer.topAnchor.constraint(equalTo: textBubbleView.topAnchor, constant: 0),
            leadingConstraint
        ])
        
        profileImageView.activateConstraints([
            profileImageView.centerYAnchor.constraint(equalTo: profileImageContainer.centerYAnchor),
            profileImageView.centerXAnchor.constraint(equalTo: profileImageContainer.centerXAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 42),
            profileImageView.widthAnchor.constraint(equalToConstant: 40)])
    }
    
    func configureWithMessage(message: UTMessage, avatar: String, chatViewWidth: CGFloat) {
        messageTextView.attributedText = NSAttributedString(string: message.messageText, attributes: [ NSAttributedString.Key.font : UIFont.helveticaNeue(weight: .regular, size: 16), NSAttributedString.Key.paragraphStyle : NSAttributedString.lineSpacingParagraphStyle(spacing: 5)])
        profileImageView.image = UIImage(named: avatar)
        
        let size = CGSize(width: 250, height: CGFloat.infinity)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: message.messageText).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.helveticaNeue(weight: .regular, size: 16), NSAttributedString.Key.paragraphStyle : NSAttributedString.lineSpacingParagraphStyle(spacing: 5)], context: nil)
        
        
        let leftRightPadding : CGFloat = 43
        var textPaddingLeft : CGFloat = 30
        var textPaddingRight : CGFloat = 20
        
        var x : CGFloat = leftRightPadding
        
        if message.authorUid.isMyId {
            leadingConstraint.isActive = false
            trailingConstraint.isActive = true
            textPaddingLeft  = 5
            textPaddingRight  = 35
            x = chatViewWidth - estimatedFrame.width - 2*leftRightPadding
            textBubbleView.backgroundColor = UIColor.chatColorMyself
        } else {
            leadingConstraint.isActive = true
            trailingConstraint.isActive = false
            textBubbleView.backgroundColor = UIColor.white
        }
        self.messageTextView.frame = CGRect(x: x + textPaddingLeft, y: 5, width: estimatedFrame.width + 10, height: estimatedFrame.height + 28)
        
        self.textBubbleView.frame = CGRect(x: x, y: 0, width: estimatedFrame.width + textPaddingLeft + textPaddingRight, height: estimatedFrame.height + 28)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
