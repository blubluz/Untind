//
//  FeedViewController.swift
//  Untind
//
//  Created by Honceriu Mihai on 28/07/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON
import IHKeyboardAvoiding

class FeedViewController: UIViewController {

        @IBOutlet weak var topBarTopConstraint: NSLayoutConstraint!
        @IBOutlet weak var topBarProportionalHeightConstraint: NSLayoutConstraint!
        @IBOutlet weak var profileButton: UIButton!
        @IBOutlet weak var profileNotificationsView: UIView!
        @IBOutlet weak var topBarView: UIView!
        @IBOutlet weak var titleLabel: UILabel!
        @IBOutlet weak var filterButton: UIButton!
        @IBOutlet weak var filterButtonBackground: UIView!
        @IBOutlet weak var addQuestionIndicatorArrow: UIImageView!
        @IBOutlet weak var closeModalButton: UIButton!
    @IBOutlet weak var swipeableCardViewContainer: SwipeableCardViewContainer!
    var questions : [Question] = []
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
                filterButtonBackground.layer.cornerRadius = filterButtonBackground.frame.size.width/2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
                closeModalButton.transform = CGAffineTransform(translationX: -150, y: 0).rotated(by: 360)

        let db = Firestore.firestore()
        
        db.collection("questions").getDocuments { (querySnapshot : QuerySnapshot?, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let question = Question(with: document)
                    guard question.author.uid != UTUser.loggedUser!.user.uid && !question.answers.contains(where: { (answer) -> Bool in
                        return answer.author.uid == UTUser.loggedUser!.user.uid
                    }) else {
                        continue
                    }
                    
                    self.questions.append(question)
                    self.swipeableCardViewContainer.dataSource = self
                    self.swipeableCardViewContainer.delegate = self
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

                profileNotificationsView.layer.cornerRadius = profileNotificationsView.frame.size.height/2
                profileNotificationsView.layer.shadowOpacity = 0.3
                profileNotificationsView.layer.shadowRadius = 4
                profileNotificationsView.layer.shadowOffset = CGSize(width: 0, height: 5)
                
                profileButton.setImage(UIImage(named: UTUser.loggedUser?.userProfile?.avatarType ?? "anonymous-avatar"), for: .normal)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        KeyboardAvoiding.avoidingView = self.swipeableCardViewContainer
     
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @objc func keyboardWillAppear() {
        self.swipeableCardViewContainer.transform = CGAffineTransform(translationX: 0, y: -120)
    }
    
    @objc func keyboardWillDisappear() {
        self.swipeableCardViewContainer.transform = CGAffineTransform.identity
    }
    
      @IBAction func filterButtonTapped(_ sender: Any) {
            if filterButton.currentImage == UIImage(named: "add-button-icon") {
//                guard !(self.presentedContainerViewController is AddQuestionController) else {
//                    return
//                }
    
                let writeQVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddQuestionsNavigation")
                self.present(writeQVC, animated: true, completion: nil)
    
    //            addQuestionIndicatorArrow.isHidden = false
    
            } else {
    
            }
        }
    
    deinit {
        print("FeedViewController did deinit")
    }
}


//MARK: - SwipeableCardViewDataSource
extension FeedViewController: SwipeableCardViewDataSource, SwipeableCardViewDelegate {
    func numberOfCards() -> Int {
        return questions.count
    }
    
    func card(forItemAtIndex index: Int) -> SwipeableCardViewCard {
        let cardView = SwipeableCardViewCard()
        cardView.question = questions[index]
        cardView.questionDelegate = self
        return cardView
    }
    
    func viewForEmptyCards() -> UIView? {
        return nil
    }
    
    func didSelect(card: SwipeableCardViewCard, atIndex index: Int) {
        
        let questionVc = UIStoryboard(name: "Feed", bundle: nil).instantiateViewController(withIdentifier: "QuestionViewController") as! QuestionViewController
        questionVc.question = card.question
        
        self.modalPresentationStyle = .overCurrentContext
        questionVc.modalPresentationStyle = .overCurrentContext
        self.navigationController?.pushViewController(questionVc, animated: false)
    }
}

//MARK: - QuestionCardDelegate
extension FeedViewController: QuestionCardDelegate {
    func didAnswerQuestion(question: Question, answer: Answer) {
        swipeableCardViewContainer.swipeAwayTopCard(animated: true)
    }
    
    func didTapProfile(profile: Profile) {
        self.navigationController?.pushViewController(UserProfileViewController.instantiate(), animated: true)
    }
}
