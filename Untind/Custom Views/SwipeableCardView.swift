//
//  SwipeableCardView.swift
//  Untind
//
//  Created by Honceriu Mihai on 29/07/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

class SwipeableCardView: SwipeableView, NibView {

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    
}
