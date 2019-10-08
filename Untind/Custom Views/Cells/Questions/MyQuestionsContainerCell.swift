//
//  MyQuestionsContainerCell.swift
//  Untind
//
//  Created by Honceriu Mihai on 06/08/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

protocol DraggingDelegate : class{
    func didCloseByDragging()
}

protocol QuestionsDelegate: class {
    func didTap(question: Question)
    func didTapAddQuestion()
}

class MyQuestionsContainerCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var questionsCollectionView: UICollectionView!
    weak var draggingDelegate : DraggingDelegate?
    weak var questionsDelegate : QuestionsDelegate?
    var questions : [Question]?
    private var shouldClose = true
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.startAnimating()
    }
    
    func set(questions: [Question]?, isLoading: Bool = false){
        self.questions = questions
        
        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
            if questions != nil {
                       questionsCollectionView.isHidden = false
                   }
        }
        
        questionsCollectionView.register(UINib(nibName: "AddQuestionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AddQuestionCollectionViewCell")
        questionsCollectionView.register(UINib(nibName: "MyQuestionsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MyQuestionsCollectionViewCell")

        questionsCollectionView.delegate = self
        questionsCollectionView.dataSource = self
        
        if questions?.count == 0 {
            emptyStateView.isHidden = false
        } else {
            emptyStateView.isHidden = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = questions?.count, count > 0{
            return count + 1
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == questions?.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddQuestionCollectionViewCell", for: indexPath) as! AddQuestionCollectionViewCell
            return cell

        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyQuestionsCollectionViewCell", for: indexPath) as! MyQuestionsCollectionViewCell
        cell.configureWith(question: questions![indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let heightWidthRatio = 273.0/158.0
        let width = max(130, UIScreen.main.bounds.size.width/2 - 30)
        return CGSize(width: width, height: width * CGFloat(heightWidthRatio))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == questions?.count {
            questionsDelegate?.didTapAddQuestion()
            return
        }
        questionsDelegate?.didTap(question: questions![indexPath.row])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y == 0 {
            shouldClose = true
        }
        
        if shouldClose == true && scrollView.contentOffset.y <= 0{
            if scrollView.contentOffset.y < -100 {
                draggingDelegate?.didCloseByDragging()
            }
        } else {
            shouldClose = false
        }
    }
    
    @IBAction func didTapAddQuestion(_ sender: Any) {
        questionsDelegate?.didTapAddQuestion()
    }
    
}
