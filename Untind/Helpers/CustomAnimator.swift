//
//  CustomAnimator.swift
//  Untind
//
//  Created by Honceriu Mihai on 02/09/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import Foundation
import UIKit

class CustomAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    var duration : TimeInterval
    var isPresenting : Bool
    var originFrame : CGRect
//    var image : UIImage
    
    init(duration : TimeInterval, isPresenting : Bool, originFrame : CGRect) {
        self.duration = duration
        self.isPresenting = isPresenting
        self.originFrame = originFrame
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else { return }
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
        
        self.isPresenting ? container.addSubview(toView) : container.insertSubview(toView, belowSubview: fromView)
        
        
        let detailView = isPresenting ? toView : fromView
        
        guard let destinationView = detailView.viewWithTag(99) else { return }
        destinationView.alpha = 0
        
      
        let transitionView = UIView(frame: isPresenting ? originFrame : destinationView.frame)
        transitionView.layer.cornerRadius = 40.0
        transitionView.backgroundColor = UIColor.white
        container.addSubview(transitionView)
        
        toView.frame = isPresenting ?  CGRect(x: 0, y: 0, width: toView.frame.width, height: toView.frame.height) : toView.frame
        toView.alpha = isPresenting ? 0 : 1
        toView.layoutIfNeeded()
        
//        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
//
//
//            transitionView.frame = self.isPresenting ? destinationView.frame : self.originFrame
//            detailView.frame = self.isPresenting ? fromView.frame : CGRect(x: 0, y: 0, width: toView.frame.width, height: toView.frame.height)
//            detailView.alpha = self.isPresenting ? 1 : 0
//        }) { (finished) in
//            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//            transitionView.removeFromSuperview()
//            destinationView.alpha = 1
//        }
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: .curveLinear, animations: {

            transitionView.frame = self.isPresenting ? destinationView.frame : self.originFrame
            detailView.frame = self.isPresenting ? fromView.frame : CGRect(x: 0, y: 0, width: toView.frame.width, height: toView.frame.height)
            detailView.alpha = self.isPresenting ? 1 : 0
        }) { (finished) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            transitionView.removeFromSuperview()
            destinationView.alpha = 1
        }
        
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
}
