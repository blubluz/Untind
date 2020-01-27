//
//  ChatViewController.swift
//  Untind
//
//  Created by Honceriu Mihai on 13/11/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ChatViewController: UIViewController, ChatInputAccesoryDelegate {
    
    @IBOutlet weak var messagesCollectionView: UICollectionView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var chatBackgroundImage: UIImageView!
    @IBOutlet weak var emptyChatBackgroundImage: UIImageView!
    @IBOutlet weak var emptyChatLabel: UILabel!
    @IBOutlet weak var chatPartnerNameLabel: UILabel!
    @IBOutlet weak var chatPartnerSexAgeLabel: UILabel!
    @IBOutlet weak var chatPartnerAvatarImageView: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var bottomTimerView: UIView!
    var date : UTDate?
    
    private lazy var chatInputAccesory : ChatInputAccesoryView = {
        let cv = ChatInputAccesoryView()
        cv.chatDelegate = self
        return cv
    }()
    
    var shouldScrollToBottom = true
    let scrollviewContentInset : CGFloat = 20
    
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
    
    //MARK: - View Controller Lifecycle
    static func instantiate() -> ChatViewController {
        let vc = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        messagesCollectionView.register(MessageCell.self, forCellWithReuseIdentifier: "MessageCell")
       
        messagesCollectionView.keyboardDismissMode = .interactive
        messagesCollectionView.contentInset = UIEdgeInsets(top: scrollviewContentInset, left: 0, bottom: scrollviewContentInset, right: 0)
        
        topView.roundCorners(cornerRadius: 20, corners: [.bottomLeft,.bottomRight])

        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        messagesCollectionView.addGestureRecognizer(tap)
//        loadData()
        
        if let date = self.date {
            //logic
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        messagesCollectionView.delegate = self
        messagesCollectionView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if shouldScrollToBottom {
            shouldScrollToBottom = false
                   NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
                   NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
                   scrollToBottom(animated: false)
               }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("ChatViewController did deinit")
    }
    
    //MARK: - Data handling
    func loadData() {
          if let profile = self.chatPartnerProfile {
              let db = Firestore.firestore()
              let chatDocument = db.collection("chats").document(profile.uid.combineUniquelyWith(string: UTUser.loggedUser!.userProfile!.uid))
           
            
              self.chatInputAccesory.isUserInteractionEnabled = false
              SVProgressHUD.show()
              chatDocument.getDocument { (snapshot, error) in
                  if error != nil {
                    SVProgressHUD.dismiss()
                    //error loading chat room
                  } else {
                    if let snapshot = snapshot, snapshot.data() != nil {
                        let room = UTChatRoom(with: snapshot)
                        if room.participants.first?.uid.isMyId == true {
                            self.chatPartnerNameLabel.text = room.participants.last?.username
                        } else {
                            self.chatPartnerNameLabel.text = room.participants.first?.username
                        }
                        
                        self.chatRoom = room
                        self.chatRoom?.startLoadingMessages(numberOfMessages: 20, delegate: self, completion: { (error, success) in
                            SVProgressHUD.dismiss()
                            self.chatInputAccesory.isUserInteractionEnabled = true
                            if error != nil {
                                self.present(UTAlertController(title: "Oops", message: error?.localizedDescription ?? "There was an error"), animated: true, completion: nil)
                            } else {
                                if success == true {
                                    self.messagesCollectionView.reloadData()
                                }
                            }
                        })
                    } else {
                        let newRoom = UTChatRoom()
                        newRoom.participants.append(profile)
                        newRoom.participants.append(UTUser.loggedUser!.userProfile!)
                        newRoom.isOpen = true
                        newRoom.id = profile.uid.combineUniquelyWith(string: UTUser.loggedUser!.userProfile!.uid)
                        
                        chatDocument.setData(newRoom.jsonValue()) {
                            (error) in
                            SVProgressHUD.dismiss()
                            if error != nil {
                                
                            } else {
                                //We have created the chat room
                                self.chatRoom = newRoom
                                self.chatRoom?.startLoadingMessages(numberOfMessages: 20, delegate: self, completion: { (error, success) in
                                    if error != nil {
                                        self.present(UTAlertController(title: "Oops", message: error?.localizedDescription ?? "There was an error"), animated: true, completion: nil)
                                    } else {
                                        if success == true {
                                            
                                        }
                                    }
                                })
                                self.chatInputAccesory.isUserInteractionEnabled = true
                            }
                        }
                    }
                }
            }
          }
    }
    
    
    //MARK: - Helper functions
    func scrollToBottom(animated: Bool) {
        view.layoutIfNeeded()
        messagesCollectionView.setContentOffset(bottomOffset(), animated: animated)
    }
    
    func bottomOffset() -> CGPoint {
        return CGPoint(x: 0, y: max(-messagesCollectionView.contentInset.top, messagesCollectionView.contentSize.height - (messagesCollectionView.bounds.size.height - messagesCollectionView.contentInset.bottom)))
    }
 
    func didTapSend() {
        if self.chatInputAccesory.text == "" {
            return
        }
        
        //Create new message
        let message = UTMessage(message: self.chatInputAccesory.text, authorUid: UTUser.loggedUser!.userProfile!.uid, postDate: Date())
        self.chatRoom?.addMessage(message, completion: { (error, success) in
            if success == true {
                //do nothing
            } else {
                //show that message failed to send
            }
        })
        
        self.chatInputAccesory.text = ""
        self.chatInputAccesory.resetMessageTextView()
    }
    
    //MARK: - Button actions
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
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
}


//MARK: - UITextView Delegate

extension ChatViewController : UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
           return true
       }
}

// MARK: - UIScrollViewDelegate

extension ChatViewController : UIScrollViewDelegate {
    
}

// MARK: - CollectionViewDelegate

extension ChatViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           
           
           let messageText = self.chatRoom!.messages[indexPath.row].messageText
           let size = CGSize(width: 250, height: 1000)
           let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
           let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.helveticaNeue(weight: .regular, size: 16), NSAttributedString.Key.paragraphStyle : NSAttributedString.lineSpacingParagraphStyle(spacing: 5)], context: nil)

           return CGSize(width: view.frame.width, height: estimatedFrame.height + 28)
       }
       
       func numberOfSections(in collectionView: UICollectionView) -> Int {
           return 1
       }
       
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           guard let chatRoom = self.chatRoom else {
               return 0
           }
           
           return chatRoom.messages.count
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCell", for: indexPath) as! MessageCell
           let message = self.chatRoom!.messages[indexPath.row]
           let avatar = self.chatRoom!.participants.first {
               $0.uid == message.authorUid
           }?.avatarType
           
           cell.configureWithMessage(message: message, avatar: avatar ?? "empty", chatViewWidth: messagesCollectionView.frame.size.width)
           
           return cell
       }
}

extension ChatViewController : ChatRoomDelegate {
    func utChatRoom(room: UTChatRoom, newMessageArrived: UTMessage) {
        self.messagesCollectionView.insertItems(at: [IndexPath(item: self.chatRoom!.messages.count-1, section: 0)])
        self.messagesCollectionView.scrollToItem(at: IndexPath(item: self.chatRoom!.messages.count-1, section: 0), at: .top, animated: true)
    }
}
