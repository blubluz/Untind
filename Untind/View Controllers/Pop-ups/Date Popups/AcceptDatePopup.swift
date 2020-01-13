//
//  AcceptDatePopup.swift
//  Untind
//
//  Created by Honceriu Mihai on 06/01/2020.
//  Copyright © 2020 FincPicsels. All rights reserved.
//

import UIKit

class AcceptDatePopup: UIViewController {

    var didAnimate : Bool = false
    @IBOutlet weak var containerView: SwipeableCardView!
    @IBOutlet weak var illustrationImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.cardDelegate = self
        // Do any additional setup after loading the view.
    }
    
    static func instantiate() -> AcceptDatePopup {
          let vc = AcceptDatePopup(nibName: "AcceptDatePopup", bundle: nil)
          return vc
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
    }
}
