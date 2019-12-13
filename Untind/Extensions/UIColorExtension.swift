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
    
    static let flatOrange = UIColor(red: 255, green: 144, blue: 117, alpha: 1)
    static let lightOrange = UIColor(red: 249, green: 219, blue: 202, alpha: 1)
    static let lightTeal = UIColor(red: 206, green: 242, blue: 237, alpha: 1)
    static let answerTeal = UIColor(red: 33, green: 208, blue: 185, alpha: 1)
    static let teal = UIColor(red: 48, green: 209, blue: 185, alpha: 1)
    static let teal2 = UIColor(red: 33, green: 208, blue: 185, alpha: 1)
    static let gray81 = UIColor(red: 81, green: 81, blue: 81, alpha: 1)
    static let darkBlue = UIColor(red: 60, green: 79, blue: 92, alpha: 1)
    static let defaultColorPageControlUnselected = UIColor(red: 128, green: 75, blue: 66, alpha: 1)
    
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat) {
        self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha)
    }
    
    static func gray(value: Int, alpha: Double? = 1) -> UIColor { 
        return UIColor(red: value, green: value, blue: value, alpha: 1)
    }
    
    static func fadeFromColor(fromColor: UIColor, toColor: UIColor, withPercentage: CGFloat) -> UIColor {
        var fromRed: CGFloat = 0.0
        var fromGreen: CGFloat = 0.0
        var fromBlue: CGFloat = 0.0
        var fromAlpha: CGFloat = 0.0
        
        fromColor.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)
        
        var toRed: CGFloat = 0.0
        var toGreen: CGFloat = 0.0
        var toBlue: CGFloat = 0.0
        var toAlpha: CGFloat = 0.0
        
        toColor.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)
        
        //calculate the actual RGBA values of the fade colour
        let red = (toRed - fromRed) * withPercentage + fromRed
        let green = (toGreen - fromGreen) * withPercentage + fromGreen
        let blue = (toBlue - fromBlue) * withPercentage + fromBlue
        let alpha = (toAlpha - fromAlpha) * withPercentage + fromAlpha
        
        // return the fade colour
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
