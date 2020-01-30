//
//  MyQuestionsViewController.swift
//  Untind
//
//  Created by Honceriu Mihai on 06/08/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit
import Firebase

class MyQuestionsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, DraggingDelegate, AnswersDelegate, QuestionsDelegate {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var selectorView: UIView!
    @IBOutlet weak var selectorPointerView: UIView!
    @IBOutlet weak var questionsLabel: UILabel!
    @IBOutlet weak var answersLabel: UILabel!
    @IBOutlet weak var myQuestionsButton: UIButton!
    @IBOutlet weak var myAnswersButton: UIButton!
    @IBOutlet weak var selectorPointerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundViewTopConstraint: NSLayoutConstraint!
    
    var myQuestions : [Question]?
    var myAnswers : [Answer]?
    var isLoadingQuestions : Bool = false
    var isLoadingAnswers : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(UINib(nibName: "MyQuestionsContainerCell", bundle: nil), forCellWithReuseIdentifier: "MyQuestionsContainerCell")
        collectionView.register(UINib(nibName: "MyAnswersContainerCell", bundle: nil), forCellWithReuseIdentifier: "MyAnswersContainerCell")

        isLoadingQuestions = true
        isLoadingAnswers = true
        
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        let db = Firestore.firestore()
             
             db.collectionGroup("questions").whereField(FieldPath(["author", "uid"]), isEqualTo: UTUser.loggedUser?.user.uid ?? "").getDocuments { (snapshot : QuerySnapshot?, error) in
                self.isLoadingQuestions = false
                 if let err = error {
                     print("Error getting documents: \(err)")
                 } else {
                     self.myQuestions = []
                     for document in snapshot!.documents {
                         self.myQuestions?.append(Question(with: document.data()))
                     }
                     self.collectionView.reloadItems(at: [IndexPath(row: 0, section: 0)])
                 }
             }

             db.collectionGroup("answers").whereField(FieldPath(["author", "uid"]), isEqualTo: UTUser.loggedUser?.user.uid ?? "").getDocuments { (snapshot : QuerySnapshot?, error) in
                self.isLoadingAnswers = false
                 if let err = error {
                     print("Error getting documents: \(err)")
                 } else {
                     self.myAnswers = []
                     for document in snapshot!.documents {
                         self.myAnswers?.append(Answer(with: document.data()))
                     }
                     self.isLoadingAnswers = false
                     self.collectionView.reloadItems(at: [IndexPath(row: 1, section: 0)])
                 }
             }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("MyQuestionsViewController will disappear")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundView.roundCorners(cornerRadius: 30, corners: [.topLeft,.topRight])
        selectorView.layer.cornerRadius = 24
        selectorPointerView.layer.cornerRadius = 22
    }
    
    //MARK: - CollectionView Delegate & DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyQuestionsContainerCell", for: indexPath) as! MyQuestionsContainerCell
            cell.set(questions: self.myQuestions)
            cell.draggingDelegate = self
            cell.questionsDelegate = self
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyAnswersContainerCell", for: indexPath) as! AnswersContainerCell
            cell.set(answers: self.myAnswers)
            cell.draggingDelegate = self
            cell.answerDelegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let completionPercentage = min((scrollView.contentOffset.x * 100) / scrollView.frame.size.width, 100)
        selectorPointerLeadingConstraint.constant = max((selectorView.frame.size.width/2 - 2) * completionPercentage/100,2)
        selectorView.backgroundColor = UIColor.fadeFromColor(fromColor: UIColor.flatOrange, toColor: UIColor.answerTeal, withPercentage: completionPercentage/100)
        backgroundView.backgroundColor = UIColor.fadeFromColor(fromColor: UIColor(red: 249, green: 219, blue: 202, alpha: 1), toColor: UIColor(red: 247, green: 255, blue: 247, alpha: 1), withPercentage: completionPercentage/100)
        
        let questionsButtonColor = UIColor.fadeFromColor(fromColor: UIColor.gray81, toColor: UIColor.white, withPercentage: completionPercentage/100)
        myQuestionsButton.setTitleColor(questionsButtonColor, for: .normal)
        
        let answersButtonColor = UIColor.fadeFromColor(fromColor: UIColor.white, toColor: UIColor.gray81, withPercentage: completionPercentage/100)
        myAnswersButton.setTitleColor(answersButtonColor, for: .normal)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: .didSwitchTheme, object: nil, userInfo: ["theme" : indexPath.row == 0 ? ThemeMode.answer : ThemeMode.question])
    }
    
    
    //MARK: - AnswersDelegate
    func didTap(answer: Answer) {
        let questionVc = UIStoryboard(name: "Feed", bundle: nil).instantiateViewController(withIdentifier: "QuestionViewController") as! QuestionViewController
        questionVc.question = answer.question
        
        self.modalPresentationStyle = .overCurrentContext
        questionVc.modalPresentationStyle = .overCurrentContext
        self.present(questionVc, animated: false, completion: nil)
    }
    
    func didTapAnswersButton() {
        if let parentVc = self.parent as? PresentationViewController {
            parentVc.dismissContainerViewController(animated: true, completion: nil)
        }
    }
    
    //MARK: - QuestionsDelegate
    func didTapAddQuestion() {
          let writeQVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddQuestionsNavigation")
                  self.present(writeQVC, animated: true, completion: nil)
                  
    }
    
    func didTap(question: Question) {
        let questionVc = UIStoryboard(name: "Feed", bundle: nil).instantiateViewController(withIdentifier: "QuestionViewController") as! QuestionViewController
        questionVc.question = question
        
        self.modalPresentationStyle = .overCurrentContext
        questionVc.modalPresentationStyle = .overCurrentContext
        self.present(questionVc, animated: false, completion: nil)
        
    }
    
    //MARK: - DraggingDelegate
    func didCloseByDragging() {
        if let parentVc = self.parent as? PresentationViewController {
            parentVc.dismissContainerViewController(animated: true, completion: nil)
        }
    }
    
    //MARK: - Button actions
    @IBAction func myQuestionsTapped(_ sender: Any) {
        if collectionView.contentOffset.x != 0 {
            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
        } else {
            if let cell = collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? MyQuestionsContainerCell {
                cell.questionsCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
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
    
    deinit {
        print("MyQuestionsViewController did deinit")
    }
    
}
