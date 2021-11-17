//
//  TodayRoutineRepository.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/17.
//

import Foundation

import RoutinusDatabase

protocol TodayRoutineRepository {
    func fetchTodayRoutine(by id: String) async -> [TodayRoutine]
}

extension RoutinusRepository: TodayRoutineRepository {
    func fetchTodayRoutine(by id: String) async -> [TodayRoutine] {
        guard let list = try? await RoutinusDatabase.routines(of: id) else { return [] }
        return list.map { TodayRoutine(todayRoutineDTO: $0) }
    }
}
