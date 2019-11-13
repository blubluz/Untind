//
//  ChatViewController.swift
//  Untind
//
//  Created by Honceriu Mihai on 13/11/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    @IBOutlet weak var bottomChatViewHeight: NSLayoutConstraint!
    @IBOutlet weak var messageTextView: UITextView!
    
    
    
    static func instantiate() -> ChatViewController {
        let vc = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        return vc
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Keyboard Handling
       @objc func keyboardWillShow(_ notification: Notification) {
           if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                  let keyboardRectangle = keyboardFrame.cgRectValue
                  let keyboardHeight = keyboardRectangle.height
                  messageTextView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
              }
       }
       
       @objc func keyboardWillHide(_ notification: Notification) {
           messageTextView.transform = CGAffineTransform.identity
       }


}
