//
//  ChatViewController.swift
//  Untind
//
//  Created by Honceriu Mihai on 13/11/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, ChatInputAccesoryDelegate {
    
    @IBOutlet weak var messagesCollectionView: UICollectionView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var chatBackgroundImage: UIImageView!
    @IBOutlet weak var emptyChatBackgroundImage: UIImageView!
    @IBOutlet weak var emptyChatLabel: UILabel!
    
    private lazy var chatInputAccesory : ChatInputAccesoryView = {
        let cv = ChatInputAccesoryView()
        cv.chatDelegate = self
        return cv
    }()
    
    var messageList: [String] = []
    var shouldScrollToBottom = true
    
    static func instantiate() -> ChatViewController {
        let vc = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        messageList = ["Hello. I have sent you a message to let you know about our meeting next week. We should find some time to meet before friday, if possible", "Hey, sure let me check up my schedule", "Okay", "What about monday? I have a few meetings in the morning, but i think i can squeeze this one in." , "Sounds nice. Dinner?", "Yup"]
        
        
        messagesCollectionView.register(MessageCell.self, forCellWithReuseIdentifier: "MessageCell")
        messagesCollectionView.delegate = self
        messagesCollectionView.dataSource = self
        messagesCollectionView.keyboardDismissMode = .interactive
        
        topView.roundCorners(cornerRadius: 20, corners: [.bottomLeft,.bottomRight])

        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        messagesCollectionView.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = chatInputAccesory
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if shouldScrollToBottom {
            shouldScrollToBottom = false
            scrollToBottom(animated: false)
        }
    }
    
    func scrollToBottom(animated: Bool) {
        view.layoutIfNeeded()
        messagesCollectionView.setContentOffset(bottomOffset(), animated: animated)
    }
    
    func bottomOffset() -> CGPoint {
        return CGPoint(x: 0, y: max(-messagesCollectionView.contentInset.top, messagesCollectionView.contentSize.height - (messagesCollectionView.bounds.size.height - messagesCollectionView.contentInset.bottom)))
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var canResignFirstResponder: Bool {
        return true
    }
    
    override var inputAccessoryView: UIView? {
        get {
           return chatInputAccesory
        }
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
 
    
    func didTapSend() {
        if self.chatInputAccesory.text == "" {
            return
        }
        
        messageList.append(self.chatInputAccesory.text)
        self.messagesCollectionView.insertItems(at: [IndexPath(item: messageList.count-1, section: 0)])
        self.chatInputAccesory.text = ""
        self.chatInputAccesory.resetMessageTextView()
        self.messagesCollectionView.scrollToItem(at: IndexPath(item: messageList.count-1, section: 0), at: .top, animated: true)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Keyboard Handling
    @objc func keyboardWillShow(_ notification: Notification) {
        adjustContentForKeyboard(shown: true, notification: notification)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        adjustContentForKeyboard(shown: false, notification: notification)
    }
    
    func adjustContentForKeyboard(shown: Bool, notification: Notification) {
        guard let keyboardEndFrameValue: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue, let keyboardBeginFrameValue : NSValue = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardEndFrame = keyboardEndFrameValue.cgRectValue
        let keyboardBeginFrame = keyboardBeginFrameValue.cgRectValue
        
        let keyboardHeight = keyboardEndFrame.height
        if shown == true {
            if keyboardEndFrame.size.height <= keyboardBeginFrame.size.height {
                        return
            }
            
//            keyboardHeight = min(keyboardEndFrame.height, keyboardBeginFrame.height)
        }
        
        if messagesCollectionView.contentInset.bottom == keyboardHeight {
            return
        }
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        
        let distanceFromBottom = bottomOffset().y - messagesCollectionView.contentOffset.y
     
        var insets = messagesCollectionView.contentInset
        
        insets.bottom = keyboardHeight

        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve), animations: {
            self.messagesCollectionView.contentInset = insets
            self.messagesCollectionView.scrollIndicatorInsets = insets
     
            if distanceFromBottom < 10 {
                self.messagesCollectionView.contentOffset = self.bottomOffset()
            }
        }, completion: nil)
    }
    
    //MARK: - UITextView Delegate
    
  
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("ChatViewController did deinit")
    }
    
}
