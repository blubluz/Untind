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
        let alertController = UTAlertController(title: "Success!!", message: "Your Question was sent successfully to _username_. We will notify you when they answer you")
        self.present(alertController, animated: true, completion: nil)
        return
        
        guard answerTextField.textField.text.count > 10 else {
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
                let alertController = UIAlertController(title: "Posted!", message: "Your question has been posted. You can find it in the questions screen.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                }))
                
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
