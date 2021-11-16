//
//  Calendar.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/16.
//

import Foundation

struct Day {
    let date: Date
    let number: String
    let isSelected: Bool
    var achievementRate: Double
    let isWithinDisplayedMonth: Bool
}

struct MonthMetadata {
    let numberOfDays: Int
    let firstDay: Date
    let firstDayWeekday: Int
}
