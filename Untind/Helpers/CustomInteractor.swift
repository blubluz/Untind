//
//  CustomInteractor.swift
//  Untind
//
//  Created by Honceriu Mihai on 02/09/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import Foundation
import UIKit

class CustomInteractor : UIPercentDrivenInteractiveTransition {
    
    var navigationController : UINavigationController
    var shouldCompleteTransition = false
    var transitionInProgress = false
    
    init?(attachTo viewController : UIViewController) {
        if let nav = viewController.navigationController {
            self.navigationController = nav
            super.init()
            setupBackGesture(view: viewController.view)
        } else {
            return nil
        }
    }
    
    private func setupBackGesture(view : UIView) {
        let swipeBackGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleBackGesture(_:)))
        swipeBackGesture.edges = .left
        view.addGestureRecognizer(swipeBackGesture)
    }
    
    @objc private func handleBackGesture(_ gesture : UIScreenEdgePanGestureRecognizer) {
        let viewTranslation = gesture.translation(in: gesture.view?.superview)
        var progress = viewTranslation.x / self.navigationController.view.frame.width
        
        switch gesture.state {
        case .began:
            transitionInProgress = true
            navigationController.popViewController(animated: true)
            break
        case .changed:
            shouldCompleteTransition = progress > 0.25
            update(progress)
            break
        case .cancelled:
            transitionInProgress = false
            cancel()
            break
        case .ended:
            transitionInProgress = false
            shouldCompleteTransition ? finish() : cancel()
            break
        default:
            return
        }
    }
    
}
