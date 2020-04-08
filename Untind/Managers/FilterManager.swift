//
//  FilterManager.swift
//  Untind
//
//  Created by Mihai Honceriu on 22/03/2020.
//  Copyright © 2020 FincPicsels. All rights reserved.
//

import UIKit

struct FilterManager {
    static var selectedFilters : [Filter] = []
}

struct Filter {
    enum FilterType {
        case minAge
        case maxAge
        case women
        case men
    }
    
    var type : FilterType
    var isSelected : Bool = false
    var value : Int?
    
}
