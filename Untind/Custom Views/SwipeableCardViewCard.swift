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
    @IBOutlet weak var topViewShadowContainer: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topViewBar: UIView!
    @IBOutlet weak var topViewOptions: UIView!
    @IBOutlet weak var topViewQuestions: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewBar: UIView!
    @IBOutlet weak var answerButton: UIButton!
    @IBOutlet weak var bottomBarImageView: UIImageView!
    @IBOutlet weak var topBarImageView: UIImageView!
    
    @IBOutlet weak var bottomViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var answerButtonBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var questionLabel: UILabel!
    private var isInAnswerMode : Bool = false
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

//        topViewBar.roundCorners(cornerRadius: 44, corners: [.bottomLeft,.bottomRight])
//        bottomViewBar.roundCorners(cornerRadius: 44, corners: [.topLeft,.topRight])
        topViewOptions.alpha = 0 //start with questions first
        
        bottomView.layer.cornerRadius = 20
        topView.layer.cornerRadius = 20
        
//        topViewShadowContainer.layer.cornerRadius = 20
//        topViewShadowContainer.layer.shadowColor = UIColor.black.cgColor
//        topViewShadowContainer.layer.shadowOffset = CGSize(width: 10.0, height: bounds.height/15)
//        topViewShadowContainer.layer.shadowRadius = 12
//        topViewShadowContainer.layer.shadowOpacity = 1
//        topViewShadowContainer.layer.shadowPath = UIBezierPath(roundedRect: topViewShadowContainer.bounds, cornerRadius: 20).cgPath
//        topViewShadowContainer.layer.masksToBounds = false
        
            answerButtonBottomConstraint.constant =  answerButton.frame.size.height/2 - bottomView.frame.origin.y/2 
        
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
                self.bottomViewBottomConstraint.constant = self.bottomView.frame.origin.y - 10
                self.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @IBAction func answerButtonTapped(_ sender: Any) {
        
        if !isInAnswerMode {
            isInAnswerMode = true
            answerButton.setImage(UIImage(named: "submit-button"), for: .normal)
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                self.topBarImageView.tintColor = #colorLiteral(red: 0.2, green: 0.262745098, blue: 0.3058823529, alpha: 1)
                self.bottomBarImageView.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                self.bottomView.backgroundColor = #colorLiteral(red: 1, green: 0.5647058824, blue: 0.4588235294, alpha: 1)
                self.layoutIfNeeded()
            }, completion: nil)
            
        } else {
            isInAnswerMode = false
            answerButton.setImage(UIImage(named: "answer-button"), for: .normal)
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                self.topBarImageView.tintColor = #colorLiteral(red: 1, green: 0.5647058824, blue: 0.4588235294, alpha: 1)
                self.bottomBarImageView.tintColor = #colorLiteral(red: 0.1294117647, green: 0.8156862745, blue: 0.7254901961, alpha: 1)
                self.bottomView.backgroundColor = #colorLiteral(red: 0.2352941176, green: 0.3098039216, blue: 0.3607843137, alpha: 1)
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
