//
//  SwipeableCardViewCard.swift
//  Untind
//
//  Created by Honceriu Mihai on 29/07/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol QuestionCardDelegate: class {
    func didAnswerQuestion(question: Question, answer : Answer)
    func didTapProfile(profile: Profile)
    func didTapReport(profile: Profile)
}

class SwipeableCardViewCard: SwipeableCardView, UIGestureRecognizerDelegate, UITextViewDelegate {

   
    
    /// Outlets
    @IBOutlet weak var topViewShadowContainer: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topViewBottomView: UIView!
    @IBOutlet weak var topViewOptions: UIView!
    @IBOutlet weak var topViewQuestions: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var turnButton: UIButton!
    @IBOutlet weak var mainTurnButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var answerButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
    
    @IBOutlet weak var bottomViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var expireLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var authorAvatarImageView: UIImageView!
    
    @IBOutlet weak var smallQuestionLabel: UILabel!
    @IBOutlet weak var answerTextField: UTAnswerTextField!
    
    
    weak var questionDelegate: QuestionCardDelegate?
    
    private var _question : Question?
    var question : Question? {
        didSet {
            _question = question!
            questionLabel.text = question?.questionText
            smallQuestionLabel.text = question?.questionText
            authorNameLabel.text = question?.author.username
            postDateLabel.text = question?.postDate.toFormattedString()
            commentsButton.setTitle("\(question?.answersCount ?? 0) COMMENTS", for: .normal)
            authorAvatarImageView.image = UIImage(named: question?.author.avatarType ?? "placeholder")
        }
    }
    
    private var isInAnswerMode : Bool = false {
        didSet {
            let themeMode = isInAnswerMode ? ThemeMode.answer : ThemeMode.question
            //            NotificationCenter.default.post(name: .didSwitchTheme, object: nil, userInfo: ["theme" : themeMode])
            if isInAnswerMode == true {
                answerTextField.textField.becomeFirstResponder()
                Async.main {
                    self.answerButton.setImage(UIImage(named: "submit-button"), for: .normal)
                    
                }
                
                self.commentsButton.setImage(#imageLiteral(resourceName: "rotate"), for: .normal)
                self.commentsButton.setTitle(nil, for: .normal)
                self.commentsButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
                animateAnswerOptions(onScreen: true)
                
            } else {
                answerTextField.textField.resignFirstResponder()
                Async.main {
                    self.answerButton.setImage(UIImage(named: "answer-icon"), for: .normal)
                }
                self.commentsButton.setImage(nil, for: .normal)
                self.commentsButton.setTitle("12 COMMENTS", for: .normal)
                self.commentsButton.transform = CGAffineTransform.identity
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
        self.tapGestureDelegate = self
        answerTextField.delegate = self
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.tapGestureDelegate = self
        answerTextField.delegate = self
    }
    
 
    
    override func layoutSubviews() {
        super.layoutSubviews()

        topViewOptions.alpha = 0 //start with questions first
        
        bottomView.layer.cornerRadius = 20
        topView.layer.cornerRadius = 20
        
        // set the shadow properties
        bottomView.layer.shadowColor = UIColor.black.cgColor
        bottomView.layer.shadowOffset = CGSize(width: 6, height: 6)
        bottomView.layer.shadowOpacity = 0.2
        bottomView.layer.shadowRadius = 4.0
        
        
        self.smallQuestionLabel.transform = CGAffineTransform(translationX: 0, y: -self.frame.size.height)
        self.answerTextField.transform = CGAffineTransform(translationX: 0, y: 10 + self.frame.size.height)
        
    }
    
    
    
    // MARK: - Tap Gesture Delegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let touchView = touch.view else {
            return true
        }
        
        let shouldAllow = !(touchView == answerButton || touchView == turnButton || touchView == mainTurnButton || isFlipped || touchView == profileButton || isInAnswerMode)
        
        if shouldAllow {
            return true
        } else {
            return false
        }
        
    }

    // MARK: - Button Actions
    
    @IBAction func didTapUserProfile(_ sender: Any) {
        questionDelegate?.didTapProfile(profile: question!.author)
    }
    
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
                self.bottomViewTrailingConstraint.constant = 15
                self.bottomViewBottomConstraint.constant = self.bottomView.frame.origin.y - 10
                self.layoutIfNeeded()
            }, completion: nil)
        }
    }
    @IBAction func seeMoreQuestionsTapped(_ sender: Any) {
        self.didTapUserProfile(self)
    }
    
    @IBAction func seePublicAnswersTapped(_ sender: Any) {
        self.cardDelegate?.didTap(view: self)
    }
    
    @IBAction func reportButtonTapped(_ sender: Any) {
        if let author = question?.author {
            questionDelegate?.didTapReport(profile: author)
        }
    }
    @IBAction func copySetQuestionsTapped(_ sender: Any) {
    }
    
    @IBAction func comentsButtonTapped(_ sender: Any) {
        if isInAnswerMode {
            isInAnswerMode = false
        } else {
            return
        }
    }
    
    @IBAction func answerButtonTapped(_ sender: Any) {
        if !isInAnswerMode {
            isInAnswerMode = true
        } else {
            let answer = Answer(with: UTUser.loggedUser!.userProfile!, postDate: Date(), answerText: answerTextField.textField.text, upvotes: 0, rating: 0, question: question!)
            
            SVProgressHUD.show()
            answer.post { (error) in
                SVProgressHUD.dismiss()
                if let err = error {
                    print("Error posting answer: \(err.localizedDescription)")
                } else {
                    print("Answer posted succesfuly")
                    self.question?.answers?.append(answer)
                    if let question = self._question {
                        self.questionDelegate?.didAnswerQuestion(question: question, answer: answer)
                    }
                    
                    self.answerTextField.textField.text = ""
                    self.isInAnswerMode = false
                }
            }
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
                self.expireLabel.transform = CGAffineTransform.identity

            }, completion: nil)
            
            UIView.animate(withDuration: 0.4, delay: 0.3, usingSpringWithDamping: 0.6, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
                self.topViewBottomView.transform = CGAffineTransform.identity
                
            }, completion: nil)
            
            UIView.animate(withDuration: 0.4, delay: 0.35, usingSpringWithDamping: 0.6, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
                
            }, completion: nil)
            
        } else {
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveLinear, animations: {
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
                self.expireLabel.transform = CGAffineTransform(translationX: 250, y:0)

            }, completion: nil)
            
            UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 8, options: .curveEaseOut, animations: {
                self.topViewBottomView.transform = CGAffineTransform(translationX: 0, y: self.frame.size.height)
            }, completion: nil)
            
        }
    }
    
    deinit {
        print("Dealloc -> SwipeableView")
    }

}
