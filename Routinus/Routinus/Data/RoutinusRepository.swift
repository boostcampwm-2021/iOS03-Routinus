//
//  RoutinusRepository.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/08.
//

import Foundation

import RoutinusDatabase

protocol HomeRepository {
    func isEmptyUserID() -> Bool
    func save(id: String, name: String)
}

class RoutinusRepository {
    static let userIDKey = "id"
    
    func userID() -> String? {
        return UserDefaults.standard.string(forKey: RoutinusRepository.userIDKey)
    }
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
}
