//
//  ChallengeCreateUsecase.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/09.
//

import Foundation

protocol ChallengeCreatableUsecase {
    func createChallenge(category: Challenge.Category, title: String, imageURL: String, authExampleImageURL: String, authMethod: String, week: Int, introduction: String)
    func isEmpty(title: String, imageURL: String, introduction: String, authMethod: String, authExampleImageURL: String) -> Bool
    func endDate(week: Int) -> Date?
    func saveImage(to directory: String, fileName: String, data: Data?) -> String
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
        guard let ownerID = RoutinusRepository.userID(),
              let endDate = endDate(week: week) else { return }
        let challengeID = createChallengeID()
        let challenge = Challenge(challengeID: challengeID,
                                  title: title,
                                  introduction: introduction,
                                  category: category,
                                  imageURL: imageURL,
                                  authExampleImageURL: authExampleImageURL,
                                  thumbnailImageURL: "",
                                  authMethod: authMethod,
                                  startDate: startDate(),
                                  endDate: endDate,
                                  ownerID: ownerID,
                                  week: week,
                                  participantCount: 1)

        repository.save(challenge: challenge, imageURL: imageURL, authImageURL: authExampleImageURL)
    }

    func isEmpty(title: String, imageURL: String, introduction: String, authMethod: String, authExampleImageURL: String) -> Bool {
        return title.isEmpty || imageURL.isEmpty || introduction.isEmpty || authMethod.isEmpty || authExampleImageURL.isEmpty
    }

    func saveImage(to directory: String, fileName: String, data: Data?) -> String {
        return repository.saveImage(to: directory, fileName: fileName, data: data)
    }
}
