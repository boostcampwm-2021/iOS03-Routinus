//
//  RoutinusDatabase.swift
//  RoutinusDatabase
//
//  Created by 유석환 on 2021/11/02.
//

import Foundation

import Firebase

public enum RoutinusDatabase {
    private static let firestoreURL = "https://firestore.googleapis.com/v1/projects/boostcamp-ios03-routinus/databases/(default)/documents"
    private static let storageURL = "https://firebasestorage.googleapis.com/v0/b/boostcamp-ios03-routinus.appspot.com/o"

    public static func configure() {
        FirebaseApp.configure()
    }

    public static func imageURL(id: String, fileName: String) async throws -> URL? {
        return URL(string: "\(storageURL)/\(id)%2F\(fileName).jpeg?alt=media")
    }

    public static func createUser(id: String, name: String) async throws {
        guard let url = URL(string: "\(firestoreURL)/user") else { return }
        var request = URLRequest(url: url)

        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = """
        {
            "fields": {
                "id": { "stringValue": "\(id)" },
                "name": { "stringValue": "\(name)" },
                "grade": { "integerValue": "0" },
                "continuity_day": { "integerValue": "0" },
                "user_image_category_id": { "stringValue": "0" }
            }
        }
        """.data(using: .utf8)

        _ = try await URLSession.shared.data(for: request)
    }

    public static func createChallenge(challenge: ChallengeDTO, imageURL: String, authImageURL: String) async throws {
        Task {
            try await insertChallenge(dto: challenge)
            try await insertChallengeParticipation(dto: challenge)
            try await uploadImage(id: challenge.document?.fields.id.stringValue ?? "",
                                  fileName: "image",
                                  imageURL: imageURL)
            try await uploadImage(id: challenge.document?.fields.id.stringValue ?? "",
                                  fileName: "auth",
                                  imageURL: authImageURL)
        }
    }

    public static func insertChallenge(dto: ChallengeDTO) async throws {
        guard let url = URL(string: "\(firestoreURL)/challenge"),
              let document = dto.document?.fields else { return }
        var request = URLRequest(url: url)

        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = """
        {
            "fields": {
                "auth_method": { "stringValue": "\(document.authMethod.stringValue)" },
                "category_id": { "stringValue": "\(document.categoryID.stringValue)" },
                "desc": { "stringValue": "\(document.desc.stringValue)" },
                "end_date": { "stringValue": "\(document.endDate.stringValue)" },
                "id": { "stringValue": "\(document.id.stringValue)" },
                "owner_id": { "stringValue": "\(document.ownerID.stringValue)" },
                "participant_count": { "integerValue": "\(document.participantCount.integerValue)" },
                "start_date": { "stringValue": "\(document.startDate.stringValue)" },
                "title": { "stringValue": "\(document.title.stringValue)" },
                "week": { "integerValue": "\(document.week.integerValue)" }
            }
        }
        """.data(using: .utf8)

        _ = try await URLSession.shared.data(for: request)
    }

    public static func insertChallengeParticipation(dto: ChallengeDTO) async throws {
        guard let url = URL(string: "\(firestoreURL)/challenge_participation"),
              let document = dto.document?.fields else { return }
        var request = URLRequest(url: url)

        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = """
        {
            "fields": {
                "auth_count": { "integerValue": "0" },
                "challenge_id": { "stringValue": "\(document.id.stringValue)" },
                "join_date": { "stringValue": "\(document.startDate.stringValue)" },
                "user_id": { "stringValue": "\(document.ownerID.stringValue)" }
            }
        }
        """.data(using: .utf8)

        _ = try await URLSession.shared.data(for: request)
    }

    public static func uploadImage(id: String, fileName: String, imageURL: String) async throws {
        guard let url = URL(string: "\(storageURL)?uploadType=media&name=\(id)%2F\(fileName).jpeg"),
              let imageURL = URL(string: imageURL) else { return }
        var request = URLRequest(url: url)

        request.addValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = try? Data(contentsOf: imageURL)

        _ = try await URLSession.shared.data(for: request)
    }

    public static func user(of id: String) async throws -> UserDTO {
        guard let url = URL(string: "\(firestoreURL):runQuery") else { return UserDTO() }
        var request = URLRequest(url: url)

        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = """
        {
            "structuredQuery": {
                "from": { "collectionId": "user" },
                "where": {
                    "fieldFilter": {
                        "field": { "fieldPath": "id" },
                        "op": "EQUAL",
                        "value": { "stringValue": "\(id)" }
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

    public static func achievement(of id: String, in yearMonth: String) async throws -> [AchievementDTO] {
        guard let url = URL(string: "\(firestoreURL):runQuery") else { return [] }
        var request = URLRequest(url: url)

        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = """
        {
            "structuredQuery": {
                "from": { "collectionId": "achievement" },
                "where": {
                    "compositeFilter": {
                        "filters": [
                            {
                                "fieldFilter": {
                                    "field": { "fieldPath": "user_id" },
                                    "op": "EQUAL",
                                    "value": { "stringValue": "\(id)" }
                                }
                            },
                            {
                                "fieldFilter": {
                                    "field": { "fieldPath": "year_month" },
                                    "op": "EQUAL",
                                    "value": { "stringValue": "\(yearMonth)" }
                                },
                            }
                        ],
                        "op": "AND"
                    }
                }
            }
        }
        """.data(using: .utf8)

        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode([AchievementDTO].self, from: data)
    }

    public static func allChallenges() async throws -> [ChallengeDTO] {
//        let db = Firestore.firestore()
//        let snapshot = try await db.collection("challenge")
//            .order(by: "participant_count")
//            .limit(to: 50)
//            .getDocuments()
//
//        var challenges = [ChallengeDTO]()
//
//        for document in snapshot.documents {
//            let challengeDTO = ChallengeDTO(challenge: document.data())
//            challenges.append(challengeDTO)
//        }
//
//        return challenges
        return []
    }

    public static func newChallenge() async throws -> [ChallengeDTO] {
//        let db = Firestore.firestore()
//
//        let snapshot = try await db.collection("challenge")
//            .order(by: "start_date", descending: true)
//            .limit(to: 10)
//            .getDocuments()
//
//        var challenges = [ChallengeDTO]()
//
//        for document in snapshot.documents {
//            let challengeDTO = ChallengeDTO(challenge: document.data())
//            challenges.append(challengeDTO)
//        }
//
//        return challenges
        return []
    }

    public static func recommendChallenge() async throws -> [ChallengeDTO] {
        guard let url = URL(string: "\(firestoreURL):runQuery") else { return [] }
        var request = URLRequest(url: url)

        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = """
        {
            "structuredQuery": {
                "from": {
                    "collectionId": "challenge",
                },
                "orderBy": [
                    {
                        "field": { "fieldPath": "participant_count" },
                        "direction": "DESCENDING"
                    },
                ],
                "limit": 5
            }
        }
        """.data(using: .utf8)

        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode([ChallengeDTO].self, from: data)
    }

    public static func searchChallengesBy(categoryID: String) async throws -> [ChallengeDTO] {
//        let db = Firestore.firestore()
//        let snapshot = try await db.collection("challenge")
//            .whereField("category_id", isEqualTo: categoryID)
//            .order(by: "participant_count", descending: true)
//            .getDocuments()
//
//        var challenges = [ChallengeDTO]()
//
//        for document in snapshot.documents {
//            let challengeDTO = ChallengeDTO(challenge: document.data())
//            challenges.append(challengeDTO)
//        }
//
//        return challenges
        return []
    }
}
