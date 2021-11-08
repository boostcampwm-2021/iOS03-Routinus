//
//  HomeFetchUsecase.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/03.
//

import Combine
import Foundation

import RoutinusDatabase

protocol HomeFetchableUsecase {
    func fetchUserInfo(completion: @escaping (User) -> Void)
    func fetchTodayRoutine(completion: @escaping ([TodayRoutine]) -> Void)
    func fetchAcheivementInfo(yearMonth: String, completion: @escaping ([AchievementInfo]) -> Void)
}

struct HomeFetchUsecase: HomeFetchableUsecase {
    func fetchUserInfo(completion: @escaping (User) -> Void) {
        let id = "BD96E9E9-C0D7-46E6-BDC2-A18705B6E52C"

        Task {
            guard let userDTO = try? await RoutinusDatabase.user(of: id) else { return }
            let userInfo = User(userDTO: userDTO)
            completion(userInfo)
        }
    }

    func fetchTodayRoutine(completion: @escaping ([TodayRoutine]) -> Void) {
        let id = "BD96E9E9-C0D7-46E6-BDC2-A18705B6E52C"

        Task {
            guard let list = try? await RoutinusDatabase.routineList(of: id) else { return }
            let todayRoutine = list.map { TodayRoutine(todayRoutineDTO: $0) }
            completion(todayRoutine)
        }
    }

    func fetchAcheivementInfo(yearMonth: String, completion: @escaping ([AchievementInfo]) -> Void) {
        let id = "BD96E9E9-C0D7-46E6-BDC2-A18705B6E52C"

        Task {
            guard let list = try? await RoutinusDatabase.achievementInfo(of: id, in: yearMonth) else { return }
            let achievementInfo = list.map { AchievementInfo(achievementDTO: $0) }
            completion(achievementInfo)
        }
    }
}
