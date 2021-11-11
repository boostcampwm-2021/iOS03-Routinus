//
//  RoutinusDatabase.swift
//  RoutinusDatabase
//
//  Created by 유석환 on 2021/11/02.
//

import Foundation

import Firebase

public enum RoutinusDatabase {
    public static func configure() {
        FirebaseApp.configure()
    }

    public static func createUser(id: String, name: String) async throws {
        let db = Firestore.firestore()

        try await db.collection("user").document().setData([
            "id": id,
            "name": name,
            "continuity_day": 0,
            "grade": 0,
            "user_image_category_id": "0"
        ])
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
    }

    public static func user(of id: String) async throws -> UserDTO {
        let db = Firestore.firestore()

        let snapshot = try await db.collection("user")
            .whereField("id", isEqualTo: id)
            .getDocuments()
        let document = snapshot.documents.first?.data()

        return UserDTO(user: document)
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

    public static func newChallenge() async throws -> [ChallengeDTO] {
        let db = Firestore.firestore()

        let snapshot = try await db.collection("challenge")
            .order(by: "start_date")
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
}
