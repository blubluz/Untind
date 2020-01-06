//
//  UITableViewExtension.swift
//  DeinDealRestaurant
//
//  Created by Mihai Honceriu on 04/12/2019.
//  Copyright © 2019 Honceriu Mihai. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    
    func registerNib<T: UICollectionViewCell>(_: T.Type, reuseIdentifier: String? = nil) {
        self.register(UINib(nibName: String(describing: T.self), bundle: nil), forCellWithReuseIdentifier: reuseIdentifier ?? String(describing: T.self))
    }
    
    func register<T: UICollectionViewCell>(_: T.Type, reuseIdentifier: String? = nil) {
        self.register(T.self, forCellWithReuseIdentifier: reuseIdentifier ?? String(describing: T.self))
    }

    func dequeue<T: UICollectionViewCell>(_: T.Type, for indexPath: IndexPath) -> T {
        guard
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: T.self),
                                           for: indexPath) as? T
            else { fatalError("Could not deque cell with type \(T.self)") }
        
        return cell
    }

    func dequeueCell(reuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
        return dequeueReusableCell(
            withReuseIdentifier: identifier,
            for: indexPath
        )
    }
}
