//
//  CreateChallenge.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/09.
//

import Foundation

import RoutinusDatabase

struct CreateChallenge: Hashable {
    var id: String
    var title: String
    var imageURL: String
    var week: Int
    var description: String
    var authMethod: String
    var authImageURL: String
    

    init() {
        self.id = ""
        self.title = ""
        self.imageURL = ""
        self.week = 0
        self.description = ""
        self.authMethod = ""
        self.authImageURL = ""
    }

    func isEmpty() -> Bool {
        return title.isEmpty || imageURL.isEmpty || description.isEmpty || authMethod.isEmpty || authImageURL.isEmpty
    }
}
