//
//  SignInViewController.swift
//  Untind
//
//  Created by Honceriu Mihai on 30/08/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding

class SignInViewController: UIViewController {

    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var emailTextView: UTLoginTextView!
    @IBOutlet weak var passwordTextView: UTLoginTextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        forgotPasswordButton.titleLabel?.numberOfLines = 2
        forgotPasswordButton.titleLabel?.textAlignment = .left
        
        KeyboardAvoiding.avoidingView = containerView
        KeyboardAvoiding.addTriggerView(emailTextView)
        KeyboardAvoiding.addTriggerView(passwordTextView)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
    
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}
