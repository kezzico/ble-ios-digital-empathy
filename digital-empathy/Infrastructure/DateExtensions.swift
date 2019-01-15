//
//  DateExtensions.swift
//  FashionCritic
//
//  Created by Lee Irvine on 1/3/18.
//  Copyright © 2018 kezzi.co. All rights reserved.
//

import UIKit

extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
}
extension Date {
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }

    var short: String {
        let components = Calendar.current.dateComponents([.minute,.hour,.day,.month,.year], from: self, to: Date())
        if components.year ?? 0 > 0 {
            return "\(components.year!)y"
        }

        if components.month ?? 0 > 0 {
            return "\(components.month!)mo"
        }

        if components.day ?? 0 > 0 {
            return "\(components.day!)d"
        }

        if components.hour ?? 0 > 0 {
            return "\(components.hour!)h"
        }

        if components.minute ?? 0 > 0 {
            return "\(components.minute!)mi"
        }

        return "now"
    }

    var hoursFromNow: Int {
        let components = Calendar.current.dateComponents([.hour], from: self, to: Date())
        return components.hour ?? 0
    }

    var daysFromNow: Int {
        let components = Calendar.current.dateComponents([.day], from: self, to: Date())
        return components.day ?? 0
    }

    var hoursUntilNow: Int {
        let components = Calendar.current.dateComponents([.hour], from: Date(), to: self)
        return components.hour ?? 0
    }

    var daysUntilNow: Int {
        let components = Calendar.current.dateComponents([.day], from: Date(), to: self)
        return components.day ?? 0
    }

}

extension String {
    var dateFromISO8601: Date? {
        return Formatter.iso8601.date(from: self)
    }
}

