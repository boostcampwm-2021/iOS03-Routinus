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
        case exercise, study, read, lifeStyle, finance, hobby, emotionManage, etc

        var title: String {
            switch self {
            case .exercise:
                return "운동"
            case .study:
                return "공부"
            case .read:
                return "독서"
            case .lifeStyle:
                return "생활 습관"
            case .finance:
                return "돈 관리"
            case .hobby:
                return "취미"
            case .emotionManage:
                return "감정 관리"
            case .etc:
                return "기타"
            }
        }

        var color: String {
            switch self {
            case .exercise:
                return "ExerciseColor"
            case .study:
                return "StudyColor"
            case .read:
                return "ReadColor"
            case .lifeStyle:
                return "LifeStyleColor"
            case .finance:
                return "FinanceColor"
            case .hobby:
                return "HobbyColor"
            case .emotionManage:
                return "EmotionManageColor"
            case .etc:
                return "ETCColor"
            }
        }

        var symbol: String {
            switch self {
            case .exercise:
                return "dumbbell"
            case .study:
                return "highlighter"
            case .read:
                return "text.book.closed"
            case .lifeStyle:
                return "check.calendar"
            case .finance:
                return "creditcard.and.123"
            case .hobby:
                return "play.circle"
            case .emotionManage:
                return "heart.circle"
            case .etc:
                return "guitars"
            }
        }

        var id: String {
            switch self {
            case .exercise:
                return "0"
            case .study:
                return "1"
            case .read:
                return "2"
            case .lifeStyle:
                return "3"
            case .finance:
                return "4"
            case .hobby:
                return "5"
            case .emotionManage:
                return "6"
            case .etc:
                return "7"
            }
        }

        static func category(by id: String) -> Self {
            switch id {
            case "0":
                return exercise
            case "1":
                return study
            case "2":
                return read
            case "3":
                return lifeStyle
            case "4":
                return finance
            case "5":
                return hobby
            case "6":
                return emotionManage
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
    var thumbnailImageURL: String
    var authExampleImageURL: String
    var authExampleThumbnailImageURL: String
    var authMethod: String
    var startDate: Date?
    var endDate: Date?
    var ownerID: String
    var week: Int
    var participantCount: Int

    init(challengeID: String,
         title: String,
         introduction: String,
         category: Category,
         imageURL: String,
         thumbnailImageURL: String,
         authExampleImageURL: String,
         authExampleThumbnailImageURL: String,
         authMethod: String,
         startDate: Date?,
         endDate: Date?,
         ownerID: String,
         week: Int,
         participantCount: Int) {
        self.challengeID = challengeID
        self.title = title
        self.introduction = introduction
        self.category = category
        self.imageURL = imageURL
        self.thumbnailImageURL = thumbnailImageURL
        self.authExampleImageURL = authExampleImageURL
        self.authExampleThumbnailImageURL = authExampleThumbnailImageURL
        self.authMethod = authMethod
        self.startDate = startDate
        self.endDate = endDate
        self.ownerID = ownerID
        self.week = week
        self.participantCount = participantCount
    }

    init(challengeDTO: ChallengeDTO) {
        let document = challengeDTO.document?.fields

        self.challengeID = document?.id.stringValue ?? ""
        self.title = document?.title.stringValue ?? ""
        self.introduction = document?.desc.stringValue ?? ""
        self.category = Category.category(by: document?.categoryID.stringValue ?? "")
        self.imageURL = ""
        self.thumbnailImageURL = ""
        self.authExampleImageURL = ""
        self.authExampleThumbnailImageURL = ""
        self.authMethod = document?.authMethod.stringValue ?? ""
        self.startDate = Date.toDate(document?.startDate.stringValue ?? "")
        self.endDate = Date.toDate(document?.endDate.stringValue ?? "")
        self.ownerID = document?.ownerID.stringValue ?? ""
        self.week = Int(document?.week.integerValue ?? "") ?? 0
        self.participantCount = Int(document?.participantCount.integerValue ?? "") ?? 0
    }
}
