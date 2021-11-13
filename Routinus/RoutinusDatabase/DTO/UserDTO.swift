//
//  UserDTO.swift
//  RoutinusDatabase
//
//  Created by 유석환 on 2021/11/08.
//

import Foundation

public struct UserDTO: Codable {
    public let document: UserFields?
    
    init() {
        self.document = nil
    }
}

public struct UserFields: Codable {
    public let fields: UserField
}

public struct UserField: Codable {
    public struct ID: Codable {
        public let stringValue: String
    }
    
    public struct Name: Codable {
        public let stringValue: String
    }
    
    public struct Grade: Codable {
        public let integerValue: String
    }
    
    public struct ContinuityDay: Codable {
        public let integerValue: String
    }
    
    public struct UserImageCategoryID: Codable {
        public let stringValue: String
    }
    
    public let id: ID
    public let name: Name
    public let grade: Grade
    public let continuityDay: ContinuityDay
    public let userImageCategoryID: UserImageCategoryID
    
    public enum CodingKeys: String, CodingKey {
        case id, name, grade
        case continuityDay = "continuity_day"
        case userImageCategoryID = "user_image_category_id"
    }
}
