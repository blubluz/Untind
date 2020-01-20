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

class FeedViewController: UIViewController {

        @IBOutlet weak var topBarView: UIView!
        @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var swipeableCardViewContainer: SwipeableCardViewContainer!
    var questions : [Question] = []
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = true
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        topBarView.tag = UIViewTags.feedTopBar.rawValue

        NotificationCenter.default.addObserver(self,
            selector: #selector(keyboardWillAppear),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(self,
                  selector: #selector(keyboardWillDisappear),
                  name: UIResponder.keyboardWillHideNotification,
                  object: nil)
        let db = Firestore.firestore()
        
        db.collection("questions").getDocuments { (querySnapshot : QuerySnapshot?, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let question = Question(with: document)
                    guard question.author.uid != UTUser.loggedUser!.user.uid, question.respondent == nil else {
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
     
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillAppear() {
        topBarView.alpha = 0
        self.swipeableCardViewContainer.transform = CGAffineTransform(translationX: 0, y: -120)
    }
    
    @objc func keyboardWillDisappear() {
        topBarView.alpha = 1
        self.swipeableCardViewContainer.transform = CGAffineTransform.identity
    }
    
      @IBAction func filterButtonTapped(_ sender: Any) {
                let writeQVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddQuestionsNavigation")
                self.present(writeQVC, animated: true, completion: nil)
        }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
    func didTapReport(profile: Profile) {
        let vc = ReportUserPopup.instantiate()
        vc.modalPresentationStyle = .overCurrentContext
        Globals.tabBarController?.present(vc, animated: false, completion: nil)
    }
    
    func didAnswerQuestion(question: Question, answer: Answer) {
        swipeableCardViewContainer.swipeAwayTopCard(animated: true)
    }
    
    func didTapProfile(profile: Profile) {
        self.navigationController?.pushViewController(UserProfileViewController.instantiate(profile: profile), animated: true)
    }
}
