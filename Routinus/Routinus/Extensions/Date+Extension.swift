//
//  Date+Extension.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/04.
//

import Foundation

extension Date {
    static func days(from: String, to: String) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"

        guard let fromDate = formatter.date(from: from),
              let toDate = formatter.date(from: to) else { return -1 }
        
        let dateComponents = Calendar.current.dateComponents([.day], from: fromDate, to: toDate)
        guard let days = dateComponents.day else { return -1 }

        return abs(days) + 1
    }
}
