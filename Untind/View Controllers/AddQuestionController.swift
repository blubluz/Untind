//
//  AddQuestionController.swift
//  Untind
//
//  Created by Honceriu Mihai on 23/08/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit
import FirebaseFirestore
import SVProgressHUD

class AddQuestionController: UIViewController {

    @IBOutlet weak var answerSheetView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var answerTextField: UTAnswerTextField!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var postButton: UIButton!
    
    var profile : Profile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //If we are posting publicly do proper setup
        if profile == nil {
            titleLabel.text = "Create post"
            postButton.setTitle("Post", for: .normal)
        } else {
            titleLabel.text = "Ask a question"
            postButton.setTitle("Send", for: .normal)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        answerSheetView.roundCorners(cornerRadius: 30, corners: [.topLeft,.topRight])
    }
    
    @IBAction func postQuestionsTapped(_ sender: Any) {
        guard answerTextField.textField.text.count > 0 else {
            present(UIAlertController.errorAlert(text: "Please write a longer question"), animated: true, completion: nil)
            return
        }
        
        let question = Question(author: UTUser.loggedUser!.userProfile!, postDate: Date(), questionText: answerTextField.textField.text!)
        
        SVProgressHUD.show()
        
        question.post(toProfile: self.profile) { (error) in
            SVProgressHUD.dismiss()
            if error != nil {
                self.present(UIAlertController.errorAlert(text: "There was an error \(error!.localizedDescription)"), animated: true, completion: nil)
            } else {
                var alertMessage : NSAttributedString = NSAttributedString(string: "Your post is now in the public cards stack. You can find it in the profile section")
                if self.profile != nil {
                    alertMessage =  NSAttributedString(string: "Your question has been sent to \(self.profile!.username). You can find it in the profile section").boldAppearenceOf(string: self.profile!.username, withBoldFont: UIFont.helveticaNeue(weight: .bold, size: UTAlertController.messageFontSize))
                }
                let alertController = UTAlertController(title: "Success!", message:alertMessage)
                let action = UTAlertAction(title: "Dismiss", {
                    self.dismiss(animated: true, completion: nil)
                })
                alertController.addNewAction(action: action)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Keyboard Handling
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
               let keyboardRectangle = keyboardFrame.cgRectValue
               let keyboardHeight = keyboardRectangle.height
               bottomView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
           }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        bottomView.transform = CGAffineTransform.identity
    }
}
