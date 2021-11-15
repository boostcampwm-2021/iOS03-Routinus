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
    func fetchUser(completion: @escaping (User) -> Void)
    func fetchTodayRoutines(completion: @escaping ([TodayRoutine]) -> Void)
    func fetchAcheivements(yearMonth: String, completion: @escaping ([Achievement]) -> Void)
}

struct HomeFetchUsecase: HomeFetchableUsecase {
    var repository: HomeRepository

    init(repository: HomeRepository) {
        self.repository = repository
    }

    func fetchUser(completion: @escaping (User) -> Void) {
        // TODO: 테스트를 위한 임시 id(챌린지 추가 이후 guard 구문으로 교체)
        let id = "b555645c4804df095d82cb0b951a03b00d69cdeca5afc0a51201e1bfeae75e9b"
//        guard let id = RoutinusRepository.userID() else { return }

        Task {
            let user = await repository.fetchUser(by: id)
            completion(user)
        }
    }

    func fetchTodayRoutines(completion: @escaping ([TodayRoutine]) -> Void) {
        // TODO: 테스트를 위한 임시 id(챌린지 추가 이후 guard 구문으로 교체)
        let id = "b555645c4804df095d82cb0b951a03b00d69cdeca5afc0a51201e1bfeae75e9b"
//        guard let id = RoutinusRepository.userID() else { return }

        Task {
            let todayRoutines = await repository.fetchTodayRoutine(by: id)
            completion(todayRoutines)
        }
    }

    func fetchAcheivements(yearMonth: String, completion: @escaping ([Achievement]) -> Void) {
        // TODO: 테스트를 위한 임시 id(챌린지 추가 이후 guard 구문으로 교체)
        let id = "b555645c4804df095d82cb0b951a03b00d69cdeca5afc0a51201e1bfeae75e9b"
//        guard let id = RoutinusRepository.userID() else { return }

        Task {
            let acheivements = await repository.fetchAcheivements(by: id, in: yearMonth)
            completion(acheivements)
        }
    }
}
