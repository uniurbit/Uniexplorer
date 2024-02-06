//
//  DateEx.swift
//  App24PA BETA
//
//  Created by Manuela on 12/05/2020.
//  Copyright © 2020 VJ Technology. All rights reserved.
//

import Foundation

//MARK: - Date
extension Date {
    
    func setTime(hour: Int, min: Int, sec: Int, timeZoneAbbrev: String = "UTC") -> Date? {
        let x: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let cal = Calendar.current
        var components = cal.dateComponents(x, from: self)
        
        components.timeZone = TimeZone(abbreviation: timeZoneAbbrev)
        components.hour = hour
        components.minute = min
        components.second = sec
        
        return cal.date(from: components)
    }
    
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
    
    func currentYear()->Int{
        let calendar = Calendar.current
        return calendar.component(.year, from: self)
    }
    func currentMonth()->Int{
        let calendar = Calendar.current
        return calendar.component(.month, from: self)
    }
    func currentDay()->Int{
        let calendar = Calendar.current
        return calendar.component(.day, from: self)
    }
    func currentWeekDay()->Int{
        let calendar = Calendar.current
        return calendar.component(.weekday, from: self)
    }
    
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

    
    
    func addDays(num: Int) -> Date {
        let modifiedDate = Calendar.current.date(byAdding: .day, value: num, to: self)!
        return modifiedDate
    }
    
    
    func nearestThirtyMinutes() -> Date {
        let cal = Calendar.current
        let minutes = cal.component(.minute, from: self)
        let roundedSeconds = lrint(Double(minutes) / 30) * 30
        return cal.date(byAdding: .minute, value: roundedSeconds - minutes, to: self)!
    }
    func nearest15Minutes() -> Date {
        let cal = Calendar.current
        let minutes = cal.component(.minute, from: self)
        let roundedMinute = (Double(minutes) / 15).rounded(.awayFromZero) * 15
        // Round up to nearest date:
        return cal.date(byAdding: .minute, value: Int(roundedMinute) - minutes, to: self)!
    }
    

    
    
//    func nextFifteenMinutes() -> Date{
//        let cal = Calendar.current
//        let minutes = cal.component(.minute, from: self)
//        var roundedMinute = minutes
//        print(minutes)
//        if minutes <= 15 {
//            roundedMinute = 15
//        } else if minutes <= 30 {
//            roundedMinute = 30
//        } else if minutes <= 45 {
//            roundedMinute = 45
//        } else {
//            roundedMinute = 60
//        }
//        return cal.date(byAdding: .minute, value: roundedMinute - minutes, to: self)!
//    }
}

