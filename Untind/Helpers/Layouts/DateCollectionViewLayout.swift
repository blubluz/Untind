//
//  DateCollectionViewLayout.swift
//  Untind
//
//  Created by Mihai Honceriu on 17/12/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import Foundation
import UIKit

class DateCollectionViewLayout : UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attribs = super.layoutAttributesForElements(in: rect)
        var newAttribs = [UICollectionViewLayoutAttributes]()

        return attribs
    }
}
