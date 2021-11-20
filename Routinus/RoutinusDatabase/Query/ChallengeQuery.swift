//
//  ChallengeQuery.swift
//  RoutinusDatabase
//
//  Created by 유석환 on 2021/11/20.
//

import Foundation

internal enum ChallengeQuery {
    internal static func select(categoryID: String) -> Data? {
        return """
        {
            "structuredQuery": {
                "from": { "collectionId": "challenge" },
                "where": {
                    "fieldFilter": {
                        "field": { "fieldPath": "category_id" },
                        "op": "EQUAL",
                        "value": { "stringValue": "\(categoryID)" }
                    },
                },
                "orderBy": [
                    {
                        "field": { "fieldPath": "participant_count" },
                        "direction": "DESCENDING"
                    },
                ],
                "limit": 50
            }
        }
        """.data(using: .utf8)
    }

    internal static func select(ownerID: String) -> Data? {
        return """
        {
            "structuredQuery": {
                "from": { "collectionId": "challenge" },
                "where": {
                    "fieldFilter": {
                        "field": { "fieldPath": "owner_id" },
                        "op": "EQUAL",
                        "value": { "stringValue": "\(ownerID)" }
                    },
                },
                "limit": 50
            }
        }
        """.data(using: .utf8)
    }

    internal static func select(challengeID: String) -> Data? {
        return """
            {
                "structuredQuery": {
                    "from": { "collectionId": "challenge" },
                    "where": {
                        "fieldFilter": {
                            "field": { "fieldPath": "id" },
                            "op": "EQUAL",
                            "value": { "stringValue": "\(challengeID)" }
                        },
                    },
                    "limit": 50
                }
            }
            """.data(using: .utf8)
    }

    internal static func select(ownerID: String,
                                challengeID: String) -> Data? {
        return """
        {
            "structuredQuery": {
                "from": { "collectionId": "challenge" },
                "where": {
                    "compositeFilter": {
                        "filters": [
                            {
                                "fieldFilter": {
                                    "field": { "fieldPath": "owner_id" },
                                    "op": "EQUAL",
                                    "value": { "stringValue": "\(ownerID)" }
                                }
                            },
                            {
                                "fieldFilter": {
                                    "field": { "fieldPath": "id" },
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

    internal static func selectOrderByParticipantCount(ascending: Bool,
                                                       limit: Int) -> Data? {
        return """
        {
            "structuredQuery": {
                "from": { "collectionId": "challenge" },
                "orderBy": [
                    {
                        "field": { "fieldPath": "participant_count" },
                        "direction": "\(ascending ? "ASCENDING" : "DESCENDING")"
                    },
                ],
                "limit": \(limit)
            }
        }
        """.data(using: .utf8)
    }

    internal static func selectOrderByStartDate() -> Data? {
        return """
        {
            "structuredQuery": {
                "from": { "collectionId": "challenge" },
                "orderBy": [
                    {
                        "field": { "fieldPath": "start_date" },
                        "direction": "DESCENDING"
                    },
                ],
                "limit": 10
            }
        }
        """.data(using: .utf8)
    }

    internal static func insert(document: ChallengeField) -> Data? {
        return """
        {
            "fields": {
                "auth_method": { "stringValue": "\(document.authMethod.stringValue)" },
                "category_id": { "stringValue": "\(document.categoryID.stringValue)" },
                "desc": { "stringValue": "\(document.desc.stringValue)" },
                "end_date": { "stringValue": "\(document.endDate.stringValue)" },
                "id": { "stringValue": "\(document.id.stringValue)" },
                "owner_id": { "stringValue": "\(document.ownerID.stringValue)" },
                "participant_count": { "integerValue": "\(document.participantCount.integerValue)" },
                "start_date": { "stringValue": "\(document.startDate.stringValue)" },
                "title": { "stringValue": "\(document.title.stringValue)" },
                "week": { "integerValue": "\(document.week.integerValue)" }
            }
        }
        """.data(using: .utf8)
    }

    internal static func update(document: ChallengeField) -> Data? {
        return """
        {
            "fields": {
                "auth_method": { "stringValue": "\(document.authMethod.stringValue)" },
                "category_id": { "stringValue": "\(document.categoryID.stringValue)" },
                "desc": { "stringValue": "\(document.desc.stringValue)" },
                "end_date": { "stringValue": "\(document.endDate.stringValue)" },
                "title": { "stringValue": "\(document.title.stringValue)" },
                "week": { "integerValue": "\(document.week.integerValue)" }
            }
        }
        """.data(using: .utf8)
    }
}
