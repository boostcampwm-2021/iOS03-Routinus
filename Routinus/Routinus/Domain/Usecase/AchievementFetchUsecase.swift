//
//  AchievementFetchUsecase.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/17.
//

import Foundation

protocol AchievementFetchableUsecase {
    func fetchAchievements(yearMonth: String,
                           completion: @escaping ([Achievement]) -> Void)
}

struct AchievementFetchUsecase: AchievementFetchableUsecase {
    var repository: AchievementRepository

    init(repository: AchievementRepository) {
        self.repository = repository
    }

    func fetchAchievements(yearMonth: String,
                           completion: @escaping ([Achievement]) -> Void) {
        guard let id = RoutinusRepository.userID() else { return }

        repository.fetchAchievements(by: id, in: yearMonth) { achievements in
            completion(achievements)
        }
    }
}
