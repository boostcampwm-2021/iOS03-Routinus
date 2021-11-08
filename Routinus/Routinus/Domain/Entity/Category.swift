//
//  Category.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/07.
//

import Foundation

enum Category {
    case exercise, selfDevelopment, lifeStyle, finance, hobby, etc

    var categoryColor: String {
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

    var categoryImage: String {
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
