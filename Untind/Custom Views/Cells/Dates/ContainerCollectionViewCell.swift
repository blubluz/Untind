//
//  ContainerCollectionViewCell.swift
//  Untind
//
//  Created by Mihai Honceriu on 16/12/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

class ContainerCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var collectionView: UICollectionView!
    var cellType : DateCellTestType = .upcomingDate
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.registerNib(DateCollectionViewCell.self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configureWithType(type: DateCellTestType) {
        self.cellType = type
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return 2
      }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(DateCollectionViewCell.self, for: indexPath).update(with: cellType)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: min((UIScreen.main.bounds.size.width - 50), 420), height: 82)
    }
    
}
