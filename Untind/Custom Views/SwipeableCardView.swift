//
//  SwipeableCardView.swift
//  Untind
//
//  Created by Honceriu Mihai on 29/07/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

class SwipeableCardView: SwipeableView, NibView {

    /// Inner Margin
    private static let kInnerMargin: CGFloat = 20.0
    
    /// Shadow View
    private weak var shadowView: UIView?
    
    
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
        
//        configureShadow()
    }
    
    // MARK: - Shadow
    
    private func configureShadow() {
        // Shadow View
        self.shadowView?.removeFromSuperview()
        let shadowView = UIView(frame: CGRect(x: SwipeableCardView.kInnerMargin,
                                              y: SwipeableCardView.kInnerMargin,
                                              width: bounds.width - (2 * SwipeableCardView.kInnerMargin),
                                              height: bounds.height - (2 * SwipeableCardView.kInnerMargin)))
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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    
}
