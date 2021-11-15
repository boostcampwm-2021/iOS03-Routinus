//
//  RoutinusRepository.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/08.
//

import Foundation

final class RoutinusRepository {
    static let userIDKey = "id"

    static func userID() -> String? {
        return UserDefaults.standard.string(forKey: RoutinusRepository.userIDKey)
    }
}
