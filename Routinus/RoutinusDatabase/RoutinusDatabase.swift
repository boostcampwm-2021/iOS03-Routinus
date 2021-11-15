//
//  RoutinusDatabase.swift
//  RoutinusDatabase
//
//  Created by 유석환 on 2021/11/02.
//

import Foundation

public enum RoutinusDatabase {
    private enum HTTPMethod: String {
        case post = "POST"
    }

    private static let firestoreURL = "https://firestore.googleapis.com/v1/projects/boostcamp-ios03-routinus/databases/(default)/documents"
    private static let storageURL = "https://firebasestorage.googleapis.com/v0/b/boostcamp-ios03-routinus.appspot.com/o"

    public static func imageURL(id: String, fileName: String) async throws -> URL? {
        return URL(string: "\(storageURL)/\(id)%2F\(fileName).jpeg?alt=media")
    }

    public static func createUser(id: String, name: String) async throws {
        guard let url = URL(string: "\(firestoreURL)/user") else { return }
        var request = URLRequest(url: url)

        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = RoutinusQuery.createUserQuery(id: id, name: name)

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
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = RoutinusQuery.insertChallengeQuery(document: document)

        _ = try await URLSession.shared.data(for: request)
    }

    public static func insertChallengeParticipation(dto: ChallengeDTO) async throws {
        guard let url = URL(string: "\(firestoreURL)/challenge_participation"),
              let document = dto.document?.fields else { return }
        var request = URLRequest(url: url)

        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = RoutinusQuery.insertChallengeParticipationQuery(document: document)

        _ = try await URLSession.shared.data(for: request)
    }

    public static func uploadImage(id: String, fileName: String, imageURL: String) async throws {
        guard let url = URL(string: "\(storageURL)?uploadType=media&name=\(id)%2F\(fileName).jpeg"),
              let imageURL = URL(string: imageURL) else { return }
        var request = URLRequest(url: url)

        request.addValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = try? Data(contentsOf: imageURL)

        _ = try await URLSession.shared.data(for: request)
    }

    public static func user(of id: String) async throws -> UserDTO {
        guard let url = URL(string: "\(firestoreURL):runQuery") else { return UserDTO() }
        var request = URLRequest(url: url)

        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = RoutinusQuery.userQuery(of: id)

        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode([UserDTO].self, from: data).first ?? UserDTO()
    }

    public static func routines(of id: String) async throws -> [TodayRoutineDTO] {
        guard let url = URL(string: "\(firestoreURL):runQuery") else { return [] }
        var request = URLRequest(url: url)

        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = RoutinusQuery.routinesQuery(userID: id)

        var (data, _) = try await URLSession.shared.data(for: request)
        let participations = try JSONDecoder().decode([ParticipationDTO].self, from: data)
        var todayRoutines = [TodayRoutineDTO]()

        for participation in participations {
            guard let challengeID = participation.document?.fields.challengeID.stringValue else { continue }

            request.httpBody = RoutinusQuery.routinesQuery(challengeID: challengeID)

            (data, _) = try await URLSession.shared.data(for: request)
            let challenge = try JSONDecoder().decode([ChallengeDTO].self, from: data).first ?? ChallengeDTO()
            let todayRoutine = TodayRoutineDTO(participation: participation, challenge: challenge)
            todayRoutines.append(todayRoutine)
        }

        return todayRoutines
    }

    public static func achievement(of id: String, in yearMonth: String) async throws -> [AchievementDTO] {
        guard let url = URL(string: "\(firestoreURL):runQuery") else { return [] }
        var request = URLRequest(url: url)

        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = RoutinusQuery.achievementQuery(of: id, in: yearMonth)

        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode([AchievementDTO].self, from: data)
    }

    public static func allChallenges() async throws -> [ChallengeDTO] {
        guard let url = URL(string: "\(firestoreURL):runQuery") else { return [] }
        var request = URLRequest(url: url)

        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = RoutinusQuery.allChallengesQuery()

        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode([ChallengeDTO].self, from: data)
    }

    public static func newChallenge() async throws -> [ChallengeDTO] {
        guard let url = URL(string: "\(firestoreURL):runQuery") else { return [] }
        var request = URLRequest(url: url)

        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = RoutinusQuery.newChallengeQuery()

        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode([ChallengeDTO].self, from: data)
    }

    public static func recommendChallenge() async throws -> [ChallengeDTO] {
        guard let url = URL(string: "\(firestoreURL):runQuery") else { return [] }
        var request = URLRequest(url: url)

        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = RoutinusQuery.recommendChallengeQuery()

        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode([ChallengeDTO].self, from: data)
    }

    public static func searchChallenges(by categoryID: String) async throws -> [ChallengeDTO] {
        guard let url = URL(string: "\(firestoreURL):runQuery") else { return [] }
        var request = URLRequest(url: url)

        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = RoutinusQuery.searchChallenges(by: categoryID)

        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode([ChallengeDTO].self, from: data)
    }

    public static func challenge(ownerId: String, challengeId: String) async throws -> ChallengeDTO? {
        let db = Firestore.firestore()

//        let snapshot = try await db.collection("challenge")
//            .whereField("owner_id", isEqualTo: ownerId)
//            .whereField("id", isEqualTo: challengeId)
//            .getDocuments()
//        guard let document = snapshot.documents.first?.data() else { return nil }
//        return ChallengeDTO(challenge: document)
        return nil
    }

    public static func updateChallenge(challenge: ChallengeDTO) {
        let db = Firestore.firestore()

//        db.collection("challenge")
//            .whereField("id", isEqualTo: challenge.id)
//            .whereField("owner_id", isEqualTo: challenge.ownerID)
//            .getDocuments { (result, error) in
//                guard let result = result, error == nil else { return }
//                guard let document = result.documents.first else { return }
//                db.collection("challenge").document(document.documentID).setData([
//                    "auth_example_image_url": challenge.authExampleImageURL,
//                    "auth_method": challenge.authMethod,
//                    "category_id": challenge.categoryID,
//                    "desc": challenge.desc,
//                    "end_date": challenge.endDate,
//                    "id": challenge.id,
//                    "image_url": challenge.imageURL,
//                    "owner_id": challenge.ownerID,
//                    "participant_count": challenge.participantCount,
//                    "start_date": challenge.startDate,
//                    "thumbnail_image_url": challenge.thumbnailImageURL,
//                    "title": challenge.title,
//                    "week": challenge.week
//                ], merge: true)
//            }
//
//        let storage = Storage.storage().reference()
//
//        let imageReference = storage.child("\(challenge.id)/image.jpeg")
//        guard let imageURL = URL(string: challenge.imageURL) else { return }
//        imageReference.putFile(from: imageURL, metadata: nil)
//
//        let authExampleImageReference = storage.child("\(challenge.id)/auth.jpeg")
//        guard let authExampleImageURL = URL(string: challenge.authExampleImageURL) else { return }
//        authExampleImageReference.putFile(from: authExampleImageURL, metadata: nil)
    }
}
