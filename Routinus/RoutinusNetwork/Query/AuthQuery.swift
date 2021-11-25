//
//  AuthQuery.swift
//  RoutinusNetwork
//
//  Created by 유석환 on 2021/11/20.
//

import Foundation

internal enum AuthQuery {
    internal static func select(userID: String,
                                challengeID: String,
                                todayDate: String) -> Data? {
        return """
        {
            "structuredQuery": {
                "from": { "collectionId": "challenge_auth" },
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
                            },
                            {
                                "fieldFilter": {
                                    "field": { "fieldPath": "date" },
                                    "op": "EQUAL",
                                    "value": { "stringValue": "\(todayDate)" }
                                },
                            }
                        ],
                        "op": "AND"
                    }
                },
                "limit": 1
            }
        }
        """.data(using: .utf8)
    }

    internal static func select(challengeID: String) -> Data? {
        return """
        {
            "structuredQuery": {
                "from": { "collectionId": "challenge_auth" },
                "where": {
                    "fieldFilter": {
                        "field": { "fieldPath": "challenge_id" },
                        "op": "EQUAL",
                        "value": { "stringValue": "\(challengeID)" }
                    },
                },
                "orderBy": [
                    {
                        "field": { "fieldPath": "date" },
                        "direction": "DESCENDING"
                    },
                ],
                "limit": 50
            }
        }
        """.data(using: .utf8)
    }

    internal static func select(challengeID: String,
                                userID: String) -> Data? {
        return """
        {
            "structuredQuery": {
                "from": { "collectionId": "challenge_auth" },
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
                "orderBy": [
                    {
                        "field": { "fieldPath": "date" },
                        "direction": "DESCENDING"
                    },
                ],
                "limit": 50
            }
        }
        """.data(using: .utf8)
    }

    internal static func insert(document: ChallengeAuthFields) -> Data? {
        return """
        {
            "fields": {
                "challenge_id": { "stringValue": "\(document.challengeID.stringValue)" },
                "user_id": { "stringValue": "\(document.userID.stringValue)" },
                "date": { "stringValue": "\(document.date.stringValue)" },
                "time": { "stringValue": "\(document.time.stringValue)" }
            }
        }
        """.data(using: .utf8)
    }
}
