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
    
    
    
    @IBOutlet weak var selectorPointerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var selectorPointerView: UIView!
    @IBOutlet weak var selectorView: UIView!
    
    @IBOutlet weak var myQuestionsButton: UIButton!
    @IBOutlet weak var myAnswersButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    var profile: Profile?
    var questions : [Question]?
    var answers : [Answer]?
    
    var isLoadingQuestions : Bool = false
    var isLoadingAnswers : Bool = false
    let headerViewMaxHeight: CGFloat = 314
    let headerViewMinHeight: CGFloat = 195
        
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
        
        loadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        selectorView.layer.cornerRadius = 24
        selectorPointerView.layer.cornerRadius = 22
    }
    
    static func instantiate(profile: Profile? = nil) -> UserProfileViewController {
        let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        vc.profile = profile
        return vc
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
            } else {
                self.answers = answers
                self.collectionView.reloadData()
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
            selectorPointerLeadingConstraint.constant = max((selectorView.frame.size.width/2 - 2) * completionPercentage/100,2)
            selectorView.backgroundColor = UIColor.fadeFromColor(fromColor: UIColor.flatOrange, toColor: UIColor.answerTeal, withPercentage: completionPercentage/100)
            
            let questionsButtonColor = UIColor.fadeFromColor(fromColor: UIColor.gray81, toColor: UIColor.white, withPercentage: completionPercentage/100)
            myQuestionsButton.setTitleColor(questionsButtonColor, for: .normal)
            
            let answersButtonColor = UIColor.fadeFromColor(fromColor: UIColor.white, toColor: UIColor.teal2, withPercentage: completionPercentage/100)
            myAnswersButton.setTitleColor(answersButtonColor, for: .normal)
            
            if completionPercentage == 100 {
                self.collectionView.collectionViewLayout.invalidateLayout()
            }
        } else {
            let y: CGFloat = scrollView.contentOffset.y
            let newHeaderViewHeight: CGFloat = headerViewHeightConstraint.constant - y
            
            if newHeaderViewHeight > headerViewMaxHeight {
                headerViewHeightConstraint.constant = headerViewMaxHeight
                self.userNameLabel.transform = CGAffineTransform.identity

            } else if newHeaderViewHeight < headerViewMinHeight {
                headerViewHeightConstraint.constant = headerViewMinHeight
                self.userNameLabel.transform = CGAffineTransform(scaleX: headerViewMinHeight/headerViewMaxHeight, y: headerViewMinHeight/headerViewMaxHeight)

            } else {
                self.userNameLabel.transform = CGAffineTransform(scaleX: newHeaderViewHeight/headerViewMaxHeight, y: newHeaderViewHeight/headerViewMaxHeight)
                self.collectionView.collectionViewLayout.invalidateLayout()
                headerViewHeightConstraint.constant = newHeaderViewHeight
                scrollView.contentOffset.y = 0 // block scroll view
            }
        }
    }
    
    //MARK: - Button actions
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
