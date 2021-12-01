//
//  Fields.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/29.
//

import Foundation

struct Fields<T: Codable>: Codable {
    var name: String?
    var fields: T
    var createTime: String?
}

struct StringField: Codable {
    var stringValue: String
}

struct IntegerField: Codable {
    var integerValue: String
}
