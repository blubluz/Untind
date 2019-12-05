//
//  StringExtension.swift
//  Untind
//
//  Created by Honceriu Mihai on 05/12/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func combineUniquelyWith(string value: String) -> String{
        var result = ""
        let firstString : String
        let secondString : String
        var stringToRemove = ""
        firstString = self.count < value.count ? self : value
        secondString = self.count < value.count ? value : self
        for (c1,c2) in zip(firstString, secondString) {
            stringToRemove.append(c2)
            result.append((c1<c2 ? c1+c2:c2+c1))
        }
        
        return result + secondString.replacingOccurrences(of: stringToRemove, with: "")
    }
}
