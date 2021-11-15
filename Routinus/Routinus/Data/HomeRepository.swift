//
//  HomeRepository.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/09.
//

import Foundation

import RoutinusDatabase

protocol HomeRepository {
    func isEmptyUserID() -> Bool
    func save(id: String, name: String)
    func fetchUserInfo(by id: String) async -> User
    func fetchTodayRoutine(by id: String) async -> [TodayRoutine]
    func fetchAcheivementInfo(by id: String, in yearMonth: String) async -> [Achievement]
}

extension RoutinusRepository: HomeRepository {
    func isEmptyUserID() -> Bool {
        return UserDefaults.standard.string(forKey: RoutinusRepository.userIDKey) == nil
    }

    func save(id: String, name: String) {
        UserDefaults.standard.set(id, forKey: RoutinusRepository.userIDKey)

        Task {
            try await RoutinusDatabase.createUser(id: id, name: name)
        }
    }

    func fetchUserInfo(by id: String) async -> User {
        guard let userDTO = try? await RoutinusDatabase.user(of: id) else { return User() }
        return User(userDTO: userDTO)
    }

    func fetchTodayRoutine(by id: String) async -> [TodayRoutine] {
        guard let list = try? await RoutinusDatabase.routines(of: id) else { return [] }
        return list.map { TodayRoutine(todayRoutineDTO: $0) }
    }

    func fetchAcheivementInfo(by id: String, in yearMonth: String) async -> [Achievement] {
        guard let list = try? await RoutinusDatabase.achievement(of: id, in: yearMonth) else { return [] }
        return list.map { Achievement(achievementDTO: $0) }
    }
}
