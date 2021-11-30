//
//  ChallengeFetchableUsecaseMock.swift
//  RoutinusTests
//
//  Created by 백지현 on 2021/11/30.
//

import XCTest
@testable import Routinus

class ChallengeFetchableUsecaseMock: ChallengeFetchableUsecase {
    func fetchRecommendChallenges(completion: @escaping ([Challenge]) -> Void) {
        let recommendChallenges = [Challenge(challengeID: "ChallengeID1",
                                             title: "TestTitle1",
                                             introduction: "introduction1",
                                             category: Challenge.Category.exercise,
                                             imageURL: "imageURL1",
                                             thumbnailImageURL: "thumbnailImageURL1",
                                             authExampleImageURL: "authExampleImageURL1",
                                             authExampleThumbnailImageURL: "authExampleThumbnailImageURL1",
                                             authMethod: "authMethod1",
                                             startDate: Date(dateString: "20211130"),
                                             endDate: Date(dateString: "20211206"),
                                             ownerID: "ownerID1",
                                             week: 1,
                                             participantCount: 10),
                                   Challenge(challengeID: "ChallengeID2",
                                             title: "TestTitle2",
                                             introduction: "introduction2",
                                             category: Challenge.Category.etc,
                                             imageURL: "imageURL2",
                                             thumbnailImageURL: "thumbnailImageURL2",
                                             authExampleImageURL: "authExampleImageURL2",
                                             authExampleThumbnailImageURL: "authExampleThumbnailImageURL2",
                                             authMethod: "authMethod2",
                                             startDate: Date(dateString: "20211130"),
                                             endDate: Date(dateString: "20211213"),
                                             ownerID: "ownerID2",
                                             week: 2,
                                             participantCount: 7)]

        completion(recommendChallenges)
    }

    func fetchLatestChallenges(completion: @escaping ([Challenge]) -> Void) {
        let latestChallenges = [Challenge(challengeID: "ChallengeID1",
                                          title: "TestTitle1",
                                          introduction: "introduction1",
                                          category: Challenge.Category.exercise,
                                          imageURL: "imageURL1",
                                          thumbnailImageURL: "thumbnailImageURL1",
                                          authExampleImageURL: "authExampleImageURL1",
                                          authExampleThumbnailImageURL: "authExampleThumbnailImageURL1",
                                          authMethod: "authMethod1",
                                          startDate: Date(dateString: "20211130"),
                                          endDate: Date(dateString: "20211206"),
                                          ownerID: "ownerID1",
                                          week: 1,
                                          participantCount: 10),
                                Challenge(challengeID: "ChallengeID2",
                                          title: "TestTitle2",
                                          introduction: "introduction2",
                                          category: Challenge.Category.etc,
                                          imageURL: "imageURL2",
                                          thumbnailImageURL: "thumbnailImageURL2",
                                          authExampleImageURL: "authExampleImageURL2",
                                          authExampleThumbnailImageURL: "authExampleThumbnailImageURL2",
                                          authMethod: "authMethod2",
                                          startDate: Date(dateString: "20211129"),
                                          endDate: Date(dateString: "20211212"),
                                          ownerID: "ownerID2",
                                          week: 2,
                                          participantCount: 7)]
        completion(latestChallenges)
    }

    func fetchSearchChallenges(keyword: String, completion: @escaping ([Challenge]) -> Void) {
        let challenges = [Challenge(challengeID: "ChallengeID1",
                                    title: "TestTitle1",
                                    introduction: "introduction1",
                                    category: Challenge.Category.exercise,
                                    imageURL: "imageURL1",
                                    thumbnailImageURL: "thumbnailImageURL1",
                                    authExampleImageURL: "authExampleImageURL1",
                                    authExampleThumbnailImageURL: "authExampleThumbnailImageURL1",
                                    authMethod: "authMethod1",
                                    startDate: Date(dateString: "20211130"),
                                    endDate: Date(dateString: "20211206"),
                                    ownerID: "ownerID1",
                                    week: 1,
                                    participantCount: 10),
                          Challenge(challengeID: "ChallengeID2",
                                    title: "TestTitle2",
                                    introduction: "introduction2",
                                    category: Challenge.Category.etc,
                                    imageURL: "imageURL2",
                                    thumbnailImageURL: "thumbnailImageURL2",
                                    authExampleImageURL: "authExampleImageURL2",
                                    authExampleThumbnailImageURL: "authExampleThumbnailImageURL2",
                                    authMethod: "authMethod2",
                                    startDate: Date(dateString: "20211129"),
                                    endDate: Date(dateString: "20211212"),
                                    ownerID: "ownerID2",
                                    week: 2,
                                    participantCount: 7)]
        let keywords = keyword.components(separatedBy: " ")
        var searchChallenges: Set<Challenge> = []

        keywords.forEach { keyword in
            challenges.filter { challenge in
                challenge.title.contains(keyword)
            }.forEach {
                searchChallenges.insert($0)
            }
        }
        completion(Array(searchChallenges))
    }

    func fetchSearchChallenges(category: Challenge.Category, completion: @escaping ([Challenge]) -> Void) {
        let challenges = [Challenge(challengeID: "ChallengeID1",
                                    title: "TestTitle1",
                                    introduction: "introduction1",
                                    category: Challenge.Category.exercise,
                                    imageURL: "imageURL1",
                                    thumbnailImageURL: "thumbnailImageURL1",
                                    authExampleImageURL: "authExampleImageURL1",
                                    authExampleThumbnailImageURL: "authExampleThumbnailImageURL1",
                                    authMethod: "authMethod1",
                                    startDate: Date(dateString: "20211130"),
                                    endDate: Date(dateString: "20211206"),
                                    ownerID: "ownerID1",
                                    week: 1,
                                    participantCount: 10),
                          Challenge(challengeID: "ChallengeID2",
                                    title: "TestTitle2",
                                    introduction: "introduction2",
                                    category: Challenge.Category.etc,
                                    imageURL: "imageURL2",
                                    thumbnailImageURL: "thumbnailImageURL2",
                                    authExampleImageURL: "authExampleImageURL2",
                                    authExampleThumbnailImageURL: "authExampleThumbnailImageURL2",
                                    authMethod: "authMethod2",
                                    startDate: Date(dateString: "20211129"),
                                    endDate: Date(dateString: "20211212"),
                                    ownerID: "ownerID2",
                                    week: 2,
                                    participantCount: 7)]

        completion(challenges.filter { $0.category == category })
    }

    func fetchCreatedChallengesByMe(completion: @escaping ([Challenge]) -> Void) {
        let challenges = [Challenge(challengeID: "ChallengeID1",
                                    title: "TestTitle1",
                                    introduction: "introduction1",
                                    category: Challenge.Category.exercise,
                                    imageURL: "imageURL1",
                                    thumbnailImageURL: "thumbnailImageURL1",
                                    authExampleImageURL: "authExampleImageURL1",
                                    authExampleThumbnailImageURL: "authExampleThumbnailImageURL1",
                                    authMethod: "authMethod1",
                                    startDate: Date(dateString: "20211130"),
                                    endDate: Date(dateString: "20211206"),
                                    ownerID: "ownerID1",
                                    week: 1,
                                    participantCount: 10),
                          Challenge(challengeID: "ChallengeID2",
                                    title: "TestTitle2",
                                    introduction: "introduction2",
                                    category: Challenge.Category.etc,
                                    imageURL: "imageURL2",
                                    thumbnailImageURL: "thumbnailImageURL2",
                                    authExampleImageURL: "authExampleImageURL2",
                                    authExampleThumbnailImageURL: "authExampleThumbnailImageURL2",
                                    authMethod: "authMethod2",
                                    startDate: Date(dateString: "20211129"),
                                    endDate: Date(dateString: "20211212"),
                                    ownerID: "ownerID2",
                                    week: 2,
                                    participantCount: 7)]
        completion(challenges.filter { $0.endDate ?? Date() >= Date() })
    }

    func fetchMyParticipatingChallenges(completion: @escaping ([Challenge]) -> Void) {
        let challenges = [Challenge(challengeID: "ChallengeID1",
                                    title: "TestTitle1",
                                    introduction: "introduction1",
                                    category: Challenge.Category.exercise,
                                    imageURL: "imageURL1",
                                    thumbnailImageURL: "thumbnailImageURL1",
                                    authExampleImageURL: "authExampleImageURL1",
                                    authExampleThumbnailImageURL: "authExampleThumbnailImageURL1",
                                    authMethod: "authMethod1",
                                    startDate: Date(dateString: "20211130"),
                                    endDate: Date(dateString: "20211206"),
                                    ownerID: "ownerID1",
                                    week: 1,
                                    participantCount: 10),
                          Challenge(challengeID: "ChallengeID2",
                                    title: "TestTitle2",
                                    introduction: "introduction2",
                                    category: Challenge.Category.etc,
                                    imageURL: "imageURL2",
                                    thumbnailImageURL: "thumbnailImageURL2",
                                    authExampleImageURL: "authExampleImageURL2",
                                    authExampleThumbnailImageURL: "authExampleThumbnailImageURL2",
                                    authMethod: "authMethod2",
                                    startDate: Date(dateString: "20211129"),
                                    endDate: Date(dateString: "20211212"),
                                    ownerID: "ownerID2",
                                    week: 2,
                                    participantCount: 7)]
        completion(challenges.filter { $0.endDate ?? Date() >= Date() })
    }

    func fetchMyEndedChallenges(completion: @escaping ([Challenge]) -> Void) {
        let challenges = [Challenge(challengeID: "ChallengeID1",
                                    title: "TestTitle1",
                                    introduction: "introduction1",
                                    category: Challenge.Category.exercise,
                                    imageURL: "imageURL1",
                                    thumbnailImageURL: "thumbnailImageURL1",
                                    authExampleImageURL: "authExampleImageURL1",
                                    authExampleThumbnailImageURL: "authExampleThumbnailImageURL1",
                                    authMethod: "authMethod1",
                                    startDate: Date(dateString: "20211120"),
                                    endDate: Date(dateString: "2021126"),
                                    ownerID: "ownerID1",
                                    week: 1,
                                    participantCount: 10),
                          Challenge(challengeID: "ChallengeID2",
                                    title: "TestTitle2",
                                    introduction: "introduction2",
                                    category: Challenge.Category.etc,
                                    imageURL: "imageURL2",
                                    thumbnailImageURL: "thumbnailImageURL2",
                                    authExampleImageURL: "authExampleImageURL2",
                                    authExampleThumbnailImageURL: "authExampleThumbnailImageURL2",
                                    authMethod: "authMethod2",
                                    startDate: Date(dateString: "20211201"),
                                    endDate: Date(dateString: "20211214"),
                                    ownerID: "ownerID2",
                                    week: 2,
                                    participantCount: 7)]
        completion(challenges.filter { $0.endDate ?? Date() < Date() })
    }

    func fetchEdittingChallenge(challengeID: String, completion: @escaping (Challenge?) -> Void) {
        let challenge = Challenge(challengeID: "ChallengeID1",
                                  title: "TestTitle1",
                                  introduction: "introduction1",
                                  category: Challenge.Category.exercise,
                                  imageURL: "imageURL1",
                                  thumbnailImageURL: "thumbnailImageURL1",
                                  authExampleImageURL: "authExampleImageURL1",
                                  authExampleThumbnailImageURL: "authExampleThumbnailImageURL1",
                                  authMethod: "authMethod1",
                                  startDate: Date(dateString: "20211120"),
                                  endDate: Date(dateString: "2021126"),
                                  ownerID: "ownerID1",
                                  week: 1,
                                  participantCount: 10)
        if challenge.challengeID == challengeID {
            completion(challenge)
        } else {
            completion(nil)
        }
    }

    func fetchChallenge(challengeID: String, completion: @escaping (Challenge) -> Void) {
        let challenge = Challenge(challengeID: "ChallengeID1",
                                  title: "TestTitle1",
                                  introduction: "introduction1",
                                  category: Challenge.Category.exercise,
                                  imageURL: "imageURL1",
                                  thumbnailImageURL: "thumbnailImageURL1",
                                  authExampleImageURL: "authExampleImageURL1",
                                  authExampleThumbnailImageURL: "authExampleThumbnailImageURL1",
                                  authMethod: "authMethod1",
                                  startDate: Date(dateString: "20211120"),
                                  endDate: Date(dateString: "2021126"),
                                  ownerID: "ownerID1",
                                  week: 1,
                                  participantCount: 10)
        completion(challenge)
    }
}
