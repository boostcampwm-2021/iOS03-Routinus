//
//  TodayRoutineRepository.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/17.
//

import Foundation

import RoutinusDatabase

protocol TodayRoutineRepository {
    func fetchTodayRoutine(by id: String,
                           completion: (([TodayRoutine]) -> Void)?)
}

extension RoutinusRepository: TodayRoutineRepository {
    func fetchTodayRoutine(by id: String,
                           completion: (([TodayRoutine]) -> Void)?) {
        RoutinusDatabase.routines(of: id) { list in
            completion?(list.map { TodayRoutine(todayRoutineDTO: $0) })
        }
    }
}
