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
    
    init(todayRoutineDTO: TodayRoutineDTO) {
        self.challengeID = todayRoutineDTO.challengeID
        self.category = Category.categoryByID(todayRoutineDTO.challengeID)
        self.title = todayRoutineDTO.title
        self.authCount = todayRoutineDTO.authCount
        self.totalCount = Date.days(from: todayRoutineDTO.endDate, to: todayRoutineDTO.joinDate)
    }
}
