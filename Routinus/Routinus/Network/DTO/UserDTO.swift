//
//  UserDTO.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/29.
//

import Foundation

struct UserDTO: Codable {
    let document: Fields<UserFields>?

    init() {
        self.document = nil
    }

    init(id: String,
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

struct UserFields: Codable {
    let id: StringField
    let name: StringField
    let grade: IntegerField
    let continuityDay: IntegerField
    let userImageCategoryID: StringField
    let lastAuthDay: StringField

    enum CodingKeys: String, CodingKey {
        case id, name, grade
        case continuityDay = "continuity_day"
        case userImageCategoryID = "user_image_category_id"
        case lastAuthDay = "last_auth_day"
    }
}
