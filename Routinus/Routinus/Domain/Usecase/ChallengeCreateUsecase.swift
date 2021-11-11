//
//  ChallengeCreateUsecase.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/09.
//

import Foundation

import RoutinusDatabase

protocol ChallengeCreatableUsecase {
    func createChallenge(category: Challenge.Category, title: String, imageURL: String, authExampleImageURL: String, authMethod: String, week: Int, introduction: String)
    func isEmpty(title: String, imageURL: String, introduction: String, authMethod: String, authExampleImageURL: String) -> Bool
}

struct ChallengeCreateUsecase: ChallengeCreatableUsecase {
    var repository: CreateRepository

    init(repository: CreateRepository) {
        self.repository = repository
    }

    private func createChallengeID() -> String {
        return UUID().uuidString
    }

    private func startDate() -> Date {
        return Date()
    }


    func endDate(week: Int) -> Date? {
        let now = Date()
        let calendar = Calendar.current
        let day = DateComponents(day: week*7)
        guard let endDate = calendar.date(byAdding: day, to: now) else { return nil }
        return endDate
    }

    func createChallenge(category: Challenge.Category, title: String, imageURL: String, authExampleImageURL: String, authMethod: String, week: Int, introduction: String) {
        guard let ownerID = repository.userID(), let endDate = endDate(week: week)?.toString() else { return }
        let challengeID = createChallengeID()
        let startDate = startDate().toString()
        let challenge = ChallengeDTO(id: challengeID, title: title, imageURL: imageURL,
                                     authExampleImageURL: authExampleImageURL,
                                     authMethod: authMethod, categoryID: category.id, week: week, decs: introduction,
                                     startDate: startDate, endDate: endDate, participantCount: 0, ownerID: ownerID, thumbnailImageURL: "")
        repository.save(challenge: challenge)
    }

    func isEmpty(title: String, imageURL: String, introduction: String, authMethod: String, authExampleImageURL: String) -> Bool {
        
        // TODO: 이미지 구현 전 테스트를 위한 return문
//        return title.isEmpty || imageURL.isEmpty || introduction.isEmpty || authMethod.isEmpty || authExampleImageURL.isEmpty
        return title.isEmpty || introduction.isEmpty || authMethod.isEmpty
    }
}
