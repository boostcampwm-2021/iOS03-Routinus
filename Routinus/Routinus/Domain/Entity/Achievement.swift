//
//  Achievement.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/03.
//

import Foundation

import RoutinusNetwork

struct Achievement {
    let yearMonth: String
    let day: String
    let achievementCount: Int
    let totalCount: Int

    init(yearMonth: String, day: String, achievementCount: Int, totalCount: Int) {
        self.yearMonth = yearMonth
        self.day = day
        self.achievementCount = achievementCount
        self.totalCount = totalCount
    }

    init(achievementDTO: AchievementDTO) {
        let document = achievementDTO.document?.fields

        self.yearMonth = document?.yearMonth.stringValue ?? ""
        self.day = document?.day.stringValue ?? ""
        self.achievementCount = Int(document?.achievementCount.integerValue ?? "") ?? 0
        self.totalCount = Int(document?.totalCount.integerValue ?? "") ?? 0
    }
}
