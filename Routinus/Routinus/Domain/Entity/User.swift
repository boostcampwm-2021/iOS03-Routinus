//
//  User.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/03.
//

import Foundation

import RoutinusDatabase

struct User {
    var name: String
    var continuityDay: Int
    var userImageCategoryID: String
    var grade: Int
    
    init() {
        self.name = ""
        self.continuityDay = 0
        self.userImageCategoryID = ""
        self.grade = 0
    }

    init(name: String, continuityDay: Int, userImageCategoryID: String, grade: Int) {
        self.name = name
        self.continuityDay = continuityDay
        self.userImageCategoryID = userImageCategoryID
        self.grade = grade
    }

    init(userDTO: UserDTO) {
        self.name = userDTO.name
        self.continuityDay = userDTO.continuityDay
        self.userImageCategoryID = userDTO.userImageCategoryID
        self.grade = userDTO.grade
    }
}
