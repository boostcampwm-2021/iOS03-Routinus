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
    
    public init(user: [String: Any]?) {
        self.id = user?["id"] as? String ?? ""
        self.name = user?["name"] as? String ?? ""
        self.continuityDay = user?["continuity_day"] as? Int ?? 0
        self.userImageCategoryID =  user?["user_image_category_id"] as? String ?? "0"
        self.grade = user?["grade"] as? Int ?? 0
    }
}
