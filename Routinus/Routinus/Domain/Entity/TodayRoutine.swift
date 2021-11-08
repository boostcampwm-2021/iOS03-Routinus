//
//  TodayRoutine.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/04.
//

import Foundation

import RoutinusNetwork

struct TodayRoutine {
    let challengeID: String
    let category: Category
    let title: String
    let authCount: Int
    let totalCount: Int
    
    init(challengeID: String, category: Category, title: String, authCount: Int, totalCount: Int) {
        self.challengeID = challengeID
        self.category = category
        self.title = title
        self.authCount = authCount
        self.totalCount = totalCount
    }

    init(todayRoutineDTO: TodayRoutineDTO) {
        self.challengeID = todayRoutineDTO.challengeID
        self.category = Category.category(by: todayRoutineDTO.categoryID)
        self.title = todayRoutineDTO.title
        self.authCount = todayRoutineDTO.authCount
        self.totalCount = Date.days(from: todayRoutineDTO.endDate, to: todayRoutineDTO.joinDate)
    }
}
