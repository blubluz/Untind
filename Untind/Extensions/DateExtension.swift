//
//  UIDateExtension.swift
//  Untind
//
//  Created by Honceriu Mihai on 13/08/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import Foundation

extension Date {
    func toFormattedString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        if Calendar.current.isDateInToday(self) {
            return "Today, \(dateFormatter.string(from: self))"
        } else if Calendar.current.isDateInYesterday(self) {
            return "Yesterday, \(dateFormatter.string(from: self))"
        } else {
            dateFormatter.dateFormat = "MMMM d"
            return dateFormatter.string(from: self)
        }
    }
}
