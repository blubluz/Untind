//
//  QuestionViewController.swift
//  Untind
//
//  Created by Honceriu Mihai on 20/09/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {

    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var answersView: UIView!
    @IBOutlet weak var questionViewShadow: UIImageView!
    
    @IBOutlet weak var answersTableView: UITableView!
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionAuthorAvatar: UIImageView!
    @IBOutlet weak var questionAuthorName: UILabel!
    @IBOutlet weak var questionPostDate: UILabel!
    @IBOutlet weak var questionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var questionAuthorView: UIView!
    
    public weak var question : Question?
    private var didAppearOnce = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answersTableView.register(UINib(nibName: "AnswerTableViewCell", bundle: nil), forCellReuseIdentifier: "AnswerTableViewCell")
        answersTableView.delegate = self
        answersTableView.dataSource = self
        self.automaticallyAdjustsScrollViewInsets = false
        answersTableView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 130, right: 0)
        
        if let question = question {
            questionLabel.text = question.questionText
            questionAuthorName.text = question.author.username
            questionAuthorAvatar.image = UIImage(named: question.author.avatarType)
            questionPostDate.text = question.postDate.toFormattedString()
            self.answersTableView.reloadData()
            
            question.fetchAnswers { (error) in
                self.answersTableView.reloadData()
            }
        }
        
        
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        questionView.roundCorners(cornerRadius: 20, corners: [.bottomLeft,.bottomRight])
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !didAppearOnce {
            didAppearOnce = true
            doAppearAnimations()
        }
    }
    
    
    //MARK: - Helper methods
       static func instantiate() -> QuestionViewController {
           let vc = UIStoryboard(name: "Feed", bundle: nil).instantiateViewController(withIdentifier: "QuestionViewController") as! QuestionViewController
           return vc
       }
    
    func doDisappearAnimations(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.45, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveLinear, animations: {
            self.questionView.transform = CGAffineTransform(translationX: 0, y: -self.questionView.bounds.size.height - 30)
            self.questionViewShadow.transform = CGAffineTransform(translationX: 0, y: -self.questionViewShadow.bounds.size.height - 30)
            self.answersView.transform = CGAffineTransform(translationX: 0, y: self.answersView.bounds.size.height + 30)
            
        }) { (finished) in
            completion()
        }
    }
    
    func doAppearAnimations() {
        questionView.transform = CGAffineTransform(translationX: 0, y: -questionView.bounds.size.height - 30)
        questionViewShadow.transform = CGAffineTransform(translationX: 0, y: -questionViewShadow.bounds.size.height - 30)
        answersView.transform = CGAffineTransform(translationX: 0, y: answersView.bounds.size.height + 30)
        
        UIView.animate(withDuration: 0.45, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveLinear, animations: {
            self.questionView.transform = CGAffineTransform.identity
            self.questionViewShadow.transform = CGAffineTransform.identity
        }) { (finished) in

        }
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations: {
            self.answersView.transform = CGAffineTransform.identity
        }) { (finished) in
            
        }
    }
    
    //MARK: - Button Actions
    @IBAction func didTapAuthorProfile(_ sender: Any) {
        self.navigationController?.pushViewController(UserProfileViewController.instantiate(profile: question?.author), animated: true)
    }
    
}

//MARK: - Table View Delegate & DataSource
extension QuestionViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return question?.answers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerTableViewCell") as! AnswerTableViewCell
        cell.configureWith(answer: question!.answers![indexPath.section])
        cell.delegate = self
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
}

//MARK: - Answer Cell Delegate
extension QuestionViewController: AnswerCellDelegate {
    func didTapProfile(profile: Profile) {
        self.navigationController?.pushViewController(UserProfileViewController.instantiate(profile: profile), animated: true)
    }
    
    func didVote(value: Vote, answer: Answer) {
        answer.vote(newVote: value) {
            
        }
    }
}
