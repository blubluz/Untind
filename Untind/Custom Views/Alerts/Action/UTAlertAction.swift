//
//  UTAlertAction.swift
//  Untind
//
//  Created by Mihai Honceriu on 13/12/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import Foundation
import UIKit
class UTAlertAction : NSObject {
    var handler : (() -> Void)?
    private(set) var title : String?
    private(set) var color : UIColor?
    
    static var dismiss : UTAlertAction {
        return UTAlertAction(title: "Dismiss", nil, color: .flatOrange)
    }
    
    init(title: String, _ handler: (() -> Void)? = nil, color: UIColor = UIColor.flatOrange) {
        self.handler = handler
        self.title = title
        self.color = color
    }
    
    @objc func executeAction() {
        guard let handler = self.handler else {
            return
        }
        handler()
    }
    
    deinit {
        print("UTAlertAction did deinit")
    }
}
