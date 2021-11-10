//
//  TodayRoutineDTO.swift
//  RoutinusDatabase
//
//  Created by 유석환 on 2021/11/08.
//

import Foundation

public struct TodayRoutineDTO {
    public var id: String
    public var challengeID: String
    public var categoryID: String
    public var title: String
    public var authCount: Int
    public var joinDate: String
    public var endDate: String
    
    public init() {
        self.id = ""
        self.challengeID = ""
        self.categoryID = ""
        self.title = ""
        self.authCount = 0
        self.joinDate = ""
        self.endDate = ""
    }

    public init(todayRoutine: [String: Any]?, challenge: [String: Any]?) {
        self.id = todayRoutine?["user_id"] as? String ?? ""
        self.challengeID = todayRoutine?["challenge_id"] as? String ?? ""
        self.authCount = todayRoutine?["auth_count"] as? Int ?? 0
        self.joinDate = todayRoutine?["join_date"] as? String ?? ""
        self.title = challenge?["title"] as? String ?? ""
        self.endDate = challenge?["end_date"] as? String ?? ""
        self.categoryID = challenge?["category_id"] as? String ?? ""
    }
}
