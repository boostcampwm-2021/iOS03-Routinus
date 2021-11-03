//
//  TodayRoutineDTO.swift
//  RoutinusNetwork
//
//  Created by 유석환 on 2021/11/03.
//

import Foundation

public struct TodayRoutineDTO {
    var udid: String
    var challengeID: String
    var categoryID: String
    var title: String
    var authCount: Int
    var joinDate: String
    var endDate: String
    
    init() {
        self.udid = ""
        self.challengeID = ""
        self.categoryID = ""
        self.title = ""
        self.authCount = 0
        self.joinDate = ""
        self.endDate = ""
    }
}
