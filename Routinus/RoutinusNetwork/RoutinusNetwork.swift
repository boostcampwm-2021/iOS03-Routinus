//
//  RoutinusNetwork.swift
//  RoutinusNetwork
//
//  Created by 유석환 on 2021/11/02.
//

import Firebase
import Foundation

public enum RoutinusNetwork {
    public static func configure() {
        FirebaseApp.configure()
    }
    
    public static func user(of udid: String,
                            completion: @escaping (Result<UserDTO, Error>) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("user")
            .whereField("udid", isEqualTo: udid)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                }
                
                if let document = snapshot?.documents.first?.data() {
                    let user = UserDTO(udid: udid,
                                       name: document["name"] as? String ?? "",
                                       continuityDay: document["continuity_day"] as? Int ?? 0,
                                       userImageCategoryID: document["user_image_category_id"] as? String ?? "0",
                                       grade: document["grade"] as? Int ?? 0)
                    completion(.success(user))
                } else {
                    completion(.success(UserDTO()))
                }
            }
    }
    
    public static func routineList(of udid: String) async throws -> [TodayRoutineDTO] {
        let db = Firestore.firestore()
        let participationSnapshot = try await db.collection("challenge_participation")
            .whereField("user_udid", isEqualTo: udid)
            .getDocuments()
        
        var todayRoutines = [TodayRoutineDTO]()
        
        for document in participationSnapshot.documents {
            var todayRoutineDTO = TodayRoutineDTO()
            
            todayRoutineDTO.udid = udid
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
    
    public static func achievementInfo(of udid: String, in yearMonth: String) async throws -> [AchievementInfoDTO] {
        let db = Firestore.firestore()
        let snapshot = try await db.collection("achievement_info")
            .whereField("user_udid", isEqualTo: udid)
            .whereField("yearMonth", isEqualTo: yearMonth)
            .getDocuments()
        
        var achievementInfoList = [AchievementInfoDTO]()
        
        for document in snapshot.documents {
            let achievementInfoDTO = AchievementInfoDTO(
                userUDID: udid,
                day: document["day"] as? Int ?? 0,
                achievementCount: document["achievement_count"] as? Int ?? 0,
                totalCount: document["total_count"] as? Int ?? 0
            )
            
            achievementInfoList.append(achievementInfoDTO)
        }
        
        return achievementInfoList
    }
}
