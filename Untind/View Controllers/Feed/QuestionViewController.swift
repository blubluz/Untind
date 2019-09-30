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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answersTableView.register(UINib(nibName: "AnswerTableViewCell", bundle: nil), forCellReuseIdentifier: "AnswerTableViewCell")
        answersTableView.delegate = self
        answersTableView.dataSource = self
        answersTableView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 50, right: 0)
        
        if let question = question {
            questionLabel.text = question.questionText
            questionAuthorName.text = question.author.username
            questionAuthorAvatar.image = UIImage(named: question.author.avatarType)
            questionPostDate.text = question.postDate.toFormattedString()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        questionView.roundCorners(cornerRadius: 20, corners: [.bottomLeft,.bottomRight])
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        doDisappearAnimations {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        doAppearAnimations()
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
}

extension QuestionViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return question?.answers.count ?? 0
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
        cell.configureWith(answer: question!.answers[indexPath.section])
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
}
