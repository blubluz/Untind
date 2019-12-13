//
//  UTAlertController.swift
//  Untind
//
//  Created by Mihai Honceriu on 12/12/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

class UTAlertController: UIViewController {

    private var actions : [UTAlertAction] = []
    var backgroundColor : UIColor = UIColor.flatOrange
    var isDismissable : Bool = true
    var isLoading : Bool = false
    
    lazy private(set) var backgroundTransparentView : UIView = {
        let v = UIView()
        v.tag = UIViewTags.alertBackground.rawValue
        self.view.addSubview(v)
        self.view.edgeConstrain(subView: v)
        v.backgroundColor = UIColor(white: 0, alpha: 0.17)
        
        return v
    }()
    
    lazy private(set) var alertView : UIView = {
        let v = UIView()
        self.view.addSubview(v)
        v.tag = UIViewTags.alertView.rawValue
        v.backgroundColor = UIColor.white
        v.activateConstraints([
            v.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0),
            v.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            v.widthAnchor.constraint(equalToConstant: 260)])
        v.layer.cornerRadius = 20
        return v
    }()
    
    lazy private(set) var titleLabel : UILabel = {
       let l = UILabel()
        alertView.addSubview(l)
        l.activateConstraints([
            l.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 30),
            l.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 15),
            l.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -15)])
        l.numberOfLines = 2
        l.font = UIFont.helveticaNeue(weight: .bold, size: 20)
        l.textAlignment = .center
        l.textColor = UIColor.darkBlue
        return l
    }()
    
    lazy private(set) var messageLabel : UILabel = {
        let l = UILabel()
        alertView.addSubview(l)
        l.activateConstraints([
            l.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            l.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 17),
            l.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -17)])
        
        l.numberOfLines = 9
        l.font = UIFont.helveticaNeue(weight: .normal, size: 14)
        l.textColor = UIColor.gray(value: 151)
        l.textAlignment = .center
        return l
    }()
    
    lazy private var actionsStackView : UIStackView = {
       let sv = UIStackView()
        alertView.addSubview(sv)
        
        sv.activateConstraints([
            sv.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 0),
            sv.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 0),
            sv.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: 0),
            sv.bottomAnchor.constraint(equalTo: alertView.bottomAnchor),
            sv.heightAnchor.constraint(equalToConstant: 65)])
        
        return sv
    }()
    
    func commonInit(title: String, message: Any, actions: [UTAlertAction] = []) {
        self.transitioningDelegate = self
        self.modalPresentationStyle = .custom
        view.backgroundColor = UIColor.clear
        self.actions = actions
        _ = backgroundTransparentView
        _ = actionsStackView
        self.titleLabel.text = title
        if let message = message as? String {
            self.messageLabel.text = message
            self.messageLabel.attributedText = NSAttributedString(string: message).withLineSpacing(5.5, andAlignment: .center)
        } else if let message = message as? NSAttributedString {
            self.messageLabel.attributedText = message.withLineSpacing(5.5, andAlignment: .center)
        } else {
            self.messageLabel.text = ""
        }
        
        reloadActions()
    }
    
    init(title: String, message: String, actions: [UTAlertAction] = []) {
        super.init(nibName: nil, bundle: nil)
        commonInit(title: title, message: message, actions: actions)
    }
    
    init(title: String, message: NSAttributedString, actions: [UTAlertAction] = []) {
        super.init(nibName: nil, bundle: nil)
       commonInit(title: title, message: message, actions: actions)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addNewAction(action: UTAlertAction) {
        actions.append(action)
        addActionButton(withAction: action)
    }
    
    
    private func addActionButton(withAction action: UTAlertAction) {
        if action.handler == nil {
            action.handler = {
                Async.main {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
        let actionButton = UTAlertButton(action: action)
        actionsStackView.addArrangedSubview(actionButton)
    }
    
    private func reloadActions() {
        for view in actionsStackView.subviews {
            actionsStackView.removeArrangedSubview(view)
        }
        
        guard actions.count > 0 else {
            if isDismissable == true {
                addActionButton(withAction: UTAlertAction(title: "Dismiss"))
            } else if isLoading == true {
                //Add progress view
            }
            return
        }
        
        for action in actions {
            addActionButton(withAction: action)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension UTAlertController : UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return UTAlertControllerAnimator(duration: 0.8, isPresenting: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return UTAlertControllerAnimator(duration: 0.8, isPresenting: false)
    }
}

class UTAlertControllerAnimator :NSObject, UIViewControllerAnimatedTransitioning {
    
    var duration : TimeInterval
    var isPresenting : Bool
    
    init(duration : TimeInterval, isPresenting : Bool) {
           self.duration = duration
           self.isPresenting = isPresenting
       }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView
        guard let toView = transitionContext.view(forKey: .to) else {
            return
        }
        container.addSubview(toView)
        
        let background = toView.viewWithTag(UIViewTags.alertBackground.rawValue)
        let alert = toView.viewWithTag(UIViewTags.alertView.rawValue)
        background?.alpha = 0
        
        alert?.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        UIView.animate(withDuration: duration) {
            background?.alpha = 1
        }
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: .curveLinear, animations: {
            alert?.transform = CGAffineTransform.identity
            }) { (finished) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                
        }
    }
    
}
