//
//  SignInViewController.swift
//  Untind
//
//  Created by Honceriu Mihai on 30/08/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding
import SVProgressHUD
import Firebase

class SignInViewController: UIViewController {

    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var emailTextView: UTLoginTextView!
    @IBOutlet weak var passwordTextView: UTLoginTextView!
    @IBOutlet weak var emailIcon: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    var didStartAnimations = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        forgotPasswordButton.titleLabel?.numberOfLines = 2
        forgotPasswordButton.titleLabel?.textAlignment = .left
        
        KeyboardAvoiding.avoidingView = containerView
        KeyboardAvoiding.addTriggerView(emailTextView)
        KeyboardAvoiding.addTriggerView(passwordTextView)
        
        setupBackGesture(view: view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        doStartAnimations()
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        let db = Firestore.firestore()
        
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            let userData =  [
                "uuid" : uuid,
                "avatar_type" : "avatar-1",
                "username" : emailTextView.text ?? "test_user",
                "settings" : [
                    "ageRange" : [
                        "minAge" : 20,
                        "maxAge" : 30
                    ],
                    "prefferedGender" : "female",
                ]
                ] as [String : Any]
            
            
            SVProgressHUD.show()
            db.collection("users").document(uuid).setData(
                userData, completion: {
                    (error) in
                    SVProgressHUD.dismiss()
                    if error != nil {
                        print(error?.localizedDescription)
                    } else {
                        print("Succesfully created/updated user")
                        UserDefaults.standard.setValue(userData, forKey: "loggedUser")
                        
                        let tabBarController = UIStoryboard.main.instantiateViewController(withIdentifier: "TabBarViewController")
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window?.rootViewController = tabBarController
                        }
            })
        } else {
            print( "No UUID available. Simulator?")
        }
    }
    
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    private func setupBackGesture(view : UIView) {
        let swipeBackGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleBackGesture(_:)))
        swipeBackGesture.edges = .left
        view.addGestureRecognizer(swipeBackGesture)
    }
    
    @objc private func handleBackGesture(_ gesture : UIScreenEdgePanGestureRecognizer) {
        
    }
    
    private func doStartAnimations() {
        guard didStartAnimations == false else {
            return
        }
        didStartAnimations = true
        emailIcon.alpha = 0
        backButton.transform = CGAffineTransform(translationX: -(backButton.frame.origin.x+backButton.frame.size.width), y: 0)
        confirmButton.transform = CGAffineTransform(translationX: 0, y: 150)
        passwordTextView.transform = CGAffineTransform(translationX: -(passwordTextView.frame.origin.x+passwordTextView.frame.size.width), y: 0)
        emailTextView.transform = CGAffineTransform(translationX: -(emailTextView.frame.origin.x+emailTextView.frame.size.width), y: 0)
        forgotPasswordButton.transform = CGAffineTransform(translationX: -(forgotPasswordButton.frame.origin.x+forgotPasswordButton.frame.size.width), y: 0)
        
        UIView.animate(withDuration: 0.25, delay: TimeInterval(0.35), usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .curveEaseIn, animations: {
            self.emailIcon.alpha = 1
            self.backButton.transform = CGAffineTransform.identity
            self.confirmButton.transform = CGAffineTransform.identity
            self.emailTextView.transform = CGAffineTransform.identity
            self.forgotPasswordButton.transform = CGAffineTransform.identity
        }) { (finished) in
            
        }
        
        UIView.animate(withDuration: 0.25, delay: TimeInterval(0.4), usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .curveEaseIn, animations: {
            self.passwordTextView.transform = CGAffineTransform.identity
        })
        
        
    }
}

extension SignInViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let frame = self.containerView.frame
        
        switch operation {
        case .push:
            return CustomAnimator(duration: TimeInterval(0.35), isPresenting: true, originFrame: frame)
        default:
            return CustomAnimator(duration: TimeInterval(0.35), isPresenting: false, originFrame: frame)
        }
    }
}
