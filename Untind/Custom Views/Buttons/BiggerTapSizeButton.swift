//
//  BiggerTapSizeButton.swift
//  Untind
//
//  Created by Honceriu Mihai on 03/10/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

class BiggerTapSizeButton: UIButton {

   override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
       let biggerFrame = bounds.insetBy(dx: -30, dy: -30)

       return biggerFrame.contains(point)
    }

}
