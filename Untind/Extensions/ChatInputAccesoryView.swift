//
//  ChatInputAccesoryView.swift
//  Untind
//
//  Created by Honceriu Mihai on 03/12/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import Foundation
import UIKit
protocol ChatInputAccesoryDelegate : class {
    func didTapSend()
}

class ChatInputAccesoryView : UIView {
    
    weak var chatDelegate : ChatInputAccesoryDelegate?
    
    var text : String {
        get {
            return messageTextView.text
        }
        set {
            messageTextView.text = newValue
        }
    }
    
    private lazy var messageTextViewBackground : UIView = {
        let v = UIView()
        self.addSubview(v)
        
        v.activateConstraints([
            v.topAnchor.constraint(equalTo: self.topAnchor, constant: 2),
            v.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor, constant: -6),
            v.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2),
            v.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -2)
        ])
        
        v.layer.borderWidth = 1
        v.layer.cornerRadius = 18
        v.layer.borderColor = UIColor.flatOrange.cgColor
        v.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        return v
    }()
    
    private var messageTextViewHeightConstraint : NSLayoutConstraint?
    
    private lazy var messageTextView : UITextView = {
        let tv = UITextView()
        self.messageTextViewBackground.addSubview(tv)
        self.messageTextViewHeightConstraint =  tv.heightAnchor.constraint(equalToConstant: 37)
        tv.activateConstraints([
            tv.leadingAnchor.constraint(equalTo: messageTextViewBackground.leadingAnchor, constant: 8),
            tv.topAnchor.constraint(equalTo: messageTextViewBackground.topAnchor),
            tv.bottomAnchor.constraint(equalTo: messageTextViewBackground.bottomAnchor),
            self.messageTextViewHeightConstraint!])
        tv.delegate = self
        tv.backgroundColor = UIColor.clear
        tv.textColor = UIColor.gray81
        tv.font = UIFont.helveticaNeue(weight: .normal, size: 17)
        
        return tv
    }()
    
    private lazy var sendButton : UIButton = {
        let btn = UIButton()
        self.messageTextViewBackground.addSubview(btn)
        btn.activateConstraints([
            btn.trailingAnchor.constraint(equalTo: self.messageTextViewBackground.trailingAnchor, constant: -15),
            btn.leadingAnchor.constraint(equalTo: self.messageTextView.trailingAnchor, constant: 10),
            btn.centerYAnchor.constraint(equalTo: self.messageTextViewBackground.centerYAnchor)
        ])
        
        btn.setTitleColor(UIColor.flatOrange, for: .normal)
        btn.titleLabel?.font = UIFont.helveticaNeue(weight: .bold, size: 15)
        btn.setTitle("Send", for: .normal)
        btn.addTarget(self, action: #selector(didTapSendBtn(_:)), for: .touchUpInside)
        
        return btn
    }()
    
    private lazy var placeholder : UILabel = {
        let lb = UILabel()
        self.messageTextViewBackground.addSubview(lb)
        lb.activateConstraints( [
            lb.leadingAnchor.constraint(equalTo: messageTextViewBackground.leadingAnchor, constant: 15),
            lb.centerYAnchor.constraint(equalTo: messageTextViewBackground.centerYAnchor)])
        lb.font = UIFont.helveticaNeue(weight: .normal, size: 15)
        lb.textColor = UIColor.init(white: 0, alpha: 0.35)
        lb.text = "Message..."
        return lb
    }()
    
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        _ = messageTextViewBackground
        _ = messageTextView
        _ = sendButton
        _ = placeholder
    }
    
    init() {
        super.init(frame: .zero)
        self.autoresizingMask = .flexibleHeight
        _ = messageTextViewBackground
        _ = messageTextView
        _ = sendButton
        _ = placeholder
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 0.0)
    }
    
    //MARK: - Actions
       @objc func didTapSendBtn(_ btn: UIButton) {
           chatDelegate?.didTapSend()
           messageTextViewHeightConstraint?.constant = min(max(37,messageTextView.contentSize.height),120)
       }
}

extension ChatInputAccesoryView : UITextViewDelegate {
    func resetMessageTextView() {
         if messageTextView.text != "" {
             placeholder.isHidden = true
             sendButton.isHidden = false
         } else {
             placeholder.isHidden = false
             sendButton.isHidden = true
         }
     }
    
    func textViewDidChange(_ textView: UITextView) {
          resetMessageTextView()
          messageTextViewHeightConstraint?.constant = min(max(37,textView.contentSize.height),120)
      }
    
}
