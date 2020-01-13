//
//  AcceptDatePopup.swift
//  Untind
//
//  Created by Honceriu Mihai on 06/01/2020.
//  Copyright © 2020 FincPicsels. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding

class AcceptDatePopup: UIViewController {

    var didAnimate : Bool = false
    @IBOutlet weak var containerView: SwipeableCardView!
    @IBOutlet weak var illustrationImageView: UIImageView!
    @IBOutlet weak var rescheduleButton: UIButton!
    @IBOutlet weak var orangeBackground: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.cardDelegate = self
        
        rescheduleButton.layer.shadowRadius = 12
        rescheduleButton.layer.shadowOffset = CGSize(width: 3.0, height: 6.0)
        rescheduleButton.layer.shadowOpacity = 0.4
        
    }
    
    static func instantiate() -> AcceptDatePopup {
          let vc = AcceptDatePopup(nibName: "AcceptDatePopup", bundle: nil)
          return vc
    }
    
    @objc func dismissKeyboard() {
           //Causes the view (or one of its embedded text fields) to resign the first responder status.
           view.endEditing(true)
       }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !didAnimate {
            didAnimate = true
            containerView.transform  = CGAffineTransform(translationX: 0, y: 800)
            illustrationImageView.transform  = CGAffineTransform(translationX: 0, y: 800)
            
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.containerView.transform = CGAffineTransform.identity
                self.illustrationImageView.transform = CGAffineTransform.identity
            }, completion: nil)
            
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
            }, completion: nil)
        } else {
            orangeBackground.alpha = 0
            self.containerView.transform = CGAffineTransform.identity
            self.view.backgroundColor = UIColor(red: 33, green: 208, blue: 185, alpha: 0.89)
        }
    }
    
    // MARK: - Button actions
    @IBAction func closeButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.containerView.transform  = CGAffineTransform(translationX: 0, y: 800)
            self.illustrationImageView.transform  = CGAffineTransform(translationX: 0, y: 800)
            self.view.alpha = 0
        }) { (finished) in
            self.dismiss(animated: false, completion: nil)
            
        }
    }
}

extension AcceptDatePopup : SwipeableViewDelegate {
    func didTap(view: SwipeableView) {
        
    }
    
    func didBeginSwipe(onView view: SwipeableView) {
        
    }
    
    func didEndSwipe(onView view: SwipeableView) {
        
    }
    
    func didSwipe(onView view: SwipeableView, percent: CGFloat) {
        
    }
    
    func didSwipeAway(onView view: SwipeableView) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.view.alpha = 0
        }) { (finished) in
            self.dismiss(animated: false, completion: nil)
            
        }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func rescheduleButtonTapped(_ sender: Any) {
        
        let vc = RescheduleDatePopup.instantiate()
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.view.backgroundColor = UIColor.clear
            self.orangeBackground.alpha = 0.89
            self.containerView.transform = CGAffineTransform(translationX: -450, y: -100).rotated(by: -CGFloat.pi/5)
        }) { (completed) in self.navigationController?.pushViewController(vc, animated: false)
        }
        
    }
}
