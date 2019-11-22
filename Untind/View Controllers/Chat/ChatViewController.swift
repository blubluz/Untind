//
//  ChatViewController.swift
//  Untind
//
//  Created by Honceriu Mihai on 13/11/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    @IBOutlet weak var bottomChatViewHeight: NSLayoutConstraint!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var messageTextViewBackground: UIView!
    @IBOutlet weak var bottomInputViewHeight: NSLayoutConstraint!
    @IBOutlet weak var messageInputViewBottomConstraint: NSLayoutConstraint!
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
        messageList = ["Hello. I have sent you a message to let you know about our meeting next week. We should find some time to meet before friday, if possible", "Hey, sure let me check up my schedule", "Okay", "What about monday? I have a few meetings in the morning, but i think i can squeeze this one in." , "Sounds nice. Dinner?", "Yup"]
        
        messageTextViewBackground.layer.borderWidth = 1
        messageTextViewBackground.layer.cornerRadius = 18
        messageTextViewBackground.layer.borderColor = UIColor.flatOrange.cgColor
        messageTextViewBackground.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        messagesCollectionView.register(MessageCell.self, forCellWithReuseIdentifier: "MessageCell")
        messagesCollectionView.delegate = self
        messagesCollectionView.dataSource = self
        
        messageTextView.delegate = self
        

        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        messagesCollectionView.addGestureRecognizer(tap)
        
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func resetMessageTextView() {
        if messageTextView.text != "" {
            placeHolderLabel.isHidden = true
            sendButton.isHidden = false
        } else {
            placeHolderLabel.isHidden = false
            sendButton.isHidden = true
        }
    }
    
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        messageList.append(self.messageTextView.text)
        self.messagesCollectionView.insertItems(at: [IndexPath(item: messageList.count-1, section: 0)])
        self.messageTextView.text = ""
        self.messagesCollectionView.scrollToItem(at: IndexPath(item: messageList.count-1, section: 0), at: .top, animated: true)
        messageTextView.resignFirstResponder()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Keyboard Handling
    @objc func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            messageInputViewBottomConstraint.constant = keyboardHeight + 20
            
            UIView.animate(withDuration: 0, animations: {
                self.view.layoutIfNeeded()
            }) { (completed) in
                self.messagesCollectionView.scrollToItem(at: IndexPath(item: self.messageList.count-1, section: 0), at: .bottom, animated: true)
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        messageInputViewBottomConstraint.constant = 0
        
        UIView.animate(withDuration: 0, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    //MARK: - UITextView Delegate
    
    func textViewDidChange(_ textView: UITextView) {
        resetMessageTextView()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    // MARK: - ScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }
    
    // MARK: - CollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let messageText = messageList[indexPath.item]
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
        
        return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCell", for: indexPath) as! MessageCell
        cell.configureWithMessage(message: messageList[indexPath.row], chatViewWidth: messagesCollectionView.frame.size.width, sender: indexPath.row % 2 == 0 ? .me : .other)
        
        return cell
        
    }
    
}
