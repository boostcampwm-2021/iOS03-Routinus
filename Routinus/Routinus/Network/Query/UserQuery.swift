//
//  UserQuery.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/29.
//

import Foundation

enum UserQuery {
    static func select(id: String) -> Data? {
        return """
        {
            "structuredQuery": {
                "from": { "collectionId": "user" },
                "where": {
                    "fieldFilter": {
                        "field": { "fieldPath": "id" },
                        "op": "EQUAL",
                        "value": { "stringValue": "\(id)" }
                    },
                },
                "limit": 1
            }
        }
        """.data(using: .utf8)
    }

    static func insert(id: String, name: String) -> Data? {
        return """
        {
            "fields": {
                "id": { "stringValue": "\(id)" },
                "name": { "stringValue": "\(name)" },
                "grade": { "integerValue": "0" },
                "continuity_day": { "integerValue": "0" },
                "user_image_category_id": { "stringValue": "0" },
                "last_auth_day": { "stringValue": "0" }
            }
        }
        """.data(using: .utf8)
    }

    static func update(document: UserFields) -> Data? {
        return """
        {
            "fields": {
                "continuity_day": { "integerValue": "\(document.continuityDay.integerValue)" },
                "last_auth_day": { "stringValue": "\(document.lastAuthDay.stringValue)" }
            }
        }
        """.data(using: .utf8)
    }

    static func updateUsername(document: UserFields) -> Data? {
        return """
        {
            "fields": {
                "name": { "stringValue": "\(document.name.stringValue)" },
            }
        }
        """.data(using: .utf8)
    }
}
