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
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if Calendar.current.isDateInToday(self) {
            return "Today, \(dateFormatter.string(from: self))"
        } else if Calendar.current.isDateInYesterday(self) {
            return "Yesterday, \(dateFormatter.string(from: self))"
        } else {
            dateFormatter.dateFormat = "MMMM d"
            return dateFormatter.string(from: self)
        }
    }
    
    func dateTimeString() -> String {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "HH:mm"
          dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if Calendar.current.isDateInToday(self) {
            return "Today, \(dateFormatter.string(from: self))"
        } else if Calendar.current.isDateInTomorrow(self) {
            return "Tommorow, \(dateFormatter.string(from: self))"
        } else {
            return "\(self.dayName). \(dateFormatter.string(from: self))"
        }
    }
    
    func timeLeftString() -> String {
        let diff = Int(self.timeIntervalSince1970 - Date().timeIntervalSince1970)
        let hours = diff / 3600
        
        if hours != 0 {
            return "\(hours) hours, \((diff-3600*hours)/60) minutes"
        } else {
            return "\(diff/60) minutes"
        }
    }
    
    
    
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    
    var hoursLeft: Int {
        
        let diff = Int(self.timeIntervalSince1970 - Date().timeIntervalSince1970)
        let hours = diff / 3600
        
        return hours
    }
    
    var minutesLeft: Int {
        let diff = Int(self.timeIntervalSince1970 - Date().timeIntervalSince1970)
        
        return (diff/60)
    }
    
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
    
    var dayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: self)
    }
    
    static func with(year: Int, month: Int, day: Int, hour: Int, minute: Int) -> Date? {
        // Specify date components
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        // Create date from components
        let userCalendar = Calendar.current // user calendar
        return userCalendar.date(from: dateComponents)
    }
}
