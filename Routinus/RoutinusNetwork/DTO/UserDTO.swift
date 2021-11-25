//
//  UserDTO.swift
//  RoutinusNetwork
//
//  Created by 유석환 on 2021/11/08.
//

import Foundation

public struct UserDTO: Codable {
    public let document: Fields<UserFields>?

    init() {
        self.document = nil
    }

    public init(fields: Fields<UserFields>) {
        self.document = fields
    }

    public init(id: String,
                name: String,
                grade: Int,
                continuityDay: Int,
                userImageCategoryID: String,
                lastAuthDay: String) {
        let field = UserFields(id: StringField(stringValue: id),
                               name: StringField(stringValue: name),
                               grade: IntegerField(integerValue: "\(grade)"),
                               continuityDay: IntegerField(integerValue: "\(continuityDay)"),
                               userImageCategoryID: StringField(stringValue: userImageCategoryID),
                               lastAuthDay: StringField(stringValue: lastAuthDay))
        self.document = Fields(name: nil, fields: field)
    }

    var documentID: String? {
        return self.document?.name?.components(separatedBy: "/").last
    }
}

public struct UserFields: Codable {
    public let id: StringField
    public let name: StringField
    public let grade: IntegerField
    public let continuityDay: IntegerField
    public let userImageCategoryID: StringField
    public let lastAuthDay: StringField

    public enum CodingKeys: String, CodingKey {
        case id, name, grade
        case continuityDay = "continuity_day"
        case userImageCategoryID = "user_image_category_id"
        case lastAuthDay = "last_auth_day"
    }
}
