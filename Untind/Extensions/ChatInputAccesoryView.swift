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
            v.topAnchor.constraint(equalTo: self.topAnchor),
            v.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        v.backgroundColor = UIColor.white
        
        return v
    }()
    
    private var messageTextViewHeightConstraint : NSLayoutConstraint?
    
    private lazy var leftBarView : UIView = {
        let v = UIView()
        self.messageTextViewBackground.addSubview(v)
        v.activateConstraints([
            v.leadingAnchor.constraint(equalTo: messageTextViewBackground.leadingAnchor, constant: 20),
            v.centerYAnchor.constraint(equalTo: messageTextViewBackground.centerYAnchor, constant: 0),
            v.heightAnchor.constraint(equalToConstant: 32),
            v.widthAnchor.constraint(equalToConstant: 5)])
        
        v.backgroundColor = UIColor.lightGreen
        v.layer.cornerRadius = 2.5
        
        return v
    }()
    
    private lazy var messageTextView : VerticallyCenteredTextView = {
        let tv = VerticallyCenteredTextView()
        self.messageTextViewBackground.addSubview(tv)
        self.messageTextViewHeightConstraint =  tv.heightAnchor.constraint(equalToConstant: 62)
        tv.activateConstraints([
            tv.leadingAnchor.constraint(equalTo: leftBarView.leadingAnchor, constant: 15),
            tv.topAnchor.constraint(equalTo: messageTextViewBackground.topAnchor),
            tv.bottomAnchor.constraint(equalTo: messageTextViewBackground.bottomAnchor),
            self.messageTextViewHeightConstraint!])
        
        tv.delegate = self
        tv.backgroundColor = UIColor.clear
        tv.textColor = UIColor.gray81
        tv.font = UIFont.helveticaNeue(weight: .regular, size: 17)
        
        return tv
    }()
    
    private lazy var sendButton : UIButton = {
        let btn = UIButton()
        self.messageTextViewBackground.addSubview(btn)
        btn.activateConstraints([
            btn.trailingAnchor.constraint(equalTo: self.messageTextViewBackground.trailingAnchor, constant: -15),
            btn.leadingAnchor.constraint(equalTo: self.messageTextView.trailingAnchor, constant: 10),
            btn.centerYAnchor.constraint(equalTo: self.messageTextViewBackground.centerYAnchor),
            btn.widthAnchor.constraint(equalToConstant: 66),
            btn.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.helveticaNeue(weight: .medium, size: 12)
        btn.setTitle("SEND", for: .normal)
        btn.backgroundColor = UIColor.lightGreen
        btn.layer.cornerRadius = 16
        btn.addTarget(self, action: #selector(didTapSendBtn(_:)), for: .touchUpInside)
        
        return btn
    }()
    
    private lazy var placeholder : UILabel = {
        let lb = UILabel()
        self.messageTextViewBackground.addSubview(lb)
        lb.activateConstraints( [
            lb.leadingAnchor.constraint(equalTo: messageTextView.leadingAnchor, constant: 15),
            lb.centerYAnchor.constraint(equalTo: messageTextView.centerYAnchor)])
        lb.font = UIFont.helveticaNeue(weight: .regular, size: 14)
        lb.textColor = UIColor.gray(value: 172)
        lb.text = "start typing"
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
           messageTextViewHeightConstraint?.constant =  min(max(62,messageTextView.contentSize.height),120)
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
          messageTextViewHeightConstraint?.constant = min(max(62,textView.contentSize.height),120)
      }
    
}
