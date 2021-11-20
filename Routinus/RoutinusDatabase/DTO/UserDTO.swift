//
//  UserDTO.swift
//  RoutinusDatabase
//
//  Created by 유석환 on 2021/11/08.
//

import Foundation

public struct UserDTO: Codable {
    public let document: Fields<UserFields>?

    init() {
        self.document = nil
    }
}

public struct UserFields: Codable {
    public let id: StringField
    public let name: StringField
    public let grade: IntegerField
    public let continuityDay: IntegerField
    public let userImageCategoryID: StringField

    public enum CodingKeys: String, CodingKey {
        case id, name, grade
        case continuityDay = "continuity_day"
        case userImageCategoryID = "user_image_category_id"
    }
}
