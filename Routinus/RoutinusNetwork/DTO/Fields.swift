//
//  Fields.swift
//  RoutinusNetwork
//
//  Created by 유석환 on 2021/11/20.
//

public struct Fields<T: Codable>: Codable {
    public var name: String?
    public var fields: T
}

public struct StringField: Codable {
    public var stringValue: String
}

public struct IntegerField: Codable {
    public var integerValue: String
}
