//
//  FeedViewController.swift
//  Untind
//
//  Created by Honceriu Mihai on 28/07/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    @IBOutlet weak var topViewBar: UIView!
    @IBOutlet weak var bottomViewBar: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topViewOptions: UIView!
    @IBOutlet weak var topViewQuestions: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewBottomConstraint: NSLayoutConstraint!
    
    var isFlipped = false
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topViewBar.roundCorners(cornerRadius: 40, corners: [.bottomLeft,.bottomRight])
        bottomViewBar.roundCorners(cornerRadius: 40, corners: [.topLeft,.topRight])
        topViewOptions.alpha = 0 //start with questions first
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func rotateButtonTapped(_ sender: Any) {
        if isFlipped {
            isFlipped = false
          
            UIView.transition(with: topView, duration: 0.35, options: [.transitionFlipFromLeft,.curveEaseInOut], animations: {
                self.topViewOptions.alpha = 0
                self.topViewQuestions.alpha = 1
                self.bottomViewTrailingConstraint.constant = 0
                self.bottomViewBottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            isFlipped = true
            UIView.transition(with: topView, duration: 0.35, options: [.transitionFlipFromRight,.curveEaseInOut], animations: {
                self.topViewOptions.alpha = 1
                self.topViewQuestions.alpha = 0
                self.bottomViewTrailingConstraint.constant = 5
                self.bottomViewBottomConstraint.constant = 35
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
}
