//
//  ChallengeCreateUsecase.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/09.
//

import Foundation

import RoutinusDatabase

protocol ChallengeCreatableUsecase {
    func createChallenge(challenge: Challenge)
}

struct ChallengeCreateUsecase: ChallengeCreatableUsecase {
    var repository: CreateRepository

    init(repository: CreateRepository) {
        self.repository = repository
    }

    private func createChallengeID() -> String {
        return UUID().uuidString
    }

    private func startDate() -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: now)
    }

    private func endDate(week: Int) -> String? {
        let now = Date()
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"

        let day = DateComponents(day: week*7)
        guard let endDate = calendar.date(byAdding: day, to: now) else { return nil }
        return dateFormatter.string(from: endDate)
    }


    func createChallenge(challenge: Challenge) {
        // TODO: categoryID 설정
        guard let ownerID = repository.userID(), let endDate = endDate(week: challenge.week) else { return }
        let challengeID = createChallengeID()
        let startDate = startDate()
        let challenge = ChallengeDTO(id: challengeID, title: challenge.title, imageURL: challenge.imageURL, authExampleImageURL: challenge.authExampleImageURL,
                                     authMethod: challenge.authMethod, categoryID: "1", week: challenge.week, decs: challenge.introduction,
                                     startDate: startDate, endDate: endDate, participantCount: 0, ownerID: ownerID, thumbnailImageURL: "")
        repository.save(challenge: challenge)
    }
}
