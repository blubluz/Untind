//
//  ChatViewController.swift
//  Untind
//
//  Created by Honceriu Mihai on 13/11/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var bottomChatViewHeight: NSLayoutConstraint!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var messageTextViewBackground: UIView!
    @IBOutlet weak var bottomInputViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomInputView: UIView!
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messagesCollectionView: UICollectionView!
    
    
    var messageList: [String] = []
    
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
        
        messagesCollectionView.register(UINib(nibName: "MessageCell", bundle: nil), forCellWithReuseIdentifier: "MessageCell")
        if let flowLayout = messagesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: self.view.bounds.size.width, height: 50)
        }
        
        messagesCollectionView.delegate = self
        messagesCollectionView.dataSource = self
        
        messageTextView.delegate = self

    }
    
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        self.messageTextView.resignFirstResponder()
        messageList.append(self.messageTextView.text)
        self.messagesCollectionView.insertItems(at: [IndexPath(item: messageList.count-1, section: 0)])
        self.messageTextView.text = ""
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
    
    // MARK: - CollectionViewDelegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCell", for: indexPath) as! MessageCell
        cell.configureWithMessage(message: messageList[indexPath.row])
        
        if indexPath.row % 2 == 0 {
            cell.sender = .other
        } else {
            cell.sender = .me
        }
        
        return cell
        
    }
    
}
