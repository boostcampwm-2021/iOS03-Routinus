//
//  HomeFetchUsecase.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/03.
//

import Foundation
import RoutinusNetwork
import Combine

protocol HomeFetchableUsecase {
    func fetchUserInfo()
    func fetchTodayRoutine()
    func fetchAcheivementInfo(yearMonth: String)

    var userInfoSignal: PassthroughSubject<UserInfo, Never> { get }
    var todayRoutineSignal: PassthroughSubject<[TodayRoutine], Never> { get }
    var achievementSignal: PassthroughSubject<[AchievementInfo], Never> { get }
}

struct HomeFetchUsecase: HomeFetchableUsecase {
    var userInfoSignal = PassthroughSubject<UserInfo, Never>()
    var todayRoutineSignal = PassthroughSubject<[TodayRoutine], Never>()
    var achievementSignal = PassthroughSubject<[AchievementInfo], Never>()

    func fetchUserInfo() {
        let udid = "BD96E9E9-C0D7-46E6-BDC2-A18705B6E52C"

        Task {
            guard let userDTO = try? await RoutinusNetwork.user(of: udid) else { return }
            let userInfo = UserInfo(userDTO: userDTO)
            userInfoSignal.send(userInfo)
        }
    }

    func fetchTodayRoutine() {
        let udid = "BD96E9E9-C0D7-46E6-BDC2-A18705B6E52C"

        Task {
            guard let list = try? await RoutinusNetwork.routineList(of: udid) else { return }
            let todayRoutine = list.map { TodayRoutine(todayRoutineDTO: $0) }
            todayRoutineSignal.send(todayRoutine)
        }
    }

    func fetchAcheivementInfo(yearMonth: String) {
        let udid = "BD96E9E9-C0D7-46E6-BDC2-A18705B6E52C"

        Task {
            guard let list = try? await RoutinusNetwork.achievementInfo(of: udid, in: yearMonth) else { return }
            let achievementInfo = list.map { AchievementInfo(achievementDTO: $0) }
            achievementSignal.send(achievementInfo)
        }
    }
}
