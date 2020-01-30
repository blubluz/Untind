//
//  ViewController.swift
//  Untind
//
//  Created by Honceriu Mihai on 27/07/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import SVProgressHUD
import FirebaseAuth

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
    
    var customInteractor : CustomInteractor?
    
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
    
    
    //MARK: - View Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UTUser.loggedUser != nil {
            if UTUser.loggedUser?.userProfile != nil {
                UTUser.loggedUser?.getUserProfile()
                //Go to tab bar controller
                let tabBarController = UIStoryboard.main.instantiateViewController(withIdentifier: "TabBarNavigationController") as! UINavigationController
                Globals.mainNavigationController = tabBarController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = tabBarController
            } else {
                SVProgressHUD.show()
                UTUser.loggedUser?.getUserProfile(completion: { (success, error) in 
                    SVProgressHUD.dismiss()
                    if error == GetUserProfileError.userProfileNotFound { self.navigationController?.pushViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateProfileViewController"), animated: true)
                    } else {
                        if success == true {
                            //Go to tab bar controller
                            let tabBarController = UIStoryboard.main.instantiateViewController(withIdentifier: "TabBarNavigationController") as! UINavigationController
                            Globals.mainNavigationController = tabBarController
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.window?.rootViewController = tabBarController
                        } else {
                            self.present(UIAlertController.errorAlert(text: error?.localizedDescription ?? "Error fetching user profile"), animated: true, completion: nil)
                        }
                    }
                })
            }
        
            
        } else {
            //Do nothing
        }
        
        self.signInSignUpView.alpha = 0
        self.navigationController?.delegate = self
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
        let login = LoginManager()
        login.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
            if error != nil {
                print("\(error!.localizedDescription)")
            } else if result!.isCancelled {
                print("Cancelled")
            } else {
                SVProgressHUD.show()
                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                FirebaseAuthManager.login(credential: credential, completionBlock: { (error) in
                    if error == nil {
                        print("Succesfuly logged in on facebook & Firebase")
                        UTUser.loggedUser?.getUserProfile(completion: { (success, error) in
                            SVProgressHUD.dismiss()
                            if success == true {
                                UTUser.loggedUser?.saveUserProfile(locally: true)
                                
                                
                                print("Go to feed")
                                
                                //Go to tab bar controller
                                let tabBarController = UIStoryboard.main.instantiateViewController(withIdentifier: "TabBarNavigationController") as! UINavigationController
                                Globals.mainNavigationController = tabBarController
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.window?.rootViewController = tabBarController
                                
                            } else {
                                if error == GetUserProfileError.userProfileNotFound{
                                    self.navigationController?.pushViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateProfileViewController"), animated: true)
                                }
                            }
                        })
                    } else {
                        SVProgressHUD.dismiss()
                        self.present(UIAlertController.errorAlert(text: error?.localizedDescription ?? "Something went wrong"), animated: true, completion: nil)
                        print("Failed login with Facebook on Firebase")
                    }
                })
            }
        }
    }
    
    @IBAction func emailTapped(_ sender: Any) {
        if currentMode == .signIn {
            navigationController?.pushViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInViewController"), animated: true)
            
            
        } else if currentMode == .signUp {
            
            navigationController?.pushViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpViewController"), animated: true)
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

extension OnboardingViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let frame = self.containerView.frame
        
        switch operation {
        case .push:
            self.customInteractor = CustomInteractor(attachTo: toVC)
            return CustomAnimator(duration: TimeInterval(0.35), isPresenting: true, originFrame: frame)
        default:
            return CustomAnimator(duration: TimeInterval(0.35), isPresenting: false, originFrame: frame)
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let ci = customInteractor else { return nil }
        return ci.transitionInProgress ? customInteractor : nil
    }
}
