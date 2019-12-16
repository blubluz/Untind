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
    
    public var sender : MessageCellSender = .me {
        didSet {
           
        }
    }
    
    let messageTextView : UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        textView.textColor = UIColor.white
        textView.text = "Sample message"
        textView.backgroundColor = UIColor.clear
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    let textBubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.flatOrange
        view.layer.cornerRadius = 18
        view.layer.masksToBounds = true
        return view
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
    }
    
    func configureWithMessage(message: String, chatViewWidth: CGFloat, sender: MessageCellSender) {
        messageTextView.text = message
        
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: message).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Medium", size: 16)!], context: nil)
        
        var x : CGFloat = 8
        
        if sender == .me {
            x = chatViewWidth - estimatedFrame.width - 16 - 8 - 8
            textBubbleView.backgroundColor = UIColor.flatOrange
        } else {
            textBubbleView.backgroundColor = UIColor.answerTeal
        }
        
        self.messageTextView.frame = CGRect(x: x + 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
        
        self.textBubbleView.frame = CGRect(x: x, y: 0, width: estimatedFrame.width + 16 + 8, height: estimatedFrame.height + 20)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
