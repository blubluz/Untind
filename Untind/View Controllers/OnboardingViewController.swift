//
//  ViewController.swift
//  Untind
//
//  Created by Honceriu Mihai on 27/07/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

enum OnboardingMode {
    case signIn
    case signUp
    case None
}
class OnboardingViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var howItWorksButton: UIButton!
    @IBOutlet weak var onboardingView: UIView!
    @IBOutlet weak var signInSignUpView: UIView!
    @IBOutlet weak var rotateBackButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var currentMode : OnboardingMode = .None {
        didSet {
            switch currentMode {
            case .signIn:
                UIView.transition(with: backgroundImageView,
                                  duration: 0.35,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    self.backgroundImageView.image = UIImage(named: "sign-in-background") },
                                  completion: nil)
                
                rotateBackButton.tintColor = UIColor.teal
                facebookButton.setImage(UIImage(named: "login-facebook"), for: .normal)
                emailButton.setImage(UIImage(named: "login-email"), for: .normal)
                titleLabel.text = "Sign In"
                self.onboardingView.alpha = 0
                UIView.transition(with: containerView, duration: 0.35, options: [.transitionFlipFromLeft,.curveEaseInOut], animations: {
                    self.signInSignUpView.alpha = 1
                    self.view.layoutIfNeeded()
                }, completion: nil)
            case .signUp:
                UIView.transition(with: backgroundImageView,
                                  duration: 0.35,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    self.backgroundImageView.image = UIImage(named: "sign-up-background")},
                                  completion: nil)
                facebookButton.setImage(UIImage(named: "register-facebook"), for: .normal)
                emailButton.setImage(UIImage(named: "register-email"), for: .normal)
                titleLabel.text = "Sign Up"
                rotateBackButton.tintColor = UIColor.flatOrange
                self.onboardingView.alpha = 0
                UIView.transition(with: containerView, duration: 0.35, options: [.transitionFlipFromLeft,.curveEaseInOut], animations: {
                    self.signInSignUpView.alpha = 1
                    self.view.layoutIfNeeded()
                }, completion: nil)
            case .None:
                
                UIView.transition(with: backgroundImageView,
                                  duration: 0.35,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    self.backgroundImageView.image = UIImage(named: "bg") },
                                  completion: nil)
                self.signInSignUpView.alpha = 0
                UIView.transition(with: containerView, duration: 0.35, options: [.transitionFlipFromRight,.curveEaseInOut], animations: {
                    self.onboardingView.alpha = 1
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let loggedInUserDict = UserDefaults.standard.dictionary(forKey: "loggedUser") {
            let loggedUser = User(with: loggedInUserDict)
            print("We have a logged user: \(loggedUser)")
            
            
            let tabBarVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController")
            self.present(tabBarVc, animated: true, completion: nil)
            
            
        } else {
            print("We don't have a logged user.")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.signInSignUpView.alpha = 0
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureLayout()
    }
    
    func configureLayout() {
        containerView.layer.cornerRadius = 40.0
//        containerView.layer.addShadow()
        
        onboardingView.layer.cornerRadius = 40.0
//        onboardingView.layer.addShadow()
        
        signInSignUpView.layer.cornerRadius = 40.0
//        signInSignUpView.layer.addShadow()
        
        var shadowFrame: CGRect = onboardingView.layer.bounds
        shadowFrame.origin.y += 30
        let shadowPath: CGPath = UIBezierPath(rect: shadowFrame).cgPath
        
        
        onboardingView.layer.shadowPath = shadowPath
        
        //Configure "How it works" button
        howItWorksButton.layer.borderColor = UIColor.flatOrange.cgColor
        howItWorksButton.layer.borderWidth = 2
        howItWorksButton.layer.cornerRadius = 20.0
    }
    
    //MARK: - Button Actions
    @IBAction func facebookTapped(_ sender: Any) {
        if currentMode == .signIn {
            
        } else if currentMode == .signUp {
            
        }
    }
    @IBAction func emailTapped(_ sender: Any) {
        if currentMode == .signIn {
            navigationController?.pushViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInViewController"), animated: false)
            
            
        } else if currentMode == .signUp {
            
            navigationController?.pushViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpViewController"), animated: false)
        }
    }
    
    @IBAction func rotateBackTapped(_ sender: Any) {
            currentMode = .None
    }
    
    @IBAction func howItWorksTapped(_ sender: Any) {
        
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        currentMode = .signUp
        
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        currentMode = .signIn
    }
    
}

