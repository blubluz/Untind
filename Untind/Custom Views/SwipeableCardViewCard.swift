//
//  SwipeableCardViewCard.swift
//  Untind
//
//  Created by Honceriu Mihai on 29/07/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

class SwipeableCardViewCard: SwipeableCardView {

   
    /// Outlets
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topViewBar: UIView!
    @IBOutlet weak var topViewOptions: UIView!
    @IBOutlet weak var topViewQuestions: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewBar: UIView!
    
    @IBOutlet weak var bottomViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewTrailingConstraint: NSLayoutConstraint!
    /// Inner Margin
    private static let kInnerMargin: CGFloat = 20.0
    
    /// Shadow View
    private weak var shadowView: UIView?
    
    
    var isFlipped = false
    
    
    //    var viewModel: SampleSwipeableCellViewModel? {
    //        didSet {
    //            configure(forViewModel: viewModel)
    //        }
    //    }
    
    //    private func configure(forViewModel viewModel: SampleSwipeableCellViewModel?) {
    //        if let viewModel = viewModel {
    //            titleLabel.text = viewModel.title
    //            subtitleLabel.text = viewModel.subtitle
    //            imageBackgroundColorView.backgroundColor = viewModel.color
    //            imageView.image = viewModel.image
    //
    //            backgroundContainerView.layer.cornerRadius = 14.0
    //            addButton.layer.cornerRadius = addButton.frame.size.height/4
    //        }
    //    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        topViewBar.roundCorners(cornerRadius: 40, corners: [.bottomLeft,.bottomRight])
        bottomViewBar.roundCorners(cornerRadius: 40, corners: [.topLeft,.topRight])
        topViewOptions.alpha = 0 //start with questions first
        
        topView.layer.cornerRadius = 20
        bottomView.layer.cornerRadius = 20
        
        // set the shadow properties
        topView.layer.shadowColor = UIColor.black.cgColor
        topView.layer.shadowOffset = CGSize(width: 8, height: 15)
        topView.layer.shadowOpacity = 0.4
        topView.layer.shadowRadius = 8
        
        // set the shadow properties
        bottomView.layer.shadowColor = UIColor.black.cgColor
        bottomView.layer.shadowOffset = CGSize(width: 6, height: 6)
        bottomView.layer.shadowOpacity = 0.2
        bottomView.layer.shadowRadius = 4.0
    }
    
    
    // MARK: - Actions
    
    @IBAction func turnButtonTapped(_ sender: Any) {
        if isFlipped {
            isFlipped = false
            
            UIView.transition(with: topView, duration: 0.35, options: [.transitionFlipFromLeft,.curveEaseInOut], animations: {
                self.topViewOptions.alpha = 0
                self.topViewQuestions.alpha = 1
                self.bottomViewTrailingConstraint.constant = 0
                self.bottomViewBottomConstraint.constant = 0
                self.layoutIfNeeded()
            }, completion: nil)
        } else {
            isFlipped = true
            UIView.transition(with: topView, duration: 0.35, options: [.transitionFlipFromRight,.curveEaseInOut], animations: {
                self.topViewOptions.alpha = 1
                self.topViewQuestions.alpha = 0
                self.bottomViewTrailingConstraint.constant = 5
                self.bottomViewBottomConstraint.constant = 35
                self.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    
    
    // MARK: - Shadow
    
    private func configureShadow() {
        // Shadow View
        self.shadowView?.removeFromSuperview()
        let shadowView = UIView(frame: CGRect(x: SwipeableCardViewCard.kInnerMargin,
                                              y: SwipeableCardViewCard.kInnerMargin,
                                              width: bounds.width - (2 * SwipeableCardViewCard.kInnerMargin),
                                              height: bounds.height - (2 * SwipeableCardViewCard.kInnerMargin)))
        insertSubview(shadowView, at: 0)
        self.shadowView = shadowView
        
        // Roll/Pitch Dynamic Shadow
        //        if motionManager.isDeviceMotionAvailable {
        //            motionManager.deviceMotionUpdateInterval = 0.02
        //            motionManager.startDeviceMotionUpdates(to: .main, withHandler: { (motion, error) in
        //                if let motion = motion {
        //                    let pitch = motion.attitude.pitch * 10 // x-axis
        //                    let roll = motion.attitude.roll * 10 // y-axis
        //                    self.applyShadow(width: CGFloat(roll), height: CGFloat(pitch))
        //                }
        //            })
        //        }
        self.applyShadow(width: CGFloat(0.0), height: CGFloat(0.0))
    }
    
    private func applyShadow(width: CGFloat, height: CGFloat) {
        if let shadowView = shadowView {
            let shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: 14.0)
            shadowView.layer.masksToBounds = false
            shadowView.layer.shadowRadius = 8.0
            shadowView.layer.shadowColor = UIColor.black.cgColor
            shadowView.layer.shadowOffset = CGSize(width: width, height: height)
            shadowView.layer.shadowOpacity = 0.15
            shadowView.layer.shadowPath = shadowPath.cgPath
        }
    }
    
    deinit {
        print("Dealloc -> SwipeableView")
    }

}
