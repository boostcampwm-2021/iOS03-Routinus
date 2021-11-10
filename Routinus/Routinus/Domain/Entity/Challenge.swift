//
//  Challenge.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/08.
//

import Foundation

import RoutinusDatabase

struct Challenge: Hashable {
    enum Category: CaseIterable {
        case exercise, selfDevelopment, lifeStyle, finance, hobby, etc

        var title: String {
            switch self {
            case .exercise:
                return "운동"
            case .selfDevelopment:
                return "자기 계발"
            case .lifeStyle:
                return "생활 습관"
            case .finance:
                return "돈 관리"
            case .hobby:
                return "취미"
            case .etc:
                return "기타"
            }
        }
        
        var color: String {
            switch self {
            case .exercise:
                return "ExerciseColor"
            case .selfDevelopment:
                return "SelfDevelopmentColor"
            case .lifeStyle:
                return "LifeStyleColor"
            case .finance:
                return "FinanceColor"
            case .hobby:
                return "HobbyColor"
            case .etc:
                return "ETCColor"
            }
        }

        var symbol: String {
            switch self {
            case .exercise:
                return "dumbbell"
            case .selfDevelopment:
                return "pencil"
            case .lifeStyle:
                return "check.calendar"
            case .finance:
                return "creditcard.and.123"
            case .hobby:
                return "play.circle"
            case .etc:
                return "guitars"
            }
        }
        
        static func category(by id: String) -> Self {
            switch id {
            case "0":
                return exercise
            case "1":
                return selfDevelopment
            case "2":
                return lifeStyle
            case "3":
                return finance
            case "4":
                return hobby
            default:
                return etc
            }
        }
    }

    var challengeID: String
    var title: String
    var introduction: String
    var category: Category
    var imageURL: String
    var authExampleImageURL: String
    var thumbnailImageURL: String
    var authMethod: String
    var startDate: Date?
    var endDate: Date?
    var ownerID: String
    var week: Int
    var participantCount: Int

    init(challengeID: String, title: String, introduction: String, category: Category, imageURL: String,
         authExampleImageURL: String, thumbnailImageURL: String, authMethod: String, startDate: Date?,
         endDate: Date?, ownerID: String, week: Int, participantCount: Int) {
        self.challengeID = challengeID
        self.title = title
        self.introduction = introduction
        self.category = category
        self.imageURL = imageURL
        self.authExampleImageURL = authExampleImageURL
        self.thumbnailImageURL = thumbnailImageURL
        self.authMethod = authMethod
        self.startDate = startDate
        self.endDate = endDate
        self.ownerID = ownerID
        self.week = week
        self.participantCount = participantCount
    }

    init(challengeDTO: ChallengeDTO) {
        self.challengeID = challengeDTO.id
        self.title = challengeDTO.title
        self.introduction = challengeDTO.desc
        self.category = Category.category(by: challengeDTO.categoryID)
        self.imageURL = challengeDTO.imageURL
        self.authExampleImageURL = challengeDTO.authExampleImageURL
        self.thumbnailImageURL = challengeDTO.thumbnailImageURL
        self.authMethod = challengeDTO.authMethod
        self.startDate = Date.toDate(challengeDTO.startDate)
        self.endDate = Date.toDate(challengeDTO.endDate)
        self.ownerID = challengeDTO.ownerID
        self.week = challengeDTO.week
        self.participantCount = challengeDTO.participantCount
    }

    func isEmpty() -> Bool {
        return title.isEmpty || imageURL.isEmpty || introduction.isEmpty || authMethod.isEmpty || authExampleImageURL.isEmpty
    }
}
