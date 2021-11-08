//
//  RoutinusRepository.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/08.
//

import Foundation

protocol HomeRepository {
    func isEmptyUserID() -> Bool
    func save(id: String, name: String)
}

class RoutinusRepository {
    // TODO: userIDKey를 LaunchRepository protocol로 이동 
    static let userIDKey = "id"
}

extension RoutinusRepository: HomeRepository {
    func isEmptyUserID() -> Bool {
        return UserDefaults.standard.string(forKey: RoutinusRepository.userIDKey) == nil
    }

    func save(id: String, name: String) {
        UserDefaults.standard.set(id, forKey: RoutinusRepository.userIDKey)
        // TODO: 파이어베이스에 id, name 저장 
    }
}



