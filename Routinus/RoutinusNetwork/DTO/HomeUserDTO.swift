//
//  UserDTO.swift
//  RoutinusNetwork
//
//  Created by 유석환 on 2021/11/03.
//

import Foundation

public struct UserDTO {
    let udid: String
    let name: String
    let continuityDay: Int
    let userImageCategoryID: String
    let grade: Int
    
    init() {
        self.udid = ""
        self.name = ""
        self.continuityDay = 0
        self.userImageCategoryID = ""
        self.grade = 0
    }
    
    init(udid: String, name: String, continuityDay: Int, userImageCategoryID: String, grade: Int) {
        self.udid = udid
        self.name = name
        self.continuityDay = continuityDay
        self.userImageCategoryID = userImageCategoryID
        self.grade = grade
    }
}