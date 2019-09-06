//
//  SwipeableCardViewCard.swift
//  Untind
//
//  Created by Honceriu Mihai on 29/07/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit
import SVProgressHUD

class SwipeableCardViewCard: SwipeableCardView {

   
    
    /// Outlets
    @IBOutlet weak var topViewShadowContainer: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topViewBar: UIView!
    @IBOutlet weak var topViewBottomView: UIView!
    @IBOutlet weak var topViewOptions: UIView!
    @IBOutlet weak var topViewQuestions: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewBar: UIView!
    @IBOutlet weak var answerButton: UIButton!
    @IBOutlet weak var bottomBarImageView: UIImageView!
    @IBOutlet weak var topBarImageView: UIImageView!
    
    @IBOutlet weak var questionCardLine: UIImageView!
    @IBOutlet weak var bottomViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var answerButtonBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var authorAvatarImageView: UIImageView!
    
    @IBOutlet weak var smallQuestionLabel: UILabel!
    @IBOutlet weak var answerTextField: UTAnswerTextField!
    
    var question : Question? {
        didSet {
            questionLabel.text = question?.questionText
            smallQuestionLabel.text = question?.questionText
            authorNameLabel.text = question?.author.username
            postDateLabel.text = question?.postDate.toFormattedString()
            authorAvatarImageView.image = UIImage(named: question?.author.avatarType ?? "placeholder")
        }
    }
    
    private var isInAnswerMode : Bool = false {
        didSet {
            let themeMode = isInAnswerMode ? ThemeMode.answer : ThemeMode.question
            NotificationCenter.default.post(name: .didSwitchTheme, object: nil, userInfo: ["theme" : themeMode])
            if isInAnswerMode == true {
                answerTextField.textField.becomeFirstResponder()
                answerButton.setImage(UIImage(named: "submit-button"), for: .normal)
                animateAnswerOptions(onScreen: true)
            } else {
                answerButton.setImage(UIImage(named: "answer-button"), for: .normal)
                animateAnswerOptions(onScreen: false)
            }
        }
    }
    
    /// Inner Margin
    private static let kInnerMargin: CGFloat = 20.0
    
    /// Shadow View
    private weak var shadowView: UIView?
    
    
    var isFlipped = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
      
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
 
    
    override func layoutSubviews() {
        super.layoutSubviews()

        topViewOptions.alpha = 0 //start with questions first
        
        bottomView.layer.cornerRadius = 20
        topView.layer.cornerRadius = 20
        answerButtonBottomConstraint.constant =  answerButton.frame.size.height/2 - bottomView.frame.origin.y/2 - 10
        
        // set the shadow properties
        bottomView.layer.shadowColor = UIColor.black.cgColor
        bottomView.layer.shadowOffset = CGSize(width: 6, height: 6)
        bottomView.layer.shadowOpacity = 0.2
        bottomView.layer.shadowRadius = 4.0
        
        
        self.smallQuestionLabel.transform = CGAffineTransform(translationX: 0, y: -self.frame.size.height)
        self.answerTextField.transform = CGAffineTransform(translationX: 0, y: 10 + self.frame.size.height)
        
    }
    
    
    
    // MARK: - Button Actions
    
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
    @IBAction func seeMoreQuestionsTapped(_ sender: Any) {
    }
    @IBAction func seePublicAnswersTapped(_ sender: Any) {
    }
    @IBAction func reportButtonTapped(_ sender: Any) {
    }
    @IBAction func copySetQuestionsTapped(_ sender: Any) {
    }
    
    @IBAction func answerButtonTapped(_ sender: Any) {
        if !isInAnswerMode {
            isInAnswerMode = true
        } else {
            SVProgressHUD.show()
            let answer = Answer(with: UTUser.loggedUser!.userProfile!, postDate: Date(), answerText: answerTextField.textField.text, upvotes: 0, rating: 0, question: question!)
            question?.addAnswer(answer: answer, completion: { (error) in
                if let err = error {
                    print("There was an error:\(err)")
                } else {
                    
                }
                
                self.answerTextField.textField.text = ""
                SVProgressHUD.dismiss()
                self.isInAnswerMode = false
            })
            
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
    
    //MARK: - ANIMATIONS
    
    private func animateAnswerOptions(onScreen: Bool) {
        if onScreen == false {
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveLinear, animations: {
                self.topBarImageView.tintColor = #colorLiteral(red: 1, green: 0.5647058824, blue: 0.4588235294, alpha: 1)
                self.bottomBarImageView.tintColor = #colorLiteral(red: 0.1294117647, green: 0.8156862745, blue: 0.7254901961, alpha: 1)
                self.bottomView.backgroundColor = #colorLiteral(red: 0.2352941176, green: 0.3098039216, blue: 0.3607843137, alpha: 1)
                self.layoutIfNeeded()
            }, completion: nil)
            
            //ANIMATE ANSWER OPTIONS OFF THE SCREEN
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
                self.smallQuestionLabel.transform = CGAffineTransform(translationX: 0, y: -self.smallQuestionLabel.frame.size.height-self.smallQuestionLabel.frame.origin.y)
                self.answerTextField.transform = CGAffineTransform(translationX: 0, y: 10 + self.frame.size.height)
            }, completion: nil)
            //END
            
            UIView.animate(withDuration: 0.4, delay: 0.25, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.questionLabel.transform = CGAffineTransform.identity
                
            }, completion: nil)
            
            UIView.animate(withDuration: 0.4, delay: 0.3, usingSpringWithDamping: 0.6, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
                self.topViewBottomView.transform = CGAffineTransform.identity
                
            }, completion: nil)
            
            UIView.animate(withDuration: 0.4, delay: 0.35, usingSpringWithDamping: 0.6, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
                self.questionCardLine.transform = CGAffineTransform.identity
                
            }, completion: nil)
            
        } else {
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveLinear, animations: {
                self.topBarImageView.tintColor = #colorLiteral(red: 0.2, green: 0.262745098, blue: 0.3058823529, alpha: 1)
                self.bottomBarImageView.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                self.bottomView.backgroundColor = #colorLiteral(red: 1, green: 0.5647058824, blue: 0.4588235294, alpha: 1)
                self.layoutIfNeeded()
            }, completion: nil)
            
            UIView.animate(withDuration: 0.4, delay: 0.4, usingSpringWithDamping: 0.6, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
                self.smallQuestionLabel.transform = CGAffineTransform.identity
            }, completion: nil)
            
            UIView.animate(withDuration: 0.4, delay: 0.3, usingSpringWithDamping: 0.9, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
                self.answerTextField.transform = CGAffineTransform.identity
            }, completion: nil)
            
            
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
                self.questionLabel.transform = CGAffineTransform(translationX: 0, y: -self.frame.size.height)
                
            }, completion: nil)
            
            UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 8, options: .curveEaseOut, animations: {
                self.topViewBottomView.transform = CGAffineTransform(translationX: 0, y: self.frame.size.height)
                
            }, completion: nil)
            
            UIView.animate(withDuration: 0.4, delay: 0.1, usingSpringWithDamping: 1, initialSpringVelocity: 8, options: .curveLinear, animations: {
                self.questionCardLine.transform = CGAffineTransform(translationX: 0, y: self.frame.size.height)
                
            }, completion: nil)
        }
    }
    
    deinit {
        print("Dealloc -> SwipeableView")
    }

}
