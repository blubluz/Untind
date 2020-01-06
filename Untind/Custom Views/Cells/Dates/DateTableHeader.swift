//
//  File.swift
//  Untind
//
//  Created by Mihai Honceriu on 15/12/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import Foundation
import UIKit

class DateTableHeader : UICollectionReusableView {
    lazy var titleLabel : UILabel = {
       let l = UILabel()
        self.addSubview(l)
        l.activateConstraints([
            l.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            l.topAnchor.constraint(equalTo: self.topAnchor, constant: 7.5),
            l.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 7.5),
            l.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15)])
        l.font = UIFont.helveticaNeue(weight: .regular, size: 12)
        l.textColor = UIColor(red: 60, green: 79, blue: 92, alpha: 1)
        
        return l
    }()
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        _ = titleLabel
    }
    
    init() {
        super.init(frame: .zero)
        _ = titleLabel
    }
    
    required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
    }
       
}
