//
//  UserQuery.swift
//  RoutinusDatabase
//
//  Created by 유석환 on 2021/11/20.
//

import Foundation

internal enum UserQuery {
    internal static func select(id: String) -> Data? {
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

    internal static func insert(id: String,
                                name: String) -> Data? {
        return """
        {
            "fields": {
                "id": { "stringValue": "\(id)" },
                "name": { "stringValue": "\(name)" },
                "grade": { "integerValue": "0" },
                "continuity_day": { "integerValue": "0" },
                "user_image_category_id": { "stringValue": "0" }
            }
        }
        """.data(using: .utf8)
    }
}
