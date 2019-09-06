//
//  TabBarViewController.swift
//  Untind
//
//  Created by Honceriu Mihai on 28/07/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

protocol PresentationViewController {
    func dismissContainerViewController(animated: Bool, completion: ((Bool) -> Void)?)
}
class TabBarViewController: UIViewController, PresentationViewController {

    @IBOutlet weak var controllerContainerView: UIView!
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var circleView: TabBarCircleView!
    @IBOutlet var tabBarButtons: [UITabBarButton]!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var profileNotificationsView: UIView!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var filterButtonBackground: UIView!
    @IBOutlet weak var addQuestionIndicatorArrow: UIImageView!
    @IBOutlet weak var closeModalButton: UIButton!
    @IBOutlet weak var presentationViewContainer: UIView!
    @IBOutlet weak var presentationContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var topBarTopConstraint: NSLayoutConstraint!
    
    weak var presentedContainerViewController : UIViewController?
    weak var currentDisplayedViewController : UIViewController?
    
    private var isModalInContainer : Bool {
            return presentationContainerBottomConstraint.constant == 0 && presentationViewContainer.subviews.count != 0
    }
    
    private var selectedButton: UIButton?
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
            backgroundImage.roundCorners(cornerRadius: 35, corners: [.bottomLeft,.bottomRight])
            circleView.center = tabBarButtons.first(where: { (button : UITabBarButton) -> Bool in
                button.isSelected == true
            })?.center ?? tabBarButtons[0].center
        
        filterButtonBackground.layer.cornerRadius = filterButtonBackground.frame.size.width/2
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TEST: Add initial controller here for testing purpose
        
        let feedVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedViewController") as! FeedViewController
        currentDisplayedViewController = feedVC
        self.addChild(feedVC)
        
        if let feedVcView = feedVC.view {
            let feedVcView = feedVcView
            self.controllerContainerView.addSubview(feedVcView)
            
            feedVcView.translatesAutoresizingMaskIntoConstraints = false
            controllerContainerView.addConstraints([
                feedVcView.leadingAnchor.constraint(equalTo: controllerContainerView.leadingAnchor),
                feedVcView.topAnchor.constraint(equalTo: controllerContainerView.topAnchor),
                feedVcView.trailingAnchor.constraint(equalTo: controllerContainerView.trailingAnchor),
                feedVcView.bottomAnchor.constraint(equalTo: controllerContainerView.bottomAnchor)])
            
            for constraint in feedVcView.constraints {
                constraint.isActive = true
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(didSwitchTheme(_:)), name: .didSwitchTheme, object: nil)
        
        closeModalButton.transform = CGAffineTransform(translationX: -150, y: 0).rotated(by: 360)
        presentationContainerBottomConstraint.constant = -UIScreen.main.bounds.size.height
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarButtons[0].isSelected = true
        selectedButton = tabBarButtons[0]
        circleView.backgroundColor = UIColor.lightOrange
        circleView.layer.cornerRadius = 22
        circleView.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        
        profileNotificationsView.layer.cornerRadius = profileNotificationsView.frame.size.height/2
        profileNotificationsView.layer.shadowOpacity = 0.3
        profileNotificationsView.layer.shadowRadius = 4
        profileNotificationsView.layer.shadowOffset = CGSize(width: 0, height: 5)
        
        profileButton.setImage(UIImage(named: UTUser.loggedUser?.userProfile?.avatarType ?? "anonymous-avatar"), for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
  

    
    @objc func didSwitchTheme(_ notification: Notification) {
        if let data = notification.userInfo as? [String: ThemeMode]
        {
            if let theme = data["theme"] {
                switch theme {
                case .answer :
                    UIView.transition(with: backgroundImage,
                                      duration: 0.75,
                                      options: .transitionCrossDissolve,
                                      animations: {
                                        self.backgroundImage.image = UIImage(named: "teal-background")
                                        self.circleView.backgroundColor = UIColor.lightTeal
                                        self.tabBarButtons[0].setImage(UIImage(named: "questions-icon-teal"), for: .selected)
                                        self.tabBarButtons[1].setImage(UIImage(named: "chat-icon-teal"), for: .selected)
                                        self.tabBarButtons[2].setImage(UIImage(named: "notifications-icon-teal"), for: .selected)
                                        self.tabBarButtons[3].setImage(UIImage(named: "profile-icon-teal"), for: .selected)
                                        
                    },
                                      completion: nil)
                case .question:
                    UIView.transition(with: backgroundImage,
                                      duration: 0.75,
                                      options: .transitionCrossDissolve,
                                      animations: {
                                        self.backgroundImage.image = UIImage(named: "orange-background")
                                        self.circleView.backgroundColor = UIColor.lightOrange
                                        self.tabBarButtons[0].setImage(UIImage(named: "questions-icon-orange"), for: .selected)
                                        self.tabBarButtons[1].setImage(UIImage(named: "chat-icon-orange"), for: .selected)
                                        self.tabBarButtons[2].setImage(UIImage(named: "notifications-icon-orange"), for: .selected)
                                        self.tabBarButtons[3].setImage(UIImage(named: "profile-icon-orange"), for: .selected)
                    },
                                      completion: nil)
                }
            }
        }
    }
    
    //MARK: - Button Actions
    @IBAction func topProfileButtonTapped(_ sender: Any) {
        guard !(self.presentedContainerViewController is MyQuestionsViewController) else {
            return
        }
        
        self.present(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyQuestionsViewController"), animated: true, completion: nil, inContainer: true)
        
    }
    
    @IBAction func closeModalButtonTapped(_ sender: Any) {
       self.dismissContainerViewController(animated: true)
    }
   
    @IBAction func feedButtonTapped(_ sender: UITabBarButton) {
        moveCircle(toButton: sender)
        
        
        //Remove old
        currentDisplayedViewController?.willMove(toParent: nil)
        currentDisplayedViewController?.view.removeFromSuperview()
        self.currentDisplayedViewController?.removeFromParent()
        
        
        let profileVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedViewController") as! FeedViewController
        self.currentDisplayedViewController = profileVc
        self.addChild(profileVc)
        
        if let profileVcView = profileVc.view {
            self.controllerContainerView.addSubview(profileVcView)
            
            profileVcView.translatesAutoresizingMaskIntoConstraints = false
            controllerContainerView.addConstraints([
                profileVcView.leadingAnchor.constraint(equalTo: controllerContainerView.leadingAnchor),
                profileVcView.topAnchor.constraint(equalTo: controllerContainerView.topAnchor),
                profileVcView.trailingAnchor.constraint(equalTo: controllerContainerView.trailingAnchor),
                profileVcView.bottomAnchor.constraint(equalTo: controllerContainerView.bottomAnchor)])
            
            for constraint in profileVcView.constraints {
                constraint.isActive = true
            }
        }
    }
    @IBAction func chatButtonTapped(_ sender: UITabBarButton) {
        moveCircle(toButton: sender)
    }
    @IBAction func notificationsButtonTapped(_ sender: UITabBarButton) {
        moveCircle(toButton: sender)
    }
    @IBAction func profileButtonTapped(_ sender: UITabBarButton) {
        moveCircle(toButton: sender)
        
        //Remove old
        currentDisplayedViewController?.willMove(toParent: nil)
        currentDisplayedViewController?.view.removeFromSuperview()
        self.currentDisplayedViewController?.removeFromParent()
        
        
        let profileVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.currentDisplayedViewController = profileVc
        self.addChild(profileVc)
        
        if let profileVcView = profileVc.view {
            self.controllerContainerView.addSubview(profileVcView)
            
            profileVcView.translatesAutoresizingMaskIntoConstraints = false
            controllerContainerView.addConstraints([
                profileVcView.leadingAnchor.constraint(equalTo: controllerContainerView.leadingAnchor),
                profileVcView.topAnchor.constraint(equalTo: controllerContainerView.topAnchor),
                profileVcView.trailingAnchor.constraint(equalTo: controllerContainerView.trailingAnchor),
                profileVcView.bottomAnchor.constraint(equalTo: controllerContainerView.bottomAnchor)])
            
            for constraint in profileVcView.constraints {
                constraint.isActive = true
            }
        }
    }
    
    @IBAction func filterButtonTapped(_ sender: Any) {
        if filterButton.currentImage == UIImage(named: "add-button-icon") {
            guard !(self.presentedContainerViewController is AddQuestionController) else {
                return
            }
            
            let writeQVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddQuestionsNavigation")
            self.present(writeQVC, animated: true, inContainer: true)
            
            addQuestionIndicatorArrow.isHidden = false
            
        } else {
            
        }
    }
    
    
    //MARK: - Helper functions
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil, inContainer: Bool) {
        
        self.currentDisplayedViewController?.viewWillDisappear(flag)
        if !inContainer {
            self.present(viewControllerToPresent, animated: flag, completion: completion)
        } else {
            if isModalInContainer == true {
                self.removeContainerViewController()
            }
            
            self.presentedContainerViewController = viewControllerToPresent
            self.modalPresentationStyle = .overCurrentContext
            self.presentedContainerViewController?.modalPresentationStyle = .overCurrentContext
            
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 4, options: .curveLinear, animations: {
                self.closeModalButton.transform = CGAffineTransform.identity
                self.profileButton.transform = CGAffineTransform(translationX: self.titleLabel.center.x - self.profileButton.center.x, y: 0)
                self.titleLabel.transform = CGAffineTransform(translationX: 0, y: -200)
                self.filterButton.setImage(UIImage(named: "add-button-icon"), for: .normal)
                self.filterButtonBackground.isHidden = false
                self.profileNotificationsView.transform = CGAffineTransform(translationX: self.titleLabel.center.x - self.profileNotificationsView.center.x + 22, y: 0)
            }, completion: nil)
            
            if let feedVcView = self.presentedContainerViewController!.view {
                self.presentationViewContainer.addSubview(feedVcView)
                
                self.addChild(self.presentedContainerViewController!)
                presentedContainerViewController?.didMove(toParent: self)
                
                feedVcView.translatesAutoresizingMaskIntoConstraints = false
                presentationViewContainer.addConstraints([
                    feedVcView.leadingAnchor.constraint(equalTo: presentationViewContainer.leadingAnchor),
                    feedVcView.topAnchor.constraint(equalTo: presentationViewContainer.topAnchor),
                    feedVcView.trailingAnchor.constraint(equalTo: presentationViewContainer.trailingAnchor),
                    feedVcView.bottomAnchor.constraint(equalTo: presentationViewContainer.bottomAnchor)])
                
                for constraint in presentationViewContainer.constraints {
                    constraint.isActive = true
                }
            }
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.presentationContainerBottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            }) { (success: Bool) in
                if let completion = completion {
                    completion()
                    self.currentDisplayedViewController?.viewDidDisappear(flag)
                }
            }
        }
    }
    
    func dismissContainerViewController(animated: Bool, completion: ((Bool) -> Void)? = nil) {
        
        self.currentDisplayedViewController?.viewDidAppear(animated)
        if isModalInContainer {
            UIView.animate(withDuration: animated ? 0.4 : 0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 4, options: .curveLinear, animations: {
                self.closeModalButton.transform = CGAffineTransform(translationX: -150, y: 0).rotated(by: 360)
                self.profileButton.transform = CGAffineTransform.identity
                self.titleLabel.transform = CGAffineTransform.identity
                self.filterButton.setImage(UIImage(named: "filter-icon"), for: .normal)
                self.filterButtonBackground.isHidden = true
                self.addQuestionIndicatorArrow.layer.removeAllAnimations()
                self.profileNotificationsView.transform = CGAffineTransform.identity
                self.addQuestionIndicatorArrow.isHidden = true
            }, completion: completion)
            
            UIView.animate(withDuration: animated ? 0.3 : 0, delay: 0, options: .curveEaseOut, animations: {
                self.presentationContainerBottomConstraint.constant = -UIScreen.main.bounds.size.height
                self.view.layoutIfNeeded()
            }) { [weak self] (success: Bool) in
                self?.presentedContainerViewController?.willMove(toParent: nil)
                self?.presentedContainerViewController?.view.removeFromSuperview()
                self?.presentedContainerViewController?.removeFromParent()
            }
        }
    }
    
    func removeContainerViewController() {
        self.presentationContainerBottomConstraint.constant = -UIScreen.main.bounds.size.height
        self.view.layoutIfNeeded()
        self.presentedContainerViewController?.willMove(toParent: nil)
        self.presentedContainerViewController?.view.removeFromSuperview()
        self.presentedContainerViewController?.removeFromParent()
        self.addQuestionIndicatorArrow.isHidden = true
    }
    
    func moveCircle(toButton button: UIButton) {
        selectedButton?.isSelected = false
        selectedButton = button
        button.isSelected = true
        circleView.move(toButton: button)
    }
}
