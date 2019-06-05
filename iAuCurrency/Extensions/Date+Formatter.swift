//
//  Date+Formatter.swift
//  iAuCurrency
//
//  Created by Reza Farahani on 5/6/19.
//  Copyright © 2019 Farahani Consulting. All rights reserved.
//

import Foundation

extension String {
    
    var asISO8601Date: Date? {
        return DateFormatter.iso8601.date(from: self)
    }
}

extension TimeZone {
    static let utc = TimeZone(abbreviation: "UTC")!
}

extension DateFormatter {
    
    static let time: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = .utc
        return dateFormatter
    }()
    
    static let yearMonthDay: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = .utc
        return dateFormatter
    }()
    
    static let dayMonthYear: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        dateFormatter.timeZone = .utc
        return dateFormatter
    }()
    
    static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()
    
    static let utcDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        formatter.timeZone = .utc
        return formatter
    }()
    
    static let condensed: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        dateFormatter.timeZone = .utc
        return dateFormatter
    }()
    
    static let standard: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = .utc
        return dateFormatter
    }()
    
    static let utcDateTimeCondensed: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM HH:mmX"
        dateFormatter.timeZone = .utc
        return dateFormatter
    }()
    
    static let utcDateCondensed: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        dateFormatter.timeZone = .utc
        return dateFormatter
    }()
    
    static let localDay: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE - d MMM yyyy z"
        return dateFormatter
    }()
}

extension Date {
    
    var dateFormatted: String {
        return DateFormatter.standard.string(from: self)
    }
    
    var dayFormatted: String {
        return DateFormatter.yearMonthDay.string(from: self)
    }
    
    var condensedDateFormatted: String {
        return DateFormatter.condensed.string(from: self)
    }
    
    var timeFormatted: String {
        return DateFormatter.time.string(from: self)
    }
    
    var iso8601Formatted: String {
        return DateFormatter.iso8601.string(from: self)
    }
    
    var utcDayFormatted: String {
        return DateFormatter.utcDay.string(from: self)
    }
    
    var utcDateTimeCondensedFormatted: String {
        return DateFormatter.utcDateTimeCondensed.string(from: self)
    }
    
    var utcDateCondensedFormatted: String {
        return DateFormatter.utcDateCondensed.string(from: self)
    }
    
    var localDay: String {
        return DateFormatter.localDay.string(from: self)
    }
}
