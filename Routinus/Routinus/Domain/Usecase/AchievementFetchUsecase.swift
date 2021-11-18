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
        // TODO: 테스트를 위한 임시 id(챌린지 추가 이후 guard 구문으로 교체)
        let id = "b555645c4804df095d82cb0b951a03b00d69cdeca5afc0a51201e1bfeae75e9b"
//        guard let id = RoutinusRepository.userID() else { return }

        repository.fetchAcheivements(by: id, in: yearMonth) { achievements in
            completion(achievements)
        }
    }
}
