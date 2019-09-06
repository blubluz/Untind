//
//  UIAlertControllerExtension.swift
//  Untind
//
//  Created by Mihai Honceriu on 06/09/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    static func errorAlert(text: String) -> UIAlertController {
        let alert = UIAlertController(title: "Oops", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        return alert
    }
}
