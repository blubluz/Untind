//
//  UIFontExtension.swift
//  Untind
//
//  Created by Honceriu Mihai on 04/12/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import Foundation
import UIKit

enum FontWeight : String{
    case medium = "Medium"
    case regular = ""
    case bold = "Bold"
}
extension UIFont {
    static func helveticaNeue(weight: FontWeight, size: CGFloat) -> UIFont {
        if weight == .regular {
            return UIFont(name: "HelveticaNeue", size: size) ?? UIFont.systemFont(ofSize: size)
        }
        return UIFont(name: "HelveticaNeue-\(weight.rawValue)", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
