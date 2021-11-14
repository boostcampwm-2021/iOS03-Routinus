//
//  ChallengeDTO.swift
//  RoutinusDatabase
//
//  Created by 박상우 on 2021/11/09.
//

import Foundation

public struct ChallengeDTO: Codable {
    public var document: ChallengeFields?

    public init() {
        self.document = nil
    }

    public init(id: String,
                title: String,
                authMethod: String,
                categoryID: String,
                week: Int,
                desc: String,
                startDate: String,
                endDate: String,
                participantCount: Int,
                ownerID: String) {
        let field = ChallengeField(authMethod: ChallengeField.AuthMethod(stringValue: authMethod),
                                   categoryID: ChallengeField.CategoryID(stringValue: categoryID),
                                   desc: ChallengeField.Desc(stringValue: desc),
                                   endDate: ChallengeField.EndDate(stringValue: endDate),
                                   id: ChallengeField.ID(stringValue: id),
                                   ownerID: ChallengeField.OwnerID(stringValue: ownerID),
                                   participantCount: ChallengeField.ParticipantCount(integerValue: "\(participantCount)"),
                                   startDate: ChallengeField.StartDate(stringValue: startDate),
                                   title: ChallengeField.Title(stringValue: title),
                                   week: ChallengeField.Week(integerValue: "\(week)"))
        self.document = ChallengeFields(fields: field)
    }
}

public struct ChallengeFields: Codable {
    public var fields: ChallengeField
}

public struct ChallengeField: Codable {
    public struct AuthMethod: Codable {
        public var stringValue: String
    }
    
    public struct CategoryID: Codable {
        public var stringValue: String
    }
    
    public struct Desc: Codable {
        public var stringValue: String
    }
    
    public struct EndDate: Codable {
        public var stringValue: String
    }
    
    public struct ID: Codable {
        public var stringValue: String
    }
    
    public struct OwnerID: Codable {
        public var stringValue: String
    }
    
    public struct ParticipantCount: Codable {
        public var integerValue: String
    }
    
    public struct StartDate: Codable {
        public var stringValue: String
    }
    
    public struct Title: Codable {
        public var stringValue: String
    }
    
    public struct Week: Codable {
        public var integerValue: String
    }
    
    public var authMethod: AuthMethod
    public var categoryID: CategoryID
    public var desc: Desc
    public var endDate: EndDate
    public var id: ID
    public var ownerID: OwnerID
    public var participantCount: ParticipantCount
    public var startDate: StartDate
    public var title: Title
    public var week: Week
    
    public enum CodingKeys: String, CodingKey {
        case desc, id, title, week
        case authMethod = "auth_method"
        case categoryID = "category_id"
        case endDate = "end_date"
        case ownerID = "owner_id"
        case participantCount = "participant_count"
        case startDate = "start_date"
    }
}
