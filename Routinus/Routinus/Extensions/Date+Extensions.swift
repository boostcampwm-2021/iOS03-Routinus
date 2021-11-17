//
//  Date+Extensions.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/04.
//

import Foundation

extension Date {
    init(dateString: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        guard let date = formatter.date(from: dateString) else {
            self.init(timeInterval: 0, since: Date())
            return
        }
        self.init(timeInterval: 0, since: date)
    }

    init(hourMinuteString: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HHmm"
        guard let date = formatter.date(from: hourMinuteString) else {
            self.init(timeInterval: 0, since: Date())
            return
        }
        self.init(timeInterval: 0, since: date)
    }

    public var year: Int {
        return Calendar.current.component(.year, from: self)
    }

    public var month: Int {
        return Calendar.current.component(.month, from: self)
    }

    public var day: Int {
        return Calendar.current.component(.day, from: self)
    }

    static func days(from: String, to: String) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"

        guard let fromDate = formatter.date(from: from),
              let toDate = formatter.date(from: to) else { return -1 }

        let dateComponents = Calendar.current.dateComponents([.day], from: fromDate, to: toDate)
        guard let days = dateComponents.day else { return -1 }

        return abs(days) + 1
    }

    static func currentYearMonth() -> String {
        let dateComponents = Calendar.current.dateComponents([.year, .month], from: Date.now)

        guard let year = dateComponents.year,
              let month = dateComponents.month else { return "" }

        return "\(year)\(month)"
    }

    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: self)
    }

    func toStringHourMinute() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HHmm"
        return dateFormatter.string(from: self)
    }

    func toExtendedString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd(E)"
        return dateFormatter.string(from: self)
    }
}
