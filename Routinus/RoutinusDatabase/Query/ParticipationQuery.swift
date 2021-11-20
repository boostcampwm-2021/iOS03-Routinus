//
//  ParticipationQuery.swift
//  RoutinusDatabase
//
//  Created by 유석환 on 2021/11/20.
//

import Foundation

internal enum ParticipationQuery {
    internal static func select(userID: String) -> Data? {
        return """
        {
            "structuredQuery": {
                "from": { "collectionId": "challenge_participation" },
                "where": {
                    "fieldFilter": {
                        "field": { "fieldPath": "user_id" },
                        "op": "EQUAL",
                        "value": { "stringValue": "\(userID)" }
                    },
                },
                "limit": 50
            }
        }
        """.data(using: .utf8)
    }

    internal static func select(userID: String,
                                challengeID: String) -> Data? {
        return """
        {
            "structuredQuery": {
                "from": { "collectionId": "challenge_participation" },
                "where": {
                    "compositeFilter": {
                        "filters": [
                            {
                                "fieldFilter": {
                                    "field": { "fieldPath": "user_id" },
                                    "op": "EQUAL",
                                    "value": { "stringValue": "\(userID)" }
                                }
                            },
                            {
                                "fieldFilter": {
                                    "field": { "fieldPath": "challenge_id" },
                                    "op": "EQUAL",
                                    "value": { "stringValue": "\(challengeID)" }
                                },
                            }
                        ],
                        "op": "AND"
                    }
                },
                "limit": 50
            }
        }
        """.data(using: .utf8)
    }

    internal static func insert(document: ParticipationField) -> Data? {
        return """
        {
            "fields": {
                "auth_count": { "integerValue": "0" },
                "challenge_id": { "stringValue": "\(document.challengeID.stringValue)" },
                "join_date": { "stringValue": "\(document.joinDate.stringValue)" },
                "user_id": { "stringValue": "\(document.userID.stringValue)" }
            }
        }
        """.data(using: .utf8)
    }

    internal static func update(document: ParticipationField) -> Data? {
        return """
        {
            "fields": {
                "auth_count": { "integerValue": "\(document.authCount.integerValue)" }
            }
        }
        """.data(using: .utf8)
    }
}
