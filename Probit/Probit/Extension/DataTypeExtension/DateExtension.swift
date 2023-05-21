//
//  DateExtension.swift
//  Probit
//
//  Created by Beacon on 10/08/2022.
//

import Foundation

extension Date {
    // MARK: - Get components
    var second: Int {
        get {
            return Calendar.current.component(.second, from: self)
        }
    }
    
    var minute: Int {
        get {
            return Calendar.current.component(.minute, from: self)
        }
    }
    
    var hour: Int {
        get {
            return Calendar.current.component(.hour, from: self)
        }
    }
    
    var day: Int {
        get {
            return Calendar.current.component(.day, from: self)
        }
    }
    
    var month: Int {
        get {
            return Calendar.current.component(.month, from: self)
        }
    }
    
    var year: Int {
        get {
            return Calendar.current.component(.year, from: self)
        }
    }
    
    // MARK: - Get Other Date
    func otherMonth(duration: Int = 1) -> Date {
        var coms = DateComponents()
        coms.month = duration
        return Calendar.current.date(byAdding: coms, to: self)!
    }
    
    func getComponents() -> DateComponents {
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.day, .month, .year, .hour, .minute, .second])
        return calendar.dateComponents(unitFlags, from: self)
    }
    
    func nextDate(number: Int = 1) -> Date {
        var coms = DateComponents()
        coms.day = number
        return Calendar.current.date(byAdding: coms, to: self)!
    }
    
    // MARK: - Get Time String
    func stringFromDate(format: String) -> String {
        let formatter = DateFormatter.init()
        formatter.dateFormat = format
        formatter.locale = .current
        return formatter.string(from: self)
    }
    
    func stringFromDateGMT(_ format: String? = "yyyy-MM-dd HH:mm:ss '(GMT 'ZZZZZ)") -> String {
        let formatter = DateFormatter.init()
        formatter.dateFormat = format
        formatter.locale = .current
        return formatter.string(from: self)
    }
    
    func stringFromDateWithSemantic(dateFormat: String = "yyyy-MM-dd", timeFormat: String = "HH:mm:ss", gmtFormat: String = "'(GMT 'ZZZZZ)") -> String {
        var defaultFormat = "\(dateFormat) \(timeFormat) \(gmtFormat)"
        if AppConstant.isLanguageRightToLeft {
            let rightToLeftDateFormat = dateFormat.isEmpty ? "" : "dd-MM-yyyy"
            defaultFormat = "\(gmtFormat) \(timeFormat) \(rightToLeftDateFormat)"
        }
        let formatter = DateFormatter.init()
        formatter.dateFormat = defaultFormat
        
        formatter.locale = Locale.init(identifier: "")
        return formatter.string(from: self)
    }
    
    func percentInBetweenDate(startDate: Date, endDate: Date) -> Double {
        let start = startDate.timeIntervalSince1970
        let end = endDate.timeIntervalSince1970
        let current = self.timeIntervalSince1970
        return (current - start) / (end - start)
    }
    
    var isSunday: Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let str = dateFormatter.string(from: self).uppercased()
        return str == "SUN"
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    
    var nextWeek: Date {
        return self.newDateAddedWithStep(7)
    }
    
    var prevWeek: Date {
        return self.newDateAddedWithStep(-7)
    }
    
    var previousMonth: Date {
        return addMonth(number: -1)
    }
    
    func nextMonth()-> Date {
        return addMonth(number: 1)
    }
    
    func addMonth(number: Int) -> Date{
        let cal = NSCalendar.current
        if let newDate = cal.date(byAdding: .month, value: number, to: self) {
            return newDate
        }
        return self
    }
    
    func startOfMonth() -> Date {
        let from = Calendar.current.startOfDay(for: self)
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: from))!.startOfDay
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!.endOfDay
    }
    
    func newDateAddedWithStep(_ step: Int) -> Date {
        var dayComponent    = DateComponents()
        dayComponent.day    = step
        let theCalendar     = Calendar.current
        let nextDate        = theCalendar.date(byAdding: dayComponent, to: self)
        return nextDate ?? self
    }
    
    func newTimeByMinutes(_ minutes: Int) -> Date {
        var dateComponent    = DateComponents()
        dateComponent.minute    = minutes
        let theCalendar     = Calendar.current
        let nextTime       = theCalendar.date(byAdding: dateComponent, to: self)
        return nextTime ?? self
    }
    
    func timeBetweenDate(toDate: Date) -> TimeInterval {
        let delta = self.timeIntervalSince(toDate)
        return abs(delta)
    }
    
}

extension TimeInterval {
    func stringFromTimeInterval() -> String {
        let time = NSInteger(self)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let day = time / 86400
        let hours = (time / 3600) - (day * 24)
        
        guard day > 0 || hours > 0 else {
            return "\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
        }
        
        guard day > 0 else {
            return "\(hours.string) \("timedelta_hours".Localizable()) \(minutes.string) \("timedelta_minutes".Localizable())"
        }
        return "\(day.string) \("timedelta_days".Localizable()) \(hours.string) \("timedelta_hours".Localizable())"
    }
    
    var days: Int {
        let time = NSInteger(self)
        return time / 86400
    }
}

extension Date {
    var localizedDescription: String {
        return description(with: .current)
    }
    
    var convertedDate:Date {

          let dateFormatter = DateFormatter()

          let dateFormat = "dd MMM yyyy"
          dateFormatter.dateFormat = dateFormat
          let formattedDate = dateFormatter.string(from: self)

          dateFormatter.locale = NSLocale.current
          dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")

          dateFormatter.dateFormat = dateFormat as String
          let sourceDate = dateFormatter.date(from: formattedDate as String)

          return sourceDate!
      }
}
