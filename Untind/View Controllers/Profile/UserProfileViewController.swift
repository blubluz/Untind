//
//  UserProfileViewController.swift
//  Untind
//
//  Created by Honceriu Mihai on 11/10/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit
import Firebase

class UserProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var selecterPointerYConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var usernameLabelYConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var selectorPointerView: UIView!
    @IBOutlet weak var selectorView: UIView!
    @IBOutlet weak var profileContainerView: UIView!
    
    @IBOutlet weak var myQuestionsButton: UIButton!
    @IBOutlet weak var myAnswersButton: UIButton!
    @IBOutlet weak var interactionButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var sexAgeLabel: UILabel!
    
    var profile: Profile?
    var date: UntindDate?
    var questions : [Question]?
    var answers : [Answer]?
    
    var isLoadingQuestions : Bool = false
    var isLoadingAnswers : Bool = false
    var didSetupSelector : Bool = false
    let headerViewMaxHeight: CGFloat = 256
    let headerViewMinHeight: CGFloat = 141
        
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "MyAnswersContainerCell", bundle: nil), forCellWithReuseIdentifier: "AnswersContainerCell")
        
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        if let profile = profile {
            avatarImageView.image = UIImage(named: profile.avatarType)
            userNameLabel.text = profile.username
        }
        
        prepareForAnimations()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !didSetupSelector {
            didSetupSelector = true
            selecterPointerYConstraint.constant = (selectorView.frame.size.width/4) * -1
        }
        selectorView.layer.cornerRadius = 24
        profileContainerView.roundCorners(cornerRadius: 20, corners: [.bottomLeft,.bottomRight])
    }
    
    
    //MARK: - Helper methods
    static func instantiate(profile: Profile? = nil) -> UserProfileViewController {
        let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        vc.profile = profile
        return vc
    }
    
    func prepareForAnimations() {
        interactionButton.layer.cornerRadius = 24.5
        
        self.interactionButton.transform = CGAffineTransform(translationX: 0, y: 150)
    }
    
    func loadData() {
        let db = Firestore.firestore()
        
        Question.fetchAll(forUserId: profile?.uid ?? "") { (error, questions) in
            if let err = error {
                print("Error getting documents: \(err)")
            } else {
                self.questions = questions
                self.collectionView.reloadData()
            }
        }
        
        
        Answer.fetchAll(forQuestionId: nil, userId: profile?.uid) { (error, answers) in
            if let err = error {
                //Handle error
                print("Error fetching answers: \(err.localizedDescription)")
            } else {
                self.answers = answers
                self.collectionView.reloadData()
            }
        }
        
        profile?.getDate(completion: { (error, date) in
            if let error = error {
                print("Error loading date: \(error.localizedDescription)")
            } else if let date = date {
                self.date = date
                if date.myRelationshipStatus == .canAskQuestion {
                  
                } else {
                    self.setupButtonFor(status: date.myRelationshipStatus)
                }
            }
        })
    }
    
    func setupButtonFor(status: UntindDate.RelationshipStatus, didSendQuestion : Bool = false) {
        if let buttonText = status.buttonText {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: .curveEaseIn, animations: {
                self.interactionButton.transform = CGAffineTransform.identity
            }, completion: nil)
            
            interactionButton.setTitle(buttonText.uppercased(), for: .normal)
            if status.interactionState == .interactive {
                interactionButton.backgroundColor = UIColor.flatOrange
            } else {
                if status != .waitingQuestionAnswer {
                    interactionButton.isEnabled = false
                }
                interactionButton.backgroundColor = UIColor.gray81.withAlphaComponent(0.4)
                interactionButton.alpha = 0.8
            }
        }
    }
    
    //MARK: - TableView Delegate & DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
        case 0:
            return questions?.count ?? 0
        case 1:
            return answers?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "ProfileQuestionCell", for: indexPath) as! ProfileQuestionCell
            cell.configureWith(question: questions![indexPath.row])
            return cell
            
        } else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "ProfileAnswerCell", for: indexPath) as! ProfileAnswerCell
            cell.configureWith(answer: answers![indexPath.row])
            return cell
        }

        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let questionVc = UIStoryboard(name: "Feed", bundle: nil).instantiateViewController(withIdentifier: "QuestionViewController") as! QuestionViewController
        
        self.modalPresentationStyle = .overCurrentContext
        questionVc.modalPresentationStyle = .overCurrentContext
        
        if tableView.tag == 0 {
            questionVc.question = questions![indexPath.row]
        } else {
            questionVc.question = answers![indexPath.row].question
        }
        self.navigationController?.pushViewController(questionVc, animated: false)
    }
    
    //MARK: - CollectionView Delegate & DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnswersContainerCell", for: indexPath) as! AnswersContainerCell
        cell.emptyStateView.isHidden = true
        if indexPath.row == 0 {
            cell.answersTableView.register(UINib(nibName: "ProfileQuestionCell", bundle: nil), forCellReuseIdentifier: "ProfileQuestionCell")
            cell.answersTableView.tag = 0
            cell.answersTableView.estimatedRowHeight = 250
            if !isLoadingQuestions {
                cell.activityIndicator.stopAnimating()
            }
        } else {
            cell.answersTableView.register(UINib(nibName: "ProfileAnswerCell", bundle: nil), forCellReuseIdentifier: "ProfileAnswerCell")
            cell.answersTableView.tag = 1
            cell.answersTableView.estimatedRowHeight = 400
            if !isLoadingAnswers {
                cell.activityIndicator.stopAnimating()
            }
        }
        
        cell.answersTableView.delegate = self
        cell.answersTableView.dataSource = self
        cell.answersTableView.reloadData()
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    //MARK: - ScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            let completionPercentage = min((scrollView.contentOffset.x * 100) / scrollView.frame.size.width, 100)
            selecterPointerYConstraint.constant = (selectorView.frame.size.width/4) * ((2 * completionPercentage/100) - 1)
            selectorPointerView.backgroundColor = UIColor.fadeFromColor(fromColor: UIColor.flatOrange, toColor: UIColor.teal2, withPercentage: completionPercentage/100)
            
            let questionsButtonColor = UIColor.fadeFromColor(fromColor: UIColor.flatOrange, toColor: UIColor.darkBlue, withPercentage: completionPercentage/100)
            myQuestionsButton.setTitleColor(questionsButtonColor, for: .normal)
            
            let answersButtonColor = UIColor.fadeFromColor(fromColor: UIColor.darkBlue, toColor: UIColor.teal2, withPercentage: completionPercentage/100)
            myAnswersButton.setTitleColor(answersButtonColor, for: .normal)
            
            if completionPercentage == 100 {
                self.collectionView.collectionViewLayout.invalidateLayout()
            }
        } else {
            let y: CGFloat = scrollView.contentOffset.y
            let newHeaderViewHeight: CGFloat = headerViewHeightConstraint.constant - y
            if newHeaderViewHeight > headerViewMaxHeight {
                headerViewHeightConstraint.constant = headerViewMaxHeight

            } else if newHeaderViewHeight < headerViewMinHeight {
                headerViewHeightConstraint.constant = headerViewMinHeight

            } else {
                self.collectionView.collectionViewLayout.invalidateLayout()
                headerViewHeightConstraint.constant = newHeaderViewHeight
                
                scrollView.contentOffset.y = 0 // block scroll view
            }
            
            //1 if transition is complete
            //0 if transition is at start
            let completionPercent = (headerViewHeightConstraint.constant - headerViewMinHeight) / (headerViewMaxHeight - headerViewMinHeight)
            avatarImageView.alpha = completionPercent * completionPercent
            sexAgeLabel.alpha = completionPercent * completionPercent
            usernameLabelYConstraint.constant = (1-completionPercent) * (-40) + 15
        }
    }
    
    //MARK: - Button actions
    @IBAction func interactionButtonTapped(_ sender: Any) {
        guard let date = self.date else {
            return
        }
        
        if date.myRelationshipStatus.interactionState == .interactive {
            switch date.myRelationshipStatus {
            case .canAskQuestion:
                let writeQVC = UIStoryboard.main.instantiateViewController(withIdentifier: "AddQuestionController") as! AddQuestionController
                writeQVC.profile = profile
                self.present(writeQVC, animated: true, completion: nil)
            case .canRequestDate:
                break
            case .shouldGiveDateResult:
                break
            case .waitingQuestionAnswer:
                if let question = date.privateQuestion {
                    let questionVc = QuestionViewController.instantiate()
                    questionVc.question = question
                    self.navigationController?.pushViewController(questionVc, animated: false)
                }
                break
            default:
                return
            }
        }
    }
    
    @IBAction func sendMessageTapped(_ sender: Any) {
        Globals.mainNavigationController?.pushViewController(ChatViewController.instantiate(), animated: true)
    }
    
    @IBAction func myQuestionsTapped(_ sender: Any) {
        if collectionView.contentOffset.x != 0 {
            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
        } else {
            if let cell = collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? MyQuestionsContainerCell {
                cell.questionsCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
    }
    
    @IBAction func reportButtonTapped(_ sender: Any) {
        let vc = ReportUserPopup.instantiate()
        vc.modalPresentationStyle = .overCurrentContext
        Globals.tabBarController?.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func myAnswersTapped(_ sender: Any) {
        if collectionView.contentOffset.x == 0 {
            collectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .left, animated: true)
        } else {
            if let cell = collectionView.cellForItem(at: IndexPath(row: 1, section: 0)) as? AnswersContainerCell {
                cell.answersTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
