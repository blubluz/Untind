//
//  NSAttributedString.swift
//  Untind
//
//  Created by Mihai Honceriu on 13/12/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import Foundation
import UIKit

extension NSAttributedString {
    func withLineSpacing(_ spacing: CGFloat, andAlignment alignment: NSTextAlignment = .center) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(attributedString: self)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        paragraphStyle.alignment = alignment
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        return attributedString
    }
    
    
    func boldAppearenceOf(string: String, withBoldFont boldFont: UIFont, color: UIColor? = nil) -> NSMutableAttributedString {

        let attributedString: NSMutableAttributedString = NSMutableAttributedString(attributedString: self)
        let pattern = string.lowercased()
        let range: NSRange = NSMakeRange(0, attributedString.string.count)
        var regex = NSRegularExpression()
        do {
            regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options())
            regex.enumerateMatches(in: attributedString.string.lowercased(), options: NSRegularExpression.MatchingOptions(), range: range) {
                (textCheckingResult, matchingFlags, stop) in
                let subRange = textCheckingResult?.range
                var attributes : [NSAttributedString.Key : Any] = [.font : boldFont]
                if let color = color {
                    attributes[NSAttributedString.Key.foregroundColor] = color
                }
                
                attributedString.addAttributes(attributes, range: subRange!)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return attributedString
    }
    
}
