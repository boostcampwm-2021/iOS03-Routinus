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
    
    public static func user(of id: String) async throws -> UserDTO {
        let db = Firestore.firestore()
        let snapshot = try await db.collection("user")
            .whereField("id", isEqualTo: id)
            .getDocuments()
        let document = snapshot.documents.first?.data()
        
        return UserDTO(
            id: id,
            name: document?["name"] as? String ?? "",
            continuityDay: document?["continuity_day"] as? Int ?? 0,
            userImageCategoryID: document?["user_image_category_id"] as? String ?? "0",
            grade: document?["grade"] as? Int ?? 0
        )
    }
    
    public static func routineList(of id: String) async throws -> [TodayRoutineDTO] {
        let db = Firestore.firestore()
        let participationSnapshot = try await db.collection("challenge_participation")
            .whereField("user_id", isEqualTo: id)
            .getDocuments()
        
        var todayRoutines = [TodayRoutineDTO]()
        
        for document in participationSnapshot.documents {
            var todayRoutineDTO = TodayRoutineDTO()
            
            todayRoutineDTO.id = id
            todayRoutineDTO.challengeID = document["challenge_id"] as? String ?? ""
            todayRoutineDTO.authCount = document["auth_count"] as? Int ?? 0
            todayRoutineDTO.joinDate = document["join_date"] as? String ?? ""
            
            let challengeSnapshot = try await db.collection("challenge")
                .whereField("id", isEqualTo: todayRoutineDTO.challengeID)
                .getDocuments()
            let challenge = challengeSnapshot.documents.first?.data()
            
            todayRoutineDTO.title = challenge?["title"] as? String ?? ""
            todayRoutineDTO.endDate = challenge?["end_date"] as? String ?? ""
            todayRoutineDTO.categoryID = challenge?["category_id"] as? String ?? ""
            
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
        
        var achievementInfoList = [AchievementInfoDTO]()
        
        for document in snapshot.documents {
            let achievementInfoDTO = AchievementInfoDTO(
                userID: id,
                yearMonth: document["year_month"] as? String ?? "",
                day: document["day"] as? String ?? "",
                achievementCount: document["achievement_count"] as? Int ?? 0,
                totalCount: document["total_count"] as? Int ?? 0
            )
            
            achievementInfoList.append(achievementInfoDTO)
        }
        
        return achievementInfoList
    }
    
    public static func newChallenge() async throws -> [ChallengeDTO] {
        let db = Firestore.firestore()
        let snapshot = try await db.collection("challenge")
            .order(by: "start_date")
            .getDocuments()

        var challengeList = [ChallengeDTO]()

        for document in snapshot.documents {
            let challengeDTO = ChallengeDTO(
                id: document["id"] as? String ?? "",
                title: document["title"] as? String ?? "",
                imageURL: document["image_url"] as? String ?? "",
                authExampleImageURL: document["auth_example_image_url"] as? String ?? "",
                authMethod: document["auth_method"] as? String ?? "",
                categoryID: document["category_id"] as? String ?? "",
                week: document["week"] as? Int ?? 0,
                decs: document["desc"] as? String ?? "",
                startDate: document["start_date"] as? String ?? "",
                endDate: document["end_date"] as? String ?? "",
                participantCount: document["participant_count"] as? Int ?? 0,
                ownerID: document["owner_id"] as? String ?? "",
                thumbnailImageURL: document["thumbnail_image_url"] as? String ?? ""
            )
            
            challengeList.append(challengeDTO)
        }
        
        return challengeList
    }
    
    public static func recommendChallenge() async throws -> [ChallengeDTO] {
        let db = Firestore.firestore()
        let snapshot = try await db.collection("challenge")
            .order(by: "participant_count", descending: true)
            .limit(to: 5)
            .getDocuments()

        var challengeList = [ChallengeDTO]()

        for document in snapshot.documents {
            let challengeDTO = ChallengeDTO(
                id: document["id"] as? String ?? "",
                title: document["title"] as? String ?? "",
                imageURL: document["image_url"] as? String ?? "",
                authExampleImageURL: document["auth_example_image_url"] as? String ?? "",
                authMethod: document["auth_method"] as? String ?? "",
                categoryID: document["category_id"] as? String ?? "",
                week: document["week"] as? Int ?? 0,
                decs: document["desc"] as? String ?? "",
                startDate: document["start_date"] as? String ?? "",
                endDate: document["end_date"] as? String ?? "",
                participantCount: document["participant_count"] as? Int ?? 0,
                ownerID: document["owner_id"] as? String ?? "",
                thumbnailImageURL: document["thumbnail_image_url"] as? String ?? ""
            )

            challengeList.append(challengeDTO)
        }

        return challengeList
    }

    public static func searchChallengesBy(keyword: String) async throws -> [ChallengeDTO] {
        let db = Firestore.firestore()
        let snapshot = try await db.collection("challenge")
            .whereField("title", isEqualTo: [keyword])
            .order(by: "participant_count", descending: true)
            .getDocuments()

        var challengeList = [ChallengeDTO]()

        for document in snapshot.documents {
            let challengeDTO = ChallengeDTO(
                id: document["id"] as? String ?? "",
                title: document["title"] as? String ?? "",
                imageURL: document["image_url"] as? String ?? "",
                authExampleImageURL: document["auth_example_image_url"] as? String ?? "",
                authMethod: document["auth_method"] as? String ?? "",
                categoryID: document["category_id"] as? String ?? "",
                week: document["week"] as? Int ?? 0,
                decs: document["desc"] as? String ?? "",
                startDate: document["start_date"] as? String ?? "",
                endDate: document["end_date"] as? String ?? "",
                participantCount: document["participant_count"] as? Int ?? 0,
                ownerID: document["owner_id"] as? String ?? "",
                thumbnailImageURL: document["thumbnail_image_url"] as? String ?? ""
            )
            challengeList.append(challengeDTO)
        }
        return challengeList
    }
    
    public static func searchChallengesBy(categoryID: String) async throws -> [ChallengeDTO] {
        let db = Firestore.firestore()
        let snapshot = try await db.collection("challenge")
            .whereField("category_id", isEqualTo: categoryID)
            .order(by: "participant_count", descending: true)
            .getDocuments()

        var challengeList = [ChallengeDTO]()

        for document in snapshot.documents {
            let challengeDTO = ChallengeDTO(
                id: document["id"] as? String ?? "",
                title: document["title"] as? String ?? "",
                imageURL: document["image_url"] as? String ?? "",
                authExampleImageURL: document["auth_example_image_url"] as? String ?? "",
                authMethod: document["auth_method"] as? String ?? "",
                categoryID: document["category_id"] as? String ?? "",
                week: document["week"] as? Int ?? 0,
                decs: document["desc"] as? String ?? "",
                startDate: document["start_date"] as? String ?? "",
                endDate: document["end_date"] as? String ?? "",
                participantCount: document["participant_count"] as? Int ?? 0,
                ownerID: document["owner_id"] as? String ?? "",
                thumbnailImageURL: document["thumbnail_image_url"] as? String ?? ""
            )
            challengeList.append(challengeDTO)
        }
        return challengeList
    }
}
