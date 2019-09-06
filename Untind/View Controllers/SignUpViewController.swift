//
//  SignUpViewController.swift
//  Untind
//
//  Created by Honceriu Mihai on 30/08/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextView: UTLoginTextView!
    @IBOutlet weak var passwordTextView: UTLoginTextView!
    @IBOutlet weak var confirmPasswordTextView: UTLoginTextView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var emailIcon: UIImageView!
    
    var didStartAnimations = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        doStartAnimations()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
 
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        navigationController?.pushViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateProfileViewController"), animated: true)
    }
    
    private func doStartAnimations() {
        guard didStartAnimations == false else {
            return
        }
        didStartAnimations = true
        emailIcon.alpha = 0
        backButton.transform = CGAffineTransform(translationX: -(backButton.frame.origin.x+backButton.frame.size.width), y: 0)
        confirmButton.transform = CGAffineTransform(translationX: 0, y: 150)
        confirmPasswordTextView.transform = CGAffineTransform(translationX: -(confirmPasswordTextView.frame.origin.x+confirmPasswordTextView.frame.size.width), y: 0)
        passwordTextView.transform = CGAffineTransform(translationX: -(passwordTextView.frame.origin.x+passwordTextView.frame.size.width), y: 0)
        emailTextView.transform = CGAffineTransform(translationX: -(emailTextView.frame.origin.x+emailTextView.frame.size.width), y: 0)
        
        UIView.animate(withDuration: 0.25, delay: TimeInterval(0.35), usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .curveEaseIn, animations: {
            self.emailIcon.alpha = 1
            self.backButton.transform = CGAffineTransform.identity
            self.confirmButton.transform = CGAffineTransform.identity
            self.emailTextView.transform = CGAffineTransform.identity
        }) { (finished) in
            
        }
        
        UIView.animate(withDuration: 0.25, delay: TimeInterval(0.45), usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .curveEaseIn, animations: {
            self.passwordTextView.transform = CGAffineTransform.identity
        })
        
        UIView.animate(withDuration: 0.25, delay: TimeInterval(0.40), usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .curveEaseIn, animations: {
            self.confirmPasswordTextView.transform = CGAffineTransform.identity
        })

    }
}

extension SignUpViewController: UINavigationControllerDelegate {
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
