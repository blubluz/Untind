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

class MyQuestionsContainerCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    @IBOutlet weak var questionsCollectionView: UICollectionView!
    weak var draggingDelegate : DraggingDelegate?
    var questions : [Question]?
    private var shouldClose = true
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.startAnimating()
    }
    
    func set(questions: [Question]?){
        self.questions = questions
        
        if questions != nil {
            questionsCollectionView.isHidden = false
            activityIndicator.stopAnimating()
            
        }
        questionsCollectionView.register(UINib(nibName: "MyQuestionsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MyQuestionsCollectionViewCell")
        questionsCollectionView.delegate = self
        questionsCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questions?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyQuestionsCollectionViewCell", for: indexPath) as! MyQuestionsCollectionViewCell
        cell.configureWith(question: questions![indexPath.row])
        cell.layer.cornerRadius = 20
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let heightWidthRatio = 273.0/158.0
        let width = max(130, UIScreen.main.bounds.size.width/2 - 30)
        return CGSize(width: width, height: width * CGFloat(heightWidthRatio))
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
    
}
