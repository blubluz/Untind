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
    @IBOutlet weak var addCardButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var swipeableCardViewContainer: SwipeableCardViewContainer!
    var questions : [Post] = []
    @IBOutlet weak var cardContainerYConstraint: NSLayoutConstraint!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    var lastPostSnapshot : DocumentSnapshot?
    private var didLoadAllPosts = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = true
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        topBarView.tag = UIViewTags.feedTopBar.rawValue
        
        
        Post.fetchPublicPosts(limit: 5, lastSnapshot: self.lastPostSnapshot) { (error, posts, newLastSnapshot) in
            if let error = error {
                print ("Error getting documents: \(error)")
                self.present(UTAlertController(title: "Oops", message: "There was an issue getting the latest posts"), animated: true, completion: nil)
            } else {
                self.questions.append(contentsOf: posts)
                self.lastPostSnapshot = newLastSnapshot
                
                self.swipeableCardViewContainer.dataSource = self
                self.swipeableCardViewContainer.delegate = self
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(keyboardWillAppear),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(self,
                      selector: #selector(keyboardWillDisappear),
                      name: UIResponder.keyboardWillHideNotification,
                      object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        PushNotificationManager.shared.registerforRemoteNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func loadMorePosts() {
        Post.fetchPublicPosts(limit: 5, lastSnapshot: self.lastPostSnapshot) { (error, posts, newLastSnapshot) in
            if let error = error {
                print ("Error getting documents: \(error)")
                self.present(UTAlertController(title: "Oops", message: "There was an issue getting the latest posts"), animated: true, completion: nil)
            } else {
                self.questions.append(contentsOf: posts)
                self.swipeableCardViewContainer.addRemainingCards(posts.count)
                if newLastSnapshot != nil {
                    self.lastPostSnapshot = newLastSnapshot
                }
            }
        }
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
    
    //MARK: - Actions
    @IBAction func filterButtonTapped(_ sender: Any) {
        let filtersVc = FiltersViewController.instantiate(withUserSettings: UTUser.loggedUser!.userProfile!.settings)
        filtersVc.modalPresentationStyle = .overCurrentContext
        Globals.tabBarController?.present(filtersVc, animated: false, completion: nil)
    }
    
    @IBAction func createCardTapped(_ sender: Any) {
                let writeQVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddQuestionController") as! AddQuestionController
        writeQVC.delegate = self
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
        return questions.count + 1
    }
    
    func card(forItemAtIndex index: Int) -> SwipeableCardViewCard {
        if index == questions.count - 3 {
            self.loadMorePosts()
        }
        
        if index == questions.count {
            let cardView = SwipeableCardViewCard()
            cardView.isFeedbackCard = true
            return cardView
        }
        
        let cardView = SwipeableCardViewCard()
        cardView.question = questions[index]
        cardView.questionDelegate = self
        return cardView
    }
    
    func viewForEmptyCards() -> UIView? {
        return nil
    }
    
    func didSelect(card: SwipeableCardViewCard, atIndex index: Int) {
        if card.question == nil {
            return
        }
        
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
    
    func didAnswerQuestion(question: Post, answer: Answer) {
        swipeableCardViewContainer.swipeAwayTopCard(animated: true)
    }
    
    func didTapProfile(profile: Profile) {
        self.navigationController?.pushViewController(UserProfileViewController.instantiate(profile: profile), animated: true)
    }
    
    func didTapSendDateRequest(profile: Profile) {
        let vc = SendDatePopup.instantiate()
        vc.invitedPerson = profile
        vc.modalPresentationStyle = .overCurrentContext
        Globals.tabBarController?.present(vc, animated: false, completion: nil)
    }
}


//MARK: - AddQuestionDelegate
extension FeedViewController : AddQuestionDelegate {
    func postQuestionCompleted(error: Error?, question: Post?) {
        self.dismiss(animated: true) {
            if error != nil {
                self.present(UIAlertController.errorAlert(text: "There was an error \(error!.localizedDescription)"), animated: true, completion: nil)
            } else {
                if let question = question {
                    let alertController = UTAlertController(title: "Success!", message:"Your post is now in the public cards stack. You can find it in the profile section")
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}
