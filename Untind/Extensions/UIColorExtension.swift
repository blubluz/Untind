//
//  UIColorExtension.swift
//  Untind
//
//  Created by Honceriu Mihai on 27/07/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat) {
        self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha)
    }
    
    static let flatOrange = UIColor(red: 255, green: 144, blue: 117, alpha: 1)
    static let peachOrange = UIColor(red: 249, green: 219, blue: 202, alpha: 1)
}
