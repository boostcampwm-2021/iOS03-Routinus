//
//  TodayRoutineFetchUsecase.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/17.
//

import Foundation

protocol TodayRoutineFetchableUsecase {
    func fetchTodayRoutines(completion: @escaping ([TodayRoutine]) -> Void)
}

struct TodayRoutineFetchUsecase: TodayRoutineFetchableUsecase {
    var repository: TodayRoutineRepository

    init(repository: TodayRoutineRepository) {
        self.repository = repository
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
}
