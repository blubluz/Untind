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
    private var shouldClose = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setQuestions(){
        questionsCollectionView.register(UINib(nibName: "MyQuestionsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MyQuestionsCollectionViewCell")
        questionsCollectionView.delegate = self
        questionsCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyQuestionsCollectionViewCell", for: indexPath) as! MyQuestionsCollectionViewCell
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
