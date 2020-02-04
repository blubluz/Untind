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
    @IBOutlet weak var dateTimerLabel: UILabel!
    @IBOutlet weak var emptyChatBackgroundImage: UIImageView!
    @IBOutlet weak var emptyChatLabel: UILabel!
    @IBOutlet weak var chatPartnerNameLabel: UILabel!
    @IBOutlet weak var chatPartnerSexAgeLabel: UILabel!
    @IBOutlet weak var chatPartnerAvatarImageView: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var dateTimerView: UIStackView!
    @IBOutlet weak var bottomTimerView: UIView!
    var date : UTDate?
    var timer = Timer()
    var isTimerRunning = false
    var timerSecondsLeft : TimeInterval = 0
    
    
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
        
        
        messagesCollectionView.register(MessageCell.self)
        messagesCollectionView.register(WarningCell.self)
        messagesCollectionView.keyboardDismissMode = .interactive
        messagesCollectionView.contentInset = UIEdgeInsets(top: scrollviewContentInset, left: 0, bottom: scrollviewContentInset, right: 0)
        
        topView.roundCorners(cornerRadius: 20, corners: [.bottomLeft,.bottomRight])

        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        messagesCollectionView.addGestureRecognizer(tap)
        configureController()
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
    
    //MARK: - Configuration
    func configureController() {
        if let date = self.date {
            if let partner = self.date?.invited?.uid.isMyId ?? true ? self.date?.invitee : self.date?.invited {
                chatPartnerNameLabel.text = partner.username
                chatPartnerAvatarImageView.image = UIImage(named: partner.avatarType)
                chatPartnerSexAgeLabel.text = "\(partner.gender.shortGender), \(partner.age)"
            }
            
            if date.myRelationshipStatus == .chatStarted || date.myRelationshipStatus == .dateStarted {
                self.startChat(animated: false)
            } else if date.myRelationshipStatus == .dateScheduled {
                self.emptyChatBackgroundImage.isHidden = false
                self.emptyChatLabel.isHidden = false
                self.bottomTimerView.isHidden = false
                self.timerLabel.isHidden = false
                self.dateTimerView.isHidden = true
                self.inputAccessoryView?.isHidden = true
                self.chatBackgroundImage.isHidden = true
                if isTimerRunning == false {
                    isTimerRunning = true
                    self.timerSecondsLeft = date.dateTime?.timeIntervalSinceNow ?? 0
                    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
                    timer.fire()
                }
                
            } else if date.myRelationshipStatus == .waitingDateResult || date.myRelationshipStatus == .shouldGiveDateResult {
                self.dateTimerView.isHidden = true
                self.emptyChatBackgroundImage.isHidden = false
                self.emptyChatLabel.isHidden = false
                self.bottomTimerView.isHidden = false
                self.timerLabel.isHidden = false
                self.inputAccessoryView?.isHidden = true
                self.chatBackgroundImage.isHidden = true
                if date.myRelationshipStatus == .waitingDateResult {
                    self.timerLabel.text = "Waiting for your partners response."
                } else {
                    self.timerLabel.text = "Waiting for your response."
                    let partner = self.date?.invited?.uid.isMyId ?? true ? self.date?.invitee?.username : self.date?.invited?.username
                    
                    let alert = UTAlertController(title: "So, did you two click?", message: NSAttributedString(string: "Your 10 minutes has expired and the date has ended. But no worries, if you felt like you had a connection and you would like to continue to talk to \(partner ?? "") in the future, tap yes below.").boldAppearenceOf(string: partner, withBoldFont: UIFont.helveticaNeue(weight: .bold, size: UTAlertController.messageFont.pointSize), color: UIColor.darkBlue).withLineSpacing(5), backgroundColor: UIColor(red: 126, green: 211, blue: 33, alpha: 0.73))
                    let yesAction = UTAlertAction(title: "YES", {
                        SVProgressHUD.show()
                        self.date?.giveResult(.accepted, completion: { (error, date) in
                            SVProgressHUD.dismiss()
                            if error == nil {
                                if self.date?.myRelationshipStatus == .some(.chatStarted) {
                                    self.startChat(animated: true)
                                       self.present(UTAlertController(title: "Congratulations!", message: "Your partner also enjoyed the date! You can now chat forever & always :)"), animated: true, completion: nil)
                                } else {
                                    self.configureController()
                                    self.present(UTAlertController(title: "Thank you", message: "Your partner did not respond yet. Please wait for his/her response"), animated: true, completion: nil)

                                }
                            } else {                                self.present(UTAlertController(title: "Oops", message: "\(error?.localizedDescription ?? "There was an error")"), animated: true, completion: nil)
                            }
                        })
                    }, color: UIColor(red: 126, green: 211, blue: 33, alpha: 1))
                    yesAction.hasUnderbar = true
                    yesAction.buttonFont = UIFont.helveticaNeue(weight: .bold, size: 20)
                    
                    let noAction = UTAlertAction(title: "NO", {
                        SVProgressHUD.show()
                        self.date?.giveResult(.rejected, completion: { (error, date) in
                            SVProgressHUD.dismiss()
                            if error == nil {
                                let alert = UTAlertController(title: "Thank you", message: "We're sorry you didn't enjoy your date. We hope you'll like the next one better.")
                                let action = UTAlertAction(title: "Leave", {
                                    self.navigationController?.popViewController(animated: true)
                                }, color: UIColor.darkBlue)
                                alert.addNewAction(action: action)
                                self.present(alert, animated: true, completion: nil)
                            } else {
                                self.present(UTAlertController(title: "Oops", message: "\(error?.localizedDescription ?? "There was an error")"), animated: true, completion: nil)
                            }
                        })
                    }, color: UIColor.darkBlue)
                    noAction.buttonFont = UIFont.helveticaNeue(weight: .regular, size: 20)
                    
                    alert.addNewAction(action: yesAction)
                    alert.addNewAction(action: noAction)
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } else {
            self.navigationController?.popViewController(animated: true)
            return
        }
    }
    
    @objc func updateTimer() {
        if timerSecondsLeft <= 0 {
            self.timer.invalidate()
            self.isTimerRunning = false
            if self.date?.myRelationshipStatus == .some(.dateStarted) {
                self.startChat(animated: true)
            } else {
                self.configureController()
            }
        } else {
            timerSecondsLeft -= 1
            if self.date?.myRelationshipStatus == .some(.dateStarted) {
                let minutes = Int(timerSecondsLeft) / 60 % 60
                let seconds = Int(timerSecondsLeft) % 60
                dateTimerLabel.text = String(format:"%02i:%02i", minutes, seconds)
            } else {
                let hours = Int(timerSecondsLeft) / 3600
                let minutes = Int(timerSecondsLeft) / 60 % 60
                let seconds = Int(timerSecondsLeft) % 60
                if hours > 0 {
                    timerLabel.attributedText = NSAttributedString(string: "Date starting in \(hours) hours and \(minutes) minutes").boldAppearenceOf(string: "\(hours) hours", withBoldFont: UIFont.helveticaNeue(weight: .bold, size: timerLabel.font.pointSize), color: UIColor.darkBlue).boldAppearenceOf(string: "\(minutes) minutes", withBoldFont: UIFont.helveticaNeue(weight: .bold, size: timerLabel.font.pointSize), color: UIColor.darkBlue)
                } else {
                    timerLabel.attributedText = NSAttributedString(string: "Date starting in \(String(format:"%02i:%02i", minutes, seconds))").boldAppearenceOf(string: "\(minutes):\(seconds)", withBoldFont: UIFont.helveticaNeue(weight: .bold, size: timerLabel.font.pointSize), color: UIColor.darkBlue)
                }
            }
        }
        
    }
    
    func startChat(animated: Bool) {
        if let date = date {
            if date.myRelationshipStatus == .dateStarted {
                self.dateTimerView.isHidden = false
                if isTimerRunning == false {
                    self.dateTimerView.isHidden = false
                    isTimerRunning = true
                    self.timerSecondsLeft = date.dateTime!.timeIntervalSinceNow + 900
                    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
                    timer.fire()
                    
                }
            } else {
                self.dateTimerView.isHidden = true
            }
            
            if animated == true {

                self.chatBackgroundImage.alpha = 0
                self.chatBackgroundImage.isHidden = false
                self.inputAccessoryView?.transform = CGAffineTransform(translationX: 0, y: 80)
                
                self.inputAccessoryView?.isHidden = false
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                    self.emptyChatBackgroundImage.transform = CGAffineTransform(translationX: -600, y: 0)
                    self.emptyChatLabel.transform = CGAffineTransform(translationX: 600, y: 0)
                    self.bottomTimerView.transform = CGAffineTransform(translationX: 0, y: 130)
                     self.inputAccessoryView?.transform = CGAffineTransform.identity
                    self.chatBackgroundImage.alpha = 1
                    
                }) { (finished) in
                    self.emptyChatBackgroundImage.isHidden = true
                    self.emptyChatLabel.isHidden = true
                    self.bottomTimerView.isHidden = true
                    self.emptyChatBackgroundImage.transform = CGAffineTransform.identity
                    self.emptyChatLabel.transform = CGAffineTransform.identity
                }
            } else {
                self.emptyChatBackgroundImage.isHidden = true
                self.emptyChatLabel.isHidden = true
                self.bottomTimerView.isHidden = true
                self.chatBackgroundImage.isHidden = false
                self.inputAccessoryView?.isHidden = false
            }
            
            date.fetchChatRoom(force: false) { (error, chatRoom) in
                guard let lChatRoom = chatRoom else {
                    self.navigationController?.popViewController(animated: true)
                    return
                }
                
                lChatRoom.startLoadingMessages(numberOfMessages: 20, delegate: self, completion: { (error, success) in
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
        self.date?.chatRoom?.addMessage(message, completion: { (error, success) in
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
    
    @IBAction func moreOptionsTapped(_ sender: Any) {
        let warningMessage = UTMessage(message: "Your 10 min starts now! Good luck!", authorUid: "", postDate: Date())
        warningMessage.isWarningMessage = true
        self.date?.chatRoom?.messages.append(warningMessage)
        
        self.messagesCollectionView.insertItems(at: [IndexPath(item: self.date!.chatRoom!.messages.count-1, section: 0)])
        self.messagesCollectionView.scrollToItem(at: IndexPath(item: self.date!.chatRoom!.messages.count-1, section: 0), at: .top, animated: true)
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
        
        
        let messageText = self.date!.chatRoom!.messages[indexPath.row].messageText
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.helveticaNeue(weight: .regular, size: 16), NSAttributedString.Key.paragraphStyle : NSAttributedString.lineSpacingParagraphStyle(spacing: 5)], context: nil)
        
        return CGSize(width: view.frame.width, height: estimatedFrame.height + 28)
    }
    
       func numberOfSections(in collectionView: UICollectionView) -> Int {
           return 1
       }
       
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let chatRoom = self.date!.chatRoom else {
               return 0
           }
           
           return chatRoom.messages.count
       }
       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let message = self.date!.chatRoom!.messages[indexPath.row]
        if message.isWarningMessage {
            let cell = collectionView.dequeue(WarningCell.self, for: indexPath)
            cell.configureWithMessage(message: NSAttributedString(string: message.messageText), hasWarningIcon: true)
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCell", for: indexPath) as! MessageCell
        let avatar = self.date!.chatRoom!.participants.first {
            $0.uid == message.authorUid
            }?.avatarType
        
        cell.configureWithMessage(message: message, avatar: avatar ?? "empty", chatViewWidth: messagesCollectionView.frame.size.width)
        
        return cell
    }
}

extension ChatViewController : ChatRoomDelegate {
    func utChatRoom(room: UTChatRoom, newMessageArrived: UTMessage) {
        self.messagesCollectionView.insertItems(at: [IndexPath(item: self.date!.chatRoom!.messages.count-1, section: 0)])
        self.messagesCollectionView.scrollToItem(at: IndexPath(item: self.date!.chatRoom!.messages.count-1, section: 0), at: .top, animated: true)
    }
}
