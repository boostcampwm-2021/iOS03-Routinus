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
    var repository: HomeRepository

    init(repository: HomeRepository) {
        self.repository = repository
    }

    func fetchUserInfo(completion: @escaping (User) -> Void) {
        // TODO: 테스트를 위한 임시 id(챌린지 추가 이후 guard 구문으로 교체)
        let id = "b555645c4804df095d82cb0b951a03b00d69cdeca5afc0a51201e1bfeae75e9b"
//        guard let id = RoutinusRepository.userID() else { return }

        Task {
            let userInfo = await repository.fetchUserInfo(by: id)
            completion(userInfo)
        }
    }

    func fetchTodayRoutine(completion: @escaping ([TodayRoutine]) -> Void) {
        // TODO: 테스트를 위한 임시 id(챌린지 추가 이후 guard 구문으로 교체)
        let id = "b555645c4804df095d82cb0b951a03b00d69cdeca5afc0a51201e1bfeae75e9b"
//        guard let id = RoutinusRepository.userID() else { return }

        Task {
            let todayRoutineList = await repository.fetchTodayRoutine(by: id)
            completion(todayRoutineList)
        }
    }

    func fetchAcheivementInfo(yearMonth: String, completion: @escaping ([AchievementInfo]) -> Void) {
        // TODO: 테스트를 위한 임시 id(챌린지 추가 이후 guard 구문으로 교체)
        let id = "b555645c4804df095d82cb0b951a03b00d69cdeca5afc0a51201e1bfeae75e9b"
//        guard let id = RoutinusRepository.userID() else { return }

        Task {
            let acheivementInfoList = await repository.fetchAcheivementInfo(by: id, in: yearMonth)
            completion(acheivementInfoList)
        }
    }
}
