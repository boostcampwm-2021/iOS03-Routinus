//
//  ChallengeCreateUsecase.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/09.
//

import Foundation

protocol ChallengeCreatableUsecase {
    func createChallenge(category: Challenge.Category,
                         title: String,
                         imageURL: String,
                         thumbnailImageURL: String,
                         authExampleImageURL: String,
                         authExampleThumbnailImageURL: String,
                         authMethod: String,
                         week: Int,
                         introduction: String)
    func isEmpty(title: String,
                 imageURL: String,
                 introduction: String,
                 authMethod: String,
                 authExampleImageURL: String) -> Bool
    func endDate(week: Int) -> Date?
}

struct ChallengeCreateUsecase: ChallengeCreatableUsecase {
    static let didCreateChallenge = Notification.Name("didCreateChallenge")

    var repository: ChallengeRepository

    init(repository: ChallengeRepository) {
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

    func createChallenge(category: Challenge.Category,
                         title: String,
                         imageURL: String,
                         thumbnailImageURL: String,
                         authExampleImageURL: String,
                         authExampleThumbnailImageURL: String,
                         authMethod: String,
                         week: Int,
                         introduction: String) {
        guard let ownerID = RoutinusRepository.userID(),
              let endDate = endDate(week: week) else { return }
        let challengeID = createChallengeID()
        let challenge = Challenge(challengeID: challengeID,
                                  title: title,
                                  introduction: introduction,
                                  category: category,
                                  imageURL: imageURL,
                                  thumbnailImageURL: thumbnailImageURL,
                                  authExampleImageURL: authExampleImageURL,
                                  authExampleThumbnailImageURL: authExampleThumbnailImageURL,
                                  authMethod: authMethod,
                                  startDate: startDate(),
                                  endDate: endDate,
                                  ownerID: ownerID,
                                  week: week,
                                  participantCount: 1)

        repository.insert(challenge: challenge,
                          imageURL: imageURL,
                          thumbnailImageURL: thumbnailImageURL,
                          authExampleImageURL: authExampleImageURL,
                          authExampleThumbnailImageURL: authExampleThumbnailImageURL) {
            NotificationCenter.default.post(name: ChallengeCreateUsecase.didCreateChallenge,
                                            object: nil)
        }
    }

    func isEmpty(title: String,
                 imageURL: String,
                 introduction: String,
                 authMethod: String,
                 authExampleImageURL: String) -> Bool {
        return title.isEmpty || imageURL.isEmpty || introduction.isEmpty || authMethod.isEmpty || authExampleImageURL.isEmpty
    }
}
