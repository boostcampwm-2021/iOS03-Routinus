//
//  CreateChallenge.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/09.
//

import Foundation

import RoutinusDatabase

struct CreateChallenge: Hashable {
    var category: String
    var title: String
    var imageURL: String
    var week: Int
    var description: String
    var authMethod: String
    var authImageURL: String
    

    init() {
        self.category = ""
        self.title = ""
        self.imageURL = ""
        self.week = 0
        self.description = ""
        self.authMethod = ""
        self.authImageURL = ""
    }

    init(category: String, title: String, imageURL: String, week: Int, description: String, authMethod: String, authImageURL: String) {
        self.category = category
        self.title = title
        self.imageURL = imageURL
        self.week = week
        self.description = description
        self.authMethod = authMethod
        self.authImageURL = authImageURL
    }

    func isEmpty() -> Bool {
        return title.isEmpty || imageURL.isEmpty || description.isEmpty || authMethod.isEmpty || authImageURL.isEmpty
    }
}
