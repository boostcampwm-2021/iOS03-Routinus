//
//  RoutinusDatabase.swift
//  RoutinusDatabase
//
//  Created by 유석환 on 2021/11/02.
//

import Foundation

import Firebase
import FirebaseStorage

public enum RoutinusDatabase {
    private static let firestoreURL = "https://firestore.googleapis.com/v1/projects/boostcamp-ios03-routinus/databases/(default)/documents"
    private static let storageURL = "https://firebasestorage.googleapis.com/v0/b/boostcamp-ios03-routinus.appspot.com/o"

    public static func configure() {
        FirebaseApp.configure()
    }

    public static func imageURL(id: String, fileName: String) async throws -> URL? {
        guard let url = URL(string: "\(storageURL)/\(id)%2F\(fileName).jpeg?alt=media") else { return nil }
        return url
    }

    public static func createUser(id: String, name: String) async throws {
        guard let url = URL(string: "\(firestoreURL)/user") else { return }
        var request = URLRequest(url: url)

        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = """
        {
            "fields": {
                "id": {
                    "stringValue": "\(id)"
                },
                "name": {
                    "stringValue": "\(name)"
                },
                "grade": {
                    "integerValue": "0"
                },
                "continuity_day": {
                    "integerValue": "0"
                },
                "user_image_category_id": {
                    "stringValue": "0"
                }
            }
        }
        """.data(using: .utf8)

        _ = try await URLSession.shared.data(for: request)
    }

    public static func createChallenge(challenge: ChallengeDTO) async throws {
        let db = Firestore.firestore()

        try await db.collection("challenge").document().setData([
            "auth_example_image_url": challenge.authExampleImageURL,
            "auth_method": challenge.authMethod,
            "category_id": challenge.categoryID,
            "desc": challenge.desc,
            "end_date": challenge.endDate,
            "id": challenge.id,
            "image_url": challenge.imageURL,
            "owner_id": challenge.ownerID,
            "participant_count": challenge.participantCount,
            "start_date": challenge.startDate,
            "thumbnail_image_url": challenge.thumbnailImageURL,
            "title": challenge.title,
            "week": challenge.week
        ])

        try await db.collection("challenge_participation").document().setData([
            "auth_count": 0,
            "challenge_id": challenge.id,
            "join_date": challenge.startDate,
            "user_id": challenge.ownerID
        ])

        let storage = Storage.storage().reference()

        let imageReference = storage.child("\(challenge.id)/image.jpeg")
        guard let imageURL = URL(string: challenge.imageURL) else { return }
        imageReference.putFile(from: imageURL, metadata: nil)

        let authExampleImageReference = storage.child("\(challenge.id)/auth.jpeg")
        guard let authExampleImageURL = URL(string: challenge.authExampleImageURL) else { return }
        authExampleImageReference.putFile(from: authExampleImageURL, metadata: nil)
    }

    public static func user(of id: String) async throws -> UserDTO {
        guard let url = URL(string: "\(firestoreURL):runQuery") else { return UserDTO() }
        var request = URLRequest(url: url)

        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = """
        {
            "structuredQuery": {
                "select": {
                    "fields": [
                        { "fieldPath": "id" },
                        { "fieldPath": "name" },
                        { "fieldPath": "grade" },
                        { "fieldPath": "continuity_day" },
                        { "fieldPath": "user_image_category_id" },
                    ]
                },
                "from": {
                    "collectionId": "user",
                },
                "where": {
                    "fieldFilter": {
                        "field": {
                            "fieldPath": "id"
                        },
                        "op": "EQUAL",
                        "value": {
                            "stringValue": "\(id)"
                        }
                    },
                },
            }
        }
        """.data(using: .utf8)

        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode([UserDTO].self, from: data).first ?? UserDTO()
    }

    public static func routineList(of id: String) async throws -> [TodayRoutineDTO] {
        let db = Firestore.firestore()

        let participationSnapshot = try await db.collection("challenge_participation")
            .whereField("user_id", isEqualTo: id)
            .getDocuments()

        var todayRoutines = [TodayRoutineDTO]()

        for document in participationSnapshot.documents {
            let challengeID = document["challenge_id"] as? String ?? ""
            let challengeSnapshot = try await db.collection("challenge")
                .whereField("id", isEqualTo: challengeID)
                .getDocuments()
            let challenge = challengeSnapshot.documents.first?.data()
            let todayRoutine = document.data()
            let todayRoutineDTO = TodayRoutineDTO(todayRoutine: todayRoutine, challenge: challenge)
            todayRoutines.append(todayRoutineDTO)
        }

        return todayRoutines
    }

    public static func achievementInfo(of id: String, in yearMonth: String) async throws -> [AchievementInfoDTO] {
        let db = Firestore.firestore()

        let snapshot = try await db.collection("achievement_info")
            .whereField("user_id", isEqualTo: id)
            .whereField("year_month", isEqualTo: yearMonth)
            .getDocuments()

        var achievements = [AchievementInfoDTO]()

        for document in snapshot.documents {
            let achievementDTO = AchievementInfoDTO(achievement: document.data())
            achievements.append(achievementDTO)
        }

        return achievements
    }

    public static func allChallenges() async throws -> [ChallengeDTO] {
        let db = Firestore.firestore()
        let snapshot = try await db.collection("challenge")
            .order(by: "participant_count")
            .limit(to: 50)
            .getDocuments()

        var challenges = [ChallengeDTO]()

        for document in snapshot.documents {
            let challengeDTO = ChallengeDTO(challenge: document.data())
            challenges.append(challengeDTO)
        }

        return challenges
    }

    public static func newChallenge() async throws -> [ChallengeDTO] {
        let db = Firestore.firestore()

        let snapshot = try await db.collection("challenge")
            .order(by: "start_date", descending: true)
            .limit(to: 10)
            .getDocuments()

        var challenges = [ChallengeDTO]()

        for document in snapshot.documents {
            let challengeDTO = ChallengeDTO(challenge: document.data())
            challenges.append(challengeDTO)
        }
  
        return challenges
    }

    public static func recommendChallenge() async throws -> [ChallengeDTO] {
        let db = Firestore.firestore()

        let snapshot = try await db.collection("challenge")
            .order(by: "participant_count", descending: true)
            .limit(to: 5)
            .getDocuments()

        var challenges = [ChallengeDTO]()

        for document in snapshot.documents {
            let challengeDTO = ChallengeDTO(challenge: document.data())
            challenges.append(challengeDTO)
        }

        return challenges
    }

    public static func searchChallengesBy(categoryID: String) async throws -> [ChallengeDTO] {
        let db = Firestore.firestore()
        let snapshot = try await db.collection("challenge")
            .whereField("category_id", isEqualTo: categoryID)
            .order(by: "participant_count", descending: true)
            .getDocuments()

        var challenges = [ChallengeDTO]()

        for document in snapshot.documents {
            let challengeDTO = ChallengeDTO(challenge: document.data())
            challenges.append(challengeDTO)
        }

        return challenges
    }
}
