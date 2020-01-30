//
//  UTAlertButton.swift
//  Untind
//
//  Created by Mihai Honceriu on 13/12/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import Foundation
import UIKit
class UTAlertButton: UIButton {
    var action : UTAlertAction
    
    init(action: UTAlertAction) {
        self.action = action
        super.init(frame: .zero)
        if let font = action.buttonFont {
            titleLabel?.font = font
        } else {
            titleLabel?.font = UIFont.helveticaNeue(weight: .bold, size: 14)
        }

        setTitleColor(action.color, for: .normal)
        setTitle(action.title, for: .normal)
        addTarget(action, action: #selector(action.executeAction), for: .touchUpInside)
        
        if action.hasUnderbar {
            let bar = UIView()
            self.addSubview(bar)
            bar.activateConstraints([
                bar.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
                bar.widthAnchor.constraint(equalToConstant: 50),
                bar.heightAnchor.constraint(equalToConstant: 5),
                bar.centerXAnchor.constraint(equalTo: self.centerXAnchor)])
            bar.backgroundColor = UIColor.darkBlue
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
