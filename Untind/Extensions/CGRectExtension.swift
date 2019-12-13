//
//  CGRectExtension.swift
//  Untind
//
//  Created by Honceriu Mihai on 13/12/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import Foundation
import UIKit

extension CGSize {
    static var screenSize : CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.height)
    }
}
