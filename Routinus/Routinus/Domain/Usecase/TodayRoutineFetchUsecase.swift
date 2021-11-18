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
        guard let id = RoutinusRepository.userID() else { return }

        repository.fetchTodayRoutine(by: id) { todayRoutines in
            completion(todayRoutines)
        }
    }
}
