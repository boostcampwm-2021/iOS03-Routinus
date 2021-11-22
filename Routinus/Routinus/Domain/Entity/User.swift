//
//  User.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/03.
//

import Foundation

import RoutinusDatabase

struct User {
    var id: String
    var name: String
    var continuityDay: Int
    var userImageCategoryID: String
    var grade: Int
    var lastAuthDay: String

    init() {
        self.id = ""
        self.name = ""
        self.continuityDay = 0
        self.userImageCategoryID = ""
        self.grade = 0
        self.lastAuthDay = ""
    }

    init(id: String,
         name: String,
         continuityDay: Int,
         userImageCategoryID: String,
         grade: Int,
         lastAuthDay: String) {
        self.id = id
        self.name = name
        self.continuityDay = continuityDay
        self.userImageCategoryID = userImageCategoryID
        self.grade = grade
        self.lastAuthDay = lastAuthDay
    }

    init(userDTO: UserDTO) {
        let document = userDTO.document?.fields

        self.id = document?.id.stringValue ?? ""
        self.name = document?.name.stringValue ?? ""
        self.continuityDay = Int(document?.continuityDay.integerValue ?? "") ?? 0
        self.userImageCategoryID = document?.userImageCategoryID.stringValue ?? ""
        self.grade = Int(document?.grade.integerValue ?? "") ?? 0
        self.lastAuthDay = document?.lastAuthDay.stringValue ?? ""
    }
}
