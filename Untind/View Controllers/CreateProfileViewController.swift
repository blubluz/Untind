//
//  CreateProfileViewController.swift
//  Untind
//
//  Created by Honceriu Mihai on 30/08/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

class CreateProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    private let cellWidth : CGFloat = min(UIScreen.main.bounds.width * 0.9, 315)
    private let cellHeight : CGFloat = min(UIScreen.main.bounds.height * 0.9, 570)
    @IBOutlet weak var pageControl: UTPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "CreateProfileFirstCell", bundle: nil), forCellWithReuseIdentifier: "CreateProfileFirstCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        pageControl.numberOfPages = 2
    }
    

    // MARK: - CollectionView Delegate & DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CreateProfileFirstCell", for: indexPath) as! CreateProfileFirstCell
            cell.layer.cornerRadius = 40
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CreateProfileFirstCell", for: indexPath) as! CreateProfileFirstCell
            cell.layer.cornerRadius = 40
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let inset = (UIScreen.main.bounds.size.width - CGFloat(cellWidth)) / 2
        
        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.selectedPageIndex = indexPath.section
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }

}
