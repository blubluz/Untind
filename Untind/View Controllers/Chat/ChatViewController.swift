//
//  ChatViewController.swift
//  Untind
//
//  Created by Honceriu Mihai on 13/11/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var bottomChatViewHeight: NSLayoutConstraint!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var messageTextViewBackground: UIView!
    @IBOutlet weak var bottomInputViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomInputView: UIView!
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    
    
    var messageList: [Message] = []
    
    static func instantiate() -> ChatViewController {
        let vc = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        return vc
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        messageTextViewBackground.layer.borderWidth = 1
        messageTextViewBackground.layer.cornerRadius = 18
        messageTextViewBackground.layer.borderColor = UIColor.flatOrange.cgColor
        messageTextViewBackground.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        
        messageTextView.delegate = self

    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Keyboard Handling
       @objc func keyboardWillShow(_ notification: Notification) {
           if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                  let keyboardRectangle = keyboardFrame.cgRectValue
                  let keyboardHeight = keyboardRectangle.height
                  bottomInputView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight+20)
              }
       }
       
       @objc func keyboardWillHide(_ notification: Notification) {
           bottomInputView.transform = CGAffineTransform.identity
       }
    
    //MARK: - UITextView Delegate
  
    func textViewDidChange(_ textView: UITextView) {
        if textView == messageTextView {
            if textView.text != "" {
                placeHolderLabel.isHidden = true
                sendButton.isHidden = false
            } else {
                placeHolderLabel.isHidden = false
                sendButton.isHidden = true
            }
            
            bottomInputViewHeight.constant = min(max(30,textView.contentSize.height),120)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }

}
