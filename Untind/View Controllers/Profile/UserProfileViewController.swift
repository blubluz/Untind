//
//  UserProfileViewController.swift
//  Untind
//
//  Created by Honceriu Mihai on 11/10/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit


class UserProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    //MARK: - Outlets
    @IBOutlet weak var selecterPointerYConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var usernameLabelYConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var selectorPointerView: UIView!
    @IBOutlet weak var selectorView: UIView!
    @IBOutlet weak var profileContainerView: UIView!
    @IBOutlet weak var profileContainerShadowView: UIView!
    
    @IBOutlet weak var myQuestionsButton: UIButton!
    @IBOutlet weak var myAnswersButton: UIButton!
    @IBOutlet weak var interactionButton: UIButton!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var sexAgeLabel: UILabel!
    
    //MARK: - Properties
    var profile: Profile?
    var date: UTDate?
    var questions : [Post]? = []
    var answers : [Answer]? = []
    
    var isLoadingQuestions : Bool = true
    var isLoadingAnswers : Bool = true
    var didSetupSelector : Bool = false
    let headerViewMaxHeight: CGFloat = 256
    let headerViewMinHeight: CGFloat = 141
        
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.registerNib(ProfileEmptyStateCell.self)
        collectionView.registerNib(AnswersContainerCell.self)
        
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        if let interactivePopGestureRecognizer = navigationController?.interactivePopGestureRecognizer {
            collectionView.panGestureRecognizer.require(toFail: interactivePopGestureRecognizer)
        }
        
        if let profile = profile {
            avatarImageView.image = UIImage(named: profile.avatarType)
            userNameLabel.text = profile.username
            sexAgeLabel.text = "\(profile.gender.shortGender), \(profile.age)"
            if profile.uid.isMyId {
                reportButton.setTitle("Edit Profile", for: .normal)
                if let nav = self.navigationController, nav.viewControllers.count > 1 {
                    self.backButton.setImage(UIImage(named: "back-button"), for: .normal)
                } else {
                    self.backButton.setImage(UIImage(named: "settings-icon"), for: .normal)
                }
            }
        }
        
        interactionButton.layer.cornerRadius = 24.5
        prepareForAnimations()
        profileContainerView.layer.roundCorners(radius: 20)
        profileContainerShadowView.layer.applySketchShadow(color: .black, alpha: 0.14, x: 0, y: 37, blur: 51, spread: -34)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        prepareForAnimations()
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
        self.interactionButton.transform = CGAffineTransform(translationX: 0, y: 150)
    }
    
    func loadData() {
        let db = Firestore.firestore()
        
        Post.fetchAll(forUserId: profile?.uid ?? "") { (error, questions) in
            if let err = error {
                print("Error getting documents: \(err)")
            } else {
                self.isLoadingQuestions = false
                self.questions = questions
                self.collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
            }
        }
        
        
        Answer.fetchAll(forQuestionId: nil, userId: profile?.uid) { (error, answers) in
            if let err = error {
                //Handle error
                print("Error fetching answers: \(err.localizedDescription)")
            } else {
                self.isLoadingAnswers = false
                self.answers = answers
                self.collectionView.reloadItems(at: [IndexPath(item: 1, section: 0)])
            }
        }
        if profile?.uid != UTUser.loggedUser?.userProfile?.uid {
            
        }
        profile?.getDate(completion: { (error, date) in
            if let error = error {
                print("Error loading date: \(error.localizedDescription)")
            } else if let date = date {
                self.date = date
                self.setupButtonFor(status: date.myRelationshipStatus)
            }
        })
    }
    
    func setupButtonFor(status: UTDate.RelationshipStatus, didSendQuestion : Bool = false) {
        if let buttonText = status.buttonText, let profile = self.profile, !profile.uid.isMyId {
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
        if indexPath.row == 0 {
                if questions?.count == 0 {
                    let title = profile?.uid.isMyId ?? false ? "Why No \nQuestions" : "No questions \nposted!"
                    let message = profile?.uid.isMyId ?? false ? "Ask a new question, and increase \nyour chances of finding someone with \nthe right response!" : "When this user will post a question, \nyou will see it here."
                    let cell = collectionView.dequeue(ProfileEmptyStateCell.self, for: indexPath).update(withTitle: title, message: message, buttonTitle: profile?.uid.isMyId ?? false ? "Create a Post" : nil, mode: .leftOriented, image: UIImage(named: "no-questions-icon"), isLoading: self.isLoadingQuestions)
                    cell.delegate = self
                    return cell
                }
            
            cell.answersTableView.register(UINib(nibName: "ProfileQuestionCell", bundle: nil), forCellReuseIdentifier: "ProfileQuestionCell")
            cell.answersTableView.tag = 0
            cell.answersTableView.estimatedRowHeight = 250
            
        } else {
                if answers?.count == 0 {
                    let title = profile?.uid.isMyId ?? false ? "Get more \ninvolved" : "No answers \nposted!"
                    let message = profile?.uid.isMyId ?? false ? "Start by browsing for new questions \nposted by others. If they like what you \nsay, they will send you a date request!" : "When this user will post \nan answer, you will see it here."
                    let cell = collectionView.dequeue(ProfileEmptyStateCell.self, for: indexPath).update(withTitle: title, message: message, buttonTitle: profile?.uid.isMyId ?? false ? "Browse Question" : nil , mode: .rightOriented, image: UIImage(named: "no-answers-icon"), isLoading: self.isLoadingAnswers)
                    cell.delegate = self
                    return cell
                }
            
            cell.answersTableView.register(UINib(nibName: "ProfileAnswerCell", bundle: nil), forCellReuseIdentifier: "ProfileAnswerCell")
            cell.answersTableView.tag = 1
            cell.answersTableView.estimatedRowHeight = 400
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
            backButton.tintColor = UIColor.fadeFromColor(fromColor: UIColor.flatOrange, toColor: UIColor.teal2, withPercentage: completionPercentage/100)
            reportButton.setTitleColor(UIColor.fadeFromColor(fromColor: UIColor.flatOrange, toColor: UIColor.teal2, withPercentage: completionPercentage/100), for: .normal)
            interactionButton.backgroundColor = UIColor.fadeFromColor(fromColor: UIColor.flatOrange, toColor: UIColor.teal2, withPercentage: completionPercentage/100)
            
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
            profileContainerShadowView.layer.applySketchShadow(color: .black, alpha: 0.14, x: 0, y: 37, blur: 51, spread: -34)

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
                let vc = SendDatePopup.instantiate()
                vc.invitedPerson = profile
                vc.modalPresentationStyle = .overCurrentContext
                Globals.tabBarController?.present(vc, animated: false, completion: nil)
                break
            case .shouldGiveDateResult:
                break
            case .waitingQuestionAnswer, .shouldAnswerQuestion:
                if let question = date.privateQuestion {
                    let questionVc = QuestionViewController.instantiate()
                    questionVc.question = question
                    self.navigationController?.pushViewController(questionVc, animated: false)
                }
                break
            case.shouldAnswerDateRequest:
                let vc = AcceptDatePopup.instantiate()
                vc.date = date
                vc.modalPresentationStyle = .overCurrentContext
                Globals.tabBarController?.present(vc, animated: false, completion: nil)
                break
            case .chatStarted :
                let chatVc = ChatViewController.instantiate()
                chatVc.date = date
                Globals.mainNavigationController?.pushViewController(chatVc, animated: true)
            default:
                return
            }
        }
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
        if let profile = profile {
            if profile.uid.isMyId {
                //open Edit Profile modal
                return
            }
        }
        
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
        if let nav = self.navigationController, nav.viewControllers.count > 1 {
            self.navigationController?.popViewController(animated: true)
        } else if let profile = profile {
                if profile.uid.isMyId {
                    let alertVc = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                    alertVc.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (action) in
                        LoginManager().logOut()
                        do {
                            PushNotificationManager.shared.deleteToken()
                            try Auth.auth().signOut()
                            
                            //Delete current logged user profile
                            UTUser.deleteUserProfile(locally: true)
                            
                            //Go to tab bar controller
                            let onboardingNav = UIStoryboard.main.instantiateViewController(withIdentifier: "OnobardingNavigationController")
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.window?.rootViewController = onboardingNav
                        } catch let error as NSError {
                            print(error)
                        }
                    }))
                
                alertVc.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                Globals.tabBarController?.present(alertVc, animated: true, inContainer: false)
            }
        }
        
        
    }
    
}

//MARK: - ProfileEmptyStateDelegate
extension UserProfileViewController : ProfileEmptyStateDelegate {
    func didTapButton() {
        guard let visibleCell = collectionView.visibleCells.last else {
            return
        }
        
        switch collectionView.indexPath(for: visibleCell)?.row {
        case 0:
            let qvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddQuestionController") as! AddQuestionController
            qvc.delegate = self
            Globals.tabBarController?.present(qvc, animated: true, completion: nil)
        case 1:
            Globals.tabBarController?.feedButtonTapped(Globals.tabBarController!.feedButton)
        default:
            break
        }
    }
}

extension UserProfileViewController : AddQuestionDelegate {
    func postQuestionCompleted(error: Error?, question: Post?) {
        self.dismiss(animated: true) {
            if error != nil {
                self.present(UIAlertController.errorAlert(text: "There was an error \(error!.localizedDescription)"), animated: true, completion: nil)
            } else {
                if let question = question {
                    let alertController = UTAlertController(title: "Success!", message:"Your post is now in the public cards stack. You can find it in the profile section")
                    let action = UTAlertAction(title: "Okay", {
                        self.questions?.append(question)
                        self.collectionView.reloadData()
                    })
                    alertController.addNewAction(action: action)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}
