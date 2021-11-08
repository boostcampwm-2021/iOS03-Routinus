//
//  UserDTO.swift
//  RoutinusDatabase
//
//  Created by 유석환 on 2021/11/08.
//

import Foundation

public struct UserDTO {
    public var id: String
    public var name: String
    public var continuityDay: Int
    public var userImageCategoryID: String
    public var grade: Int
    
    public init() {
        self.id = ""
        self.name = ""
        self.continuityDay = 0
        self.userImageCategoryID = ""
        self.grade = 0
    }
    
    public init(id: String, name: String, continuityDay: Int, userImageCategoryID: String, grade: Int) {
        self.id = id
        self.name = name
        self.continuityDay = continuityDay
        self.userImageCategoryID = userImageCategoryID
        self.grade = grade
    }
}
