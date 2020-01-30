//
//  TabBarCircleView.swift
//  Untind
//
//  Created by Honceriu Mihai on 28/07/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import Foundation
import UIKit

class TabBarCircleView : UIView {
    func move(toButton button: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
            self.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        }) { (success: Bool) in
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 3, options: .curveLinear, animations: {
                self.transform = CGAffineTransform.identity
            }, completion: { (success: Bool) in

            })
        }
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 8, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
            self.center = button.center
        }) { (success: Bool) in
            
        }
    }
}
