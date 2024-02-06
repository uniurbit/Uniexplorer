//
//  DateUtility.swift
//  ITWA
//
//  Created by Manuela on 07/05/2020.
//  Copyright © 2020 VJ Technology. All rights reserved.
//

import Foundation

extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options, timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!) {
        self.init()
        self.formatOptions = formatOptions
        self.timeZone = timeZone
    }
}

extension Formatter {
    static let iso8601withFractionalSeconds = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
    static let iso8601withoutFractionalSeconds = ISO8601DateFormatter([.withInternetDateTime])
}

extension Date {
    var iso8601withFractionalSeconds: String { return Formatter.iso8601withFractionalSeconds.string(from: self) }
    var iso8601withoutFractionalSeconds: String { return Formatter.iso8601withoutFractionalSeconds.string(from: self) }
}

extension String {
    var iso8601withFractionalSeconds: Date? { return Formatter.iso8601withFractionalSeconds.date(from: self) }
    var iso8601withoutFractionalSeconds: Date? { return Formatter.iso8601withoutFractionalSeconds.date(from: self) }
}

class DateUtility {
    
    internal static func when(date:Date) -> String {
        let dayLessTime = date.setTime(hour: 0, min: 0, sec: 0)!
        if dayLessTime.days(from: Date().setTime(hour: 0, min: 0, sec: 0)!) == 0  {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            return "\(dateFormatter.string(from: date))"
            
        }
        if dayLessTime.days(from: Date().setTime(hour: 0, min: 0, sec: 0)!) == -1 {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            return "\("Ieri".customLocalized) \(dateFormatter.string(from: date))"
        }
        if dayLessTime.days(from: Date().setTime(hour: 0, min: 0, sec: 0)!) < -1
            && dayLessTime.days(from: Date().setTime(hour: 0, min: 0, sec: 0)!) > -9 {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE HH:mm"
            return dateFormatter.string(from: date)
        }
        if date.days(from: Date()) > 9{
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM HH:mm"
            return dateFormatter.string(from: date)
        }

        if (date.currentYear() - Date().currentYear()) == 0{
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM HH:mm"
            return dateFormatter.string(from: date)
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM YY HH:mm"
        return dateFormatter.string(from: date)
    }
    
    
    class func getDateAndTime(date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: date)
        return date
    }
    class func getTime(date: String) -> Date? {
        if date != "chiuso" {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current // set locale to reliable US_POSIX
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.date(from:date)
        }else{
            return nil
        }
    }
    class func getTime2(date: String) -> Date? {
        if date != "chiuso"{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            dateFormatter.locale = Locale.current // set locale to reliable US_POSIX
            if dateFormatter.date(from: date) == nil{
                dateFormatter.dateFormat = "HH:mm"
                return dateFormatter.date(from:date)
            }else{
                dateFormatter.dateFormat = "HH:mm:ss"
                return dateFormatter.date(from:date)
            }
        }else{
            return nil
        }
    }
    class func getDate(time: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale(identifier: "it_IT")
        return dateFormatter.date(from: time) // replace Date String
    }
    class func getCurrentTime() -> String{
        let date = Date()
        let dateFormatterData = DateFormatter()
        dateFormatterData.locale = Locale(identifier: "it_IT")
        dateFormatterData.dateFormat = "HH:mm:ss"
        let oggi = dateFormatterData.string(from: date)
        return oggi
    }
    
    class func getDateStringForServer(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
    }
    class func getEligibleDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
    }
    class func getEligibleDateTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
    }
    class func getTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
    }
    class func getDateAndTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE d MMMM yyyy \nHH:mm"
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
    }
    
    class func convertDateTime(orario:String) -> Date {
        let data = Date()
        let ora = convertHour(orario)
        let min = convertMin(orario)
        let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        gregorian?.locale = Locale(identifier: "it_IT")
        gregorian?.timeZone = TimeZone.current
        var components = gregorian!.components([.year, .month, .day, .hour, .minute], from: data)
        components.hour = Int(ora)!
        components.minute = Int(min)
        return gregorian!.date(from: components)!
    }
    
    class func convertDateTimeFromServer(orario:String, data: Date) -> Date {
        let ora = convertHour(orario)
        let min = convertMin(orario)
        let date = Calendar.current.date(bySettingHour: Int(ora)!, minute: Int(min)!, second: 0, of: data)!
        return date
    }
    class func convertDateTimefromDate(data:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: data)!
    }
    
    class func convertStringIntoData(data:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: data)!
    }
    
    class func getTimeFromDate(_ date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: date)
        dateFormatter.locale = Locale(identifier: "it_IT")
        dateFormatter.dateFormat = "HH:mm"
        return  dateFormatter.string(from: date!)
    }
    
    
    class func getDateFromTimeDate(_ date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: date)
        dateFormatter.locale = Locale(identifier: "it_IT")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return  dateFormatter.string(from: date!)
    }
    
    class func getDateFromTimeDateFormat(_ date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: date)
        dateFormatter.locale = Locale(identifier: "it_IT")
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return  dateFormatter.string(from: date!)
    }
    
    class func getTimeDateFromDate(_ date: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: date)
        dateFormatter.locale = Locale(identifier: "it_IT")
        dateFormatter.dateFormat = "HH:mm"
        return  date!
    }
    
    class func convertMin(_ date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "mm"
        return  dateFormatter.string(from: date!)
    }
    
    class func convertHour(_ date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "HH"
        return  dateFormatter.string(from: date!)
    }
    class func convertHourFromDate(date: Date) -> String {
        var calendar = Calendar.current
        calendar.locale = Locale.current
        let hourInt = calendar.component(.hour, from: date)
        var hourString = String(hourInt)
        if hourInt < 10 {
            hourString = "0\(hourInt)"
        }
        return hourString
    }
    
    class func convertMinuteFromDate(date: Date) -> String {
        var date = date
        var calendar = Calendar.current
        calendar.locale = Locale.current
        let minInt = calendar.component(.minute, from: date)

        if minInt == 15 || minInt == 45 {
            date = calendar.date(byAdding: .minute, value:  -15, to: date)!
        }
        let newMin = calendar.component(.minute, from: date)
        var newMinString = String(newMin)

        if newMin < 10 {
            newMinString = "0\(newMin)"
        }
        return newMinString
    }
    
    
    class func convertDateFormater(_ date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return  dateFormatter.string(from: date!)
    }
    
    

    
    class func convert(_ date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let date = dateFormatter.date(from: date)
        dateFormatter.locale = Locale(identifier: "it_IT")
        dateFormatter.dateFormat = "HH:mm"
        return  dateFormatter.string(from: date!)
    }
    
    class func getDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
    }
    
    
    
    class func getTomorrowDate() -> String {
        return DateUtility.getDateString(date: Date().addDays(num: 1))
    }
    
    class func getTodayDate() -> String {
        let date = Date()
        let dateFormatterData = DateFormatter()
        dateFormatterData.locale = Locale(identifier: "it_IT")
        dateFormatterData.dateFormat = "EEEE"
        let oggi = dateFormatterData.string(from: date)
        return oggi
    }
    
    class func getDateToday() -> String {
        let date = Date()
        let dateFormatterData = DateFormatter()
        dateFormatterData.locale = Locale(identifier: "it_IT")
        dateFormatterData.dateFormat = "yyyy-MM-dd"
        let oggi = dateFormatterData.string(from: date)
        return oggi
    }
    
    class func convertFullDate(date: String) -> String{
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: date)!
        dateFormatter.dateFormat = "HH:mm" ; //"dd-MM-yyyy HH:mm:ss"
        dateFormatter.locale = tempLocale // reset the locale --> but no need here
        let dateString = dateFormatter.string(from: date)
        print("EXACT_DATE : \(dateString)")
        return dateString
    }
    
    
    class func convertDateForSym(date: String) -> String? {
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        if let date = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dateFormatter.locale = tempLocale // reset the locale --> but no need here
            let dateString = dateFormatter.string(from: date)
            return dateString
        } else {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            guard let date = dateFormatter.date(from: date) else {return nil}
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dateFormatter.locale = tempLocale // reset the locale --> but no need here
            let dateString = dateFormatter.string(from: date)
            return dateString
        }
    }
    
    class func convertDateForInsurance(date: String) -> String{
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.date(from: date)!
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        dateFormatter.locale = tempLocale // reset the locale --> but no need here
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    class func convertDateForInsertVeicolo(date: String) -> String{
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.date(from: date)!
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        dateFormatter.locale = tempLocale // reset the locale --> but no need here
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    class func convertDateForInsertVeicoloManuale(date: String) -> String{
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.date(from: date)!
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        dateFormatter.locale = tempLocale // reset the locale --> but no need here
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    class func getTodayDateInsertVeicoloFormat() -> String {
        let date = Date()
        let dateFormatterData = DateFormatter()
        dateFormatterData.locale = Locale(identifier: "it_IT")
        dateFormatterData.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        let oggi = dateFormatterData.string(from: date)
        return oggi
    }
    
    
    class func convertFullDateToDate(date: String) -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: date)
        return date
    }
    
    class func convertFullDateToDatePercorsi(date: String) -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        let date = dateFormatter.date(from: date)
        return date
    }
    
    class func extractYear(_ date: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        guard let date = dateFormatter.date(from: date) else { return nil }
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }
    
    class func extractYear(_ date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }
    
    class func convertMessageDate(_ date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: date)
        dateFormatter.locale = Locale(identifier: "it_IT")
        dateFormatter.dateFormat = "HH:mm"
        return  dateFormatter.string(from: date!)
    }
    
    class func convertMessageStringToDate(_ date: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return  dateFormatter.date(from: date)!
    }

    
    class func convertRoomStringToDate(_ date: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return  dateFormatter.date(from: date)!
    }

    
    class func getNextDays(day: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "it_IT")
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.date(from: day)
        
        let res = date!.addingTimeInterval(24*60*60)
        
        let dateFormatterData = DateFormatter()
        dateFormatterData.locale = Locale(identifier: "it_IT")
        dateFormatterData.dateFormat = "dd-MM-yyyy"
        
        let nextDay = dateFormatterData.string(from: res)
        return nextDay
    }
    
    class func getNextNDay(n: Double, day: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "it_IT")
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.date(from: day)
        
        let res = date!.addingTimeInterval(n*60*60)
        
        let dateFormatterData = DateFormatter()
        dateFormatterData.locale = Locale(identifier: "it_IT")
        dateFormatterData.dateFormat = "dd-MM-yyyy"
        
        let nextDay = dateFormatterData.string(from: res)
        return nextDay
    }
    
    class func getTodayUserFormat() -> String {
        let date = Date()
        let dateFormatterData = DateFormatter()
        dateFormatterData.locale = Locale(identifier: "it_IT")
        dateFormatterData.dateFormat = "dd-MM-yyyy"
        let oggi = dateFormatterData.string(from: date)
        return oggi
    }
    
    class func getCurrentDate() -> String {
        let date = Date()
        let dateFormatterData = DateFormatter()
        dateFormatterData.locale = Locale(identifier: "it_IT")
        dateFormatterData.dateFormat = "dd/MM/yyyy"
        let oggi = dateFormatterData.string(from: date)
        return oggi
    }
    
    //METEO
    
    class func getCurrentDateForMeteo() -> String {
        let date = Date()
        let dateFormatterData = DateFormatter()
        dateFormatterData.locale = Locale(identifier: "it_IT")
        dateFormatterData.dateFormat = "yyyy-MM-dd HH"
        let oggi = dateFormatterData.string(from: date)
        return oggi
    }
    
    class func convertStringToDateForMeteo(_ date: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return  dateFormatter.date(from: date)!
    }
    
    class func convertDateToStringForMeteo(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd HH"
        dateFormatter.locale = Locale(identifier: "it_IT")
        return dateFormatter.string(from: date)
    }
    
    class func getTimeForMeteo(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HH"
        dateFormatter.locale = Locale(identifier: "it_IT")
        return dateFormatter.string(from: date)
    }
    
    //METEO
    
    class func addMinutesToDate(date: Date) -> Date {
        let calendar = Calendar.current
        let add = calendar.date(byAdding: .minute, value: 30, to: date)
        return add!
    }
    
    class func addSecondsToDate(date: Date) -> Date {
        let calendar = Calendar.current
        let add = calendar.date(byAdding: .second, value: 59, to: date)
        return add!
    }
    
    class func addTwoHoursToDate(date: Date) -> Date {
        let calendar = Calendar.current
        let add = calendar.date(byAdding: .hour, value: 2, to: date)
        return add!
    }
    
    class func addHoursAndMinuteToDate(date: Date, hours: Int, minutes: Int) -> Date {
        let calendar = Calendar.current
        let dateWithHours = calendar.date(byAdding: .hour, value: hours, to: date)
        let dateWithMinute = calendar.date(byAdding: .minute, value: minutes, to: dateWithHours!)
        return dateWithMinute!
    }
    
    
    class func isDataSuperata(orarioLimite: String) -> Bool {
        guard let dateMax = DateUtility.getDateFromTime(time: orarioLimite) else {
            return true
        }
        return Date() > dateMax
    }
    
    class func getDateFromTime(time: String) -> Date? {
        let calendar = Calendar.current
        guard let orarioMassimoDate = DateUtility.getTime(date: time) else {
            return nil
        }
        let ora = calendar.dateComponents([.hour, .minute], from: orarioMassimoDate)
        let date = Calendar.current.date(bySettingHour: ora.hour!, minute: ora.minute!, second: 0, of: Date())!
        return date
    }
    
    class func setTime(dateTime: String, hour: Int, minutes: Int, seconds: Int) -> Date? {
        guard let orarioDate = DateUtility.getDateAndTime(date: dateTime) else {
            return nil
        }
        let date = Calendar.current.date(bySettingHour: hour, minute: minutes, second: seconds, of: orarioDate)!
        return date
    }
    
    class func getDateFromTime2(time: String) -> Date {
        let calendar = Calendar.current
        guard let orarioMassimoDate = DateUtility.getTime2(date: time) else {
            return Date()
        }
        let ora = calendar.dateComponents([.hour, .minute], from: orarioMassimoDate)
        let date = Calendar.current.date(bySettingHour: ora.hour!, minute: ora.minute!, second: 0, of: Date())!
        return date
    }
    
    class func getDateFromTimewithBool(time: String, first: Bool) -> Date? {
        let calendar = Calendar.current
        if first == true{
            guard let orarioMassimoDate = DateUtility.getTime2(date: time) else {
                return nil
            }
            let ora = calendar.dateComponents([.hour, .minute], from: orarioMassimoDate)
            let date = Calendar.current.date(bySettingHour: ora.hour!, minute: ora.minute!, second: 0, of: Date())!
            return date

        }else{
            guard let orarioMassimoDate = DateUtility.getTime(date: time) else {
                return nil
            }
            let ora = calendar.dateComponents([.hour, .minute], from: orarioMassimoDate)
            let date = Calendar.current.date(bySettingHour: ora.hour!, minute: ora.minute!, second: 0, of: Date())!
            return date
        }

    }

    class func isSunday() -> Bool {
        return Date().currentWeekDay() == 1
    }
    class func isSaturday() -> Bool {
        return Date().currentWeekDay() == 7
    }
}
