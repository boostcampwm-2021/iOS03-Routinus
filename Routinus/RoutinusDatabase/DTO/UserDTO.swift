//
//  UserDTO.swift
//  RoutinusDatabase
//
//  Created by 유석환 on 2021/11/08.
//

import Foundation

public struct UserDTO {
    public var udid: String
    public var name: String
    public var continuityDay: Int
    public var userImageCategoryID: String
    public var grade: Int
    
    public init() {
        self.udid = ""
        self.name = ""
        self.continuityDay = 0
        self.userImageCategoryID = ""
        self.grade = 0
    }
    
    public init(udid: String, name: String, continuityDay: Int, userImageCategoryID: String, grade: Int) {
        self.udid = udid
        self.name = name
        self.continuityDay = continuityDay
        self.userImageCategoryID = userImageCategoryID
        self.grade = grade
    }
}
