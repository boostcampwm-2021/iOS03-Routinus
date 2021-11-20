//
//  AchievementQuery.swift
//  RoutinusDatabase
//
//  Created by 유석환 on 2021/11/20.
//

import Foundation

internal enum AchievementQuery {
    internal static func select(id: String,
                                yearMonth: String) -> Data? {
        return """
        {
            "structuredQuery": {
                "from": { "collectionId": "achievement" },
                "where": {
                    "compositeFilter": {
                        "filters": [
                            {
                                "fieldFilter": {
                                    "field": { "fieldPath": "user_id" },
                                    "op": "EQUAL",
                                    "value": { "stringValue": "\(id)" }
                                }
                            },
                            {
                                "fieldFilter": {
                                    "field": { "fieldPath": "year_month" },
                                    "op": "EQUAL",
                                    "value": { "stringValue": "\(yearMonth)" }
                                },
                            }
                        ],
                        "op": "AND"
                    }
                }
            }
        }
        """.data(using: .utf8)
    }

    internal static func select(id: String,
                                yearMonth: String,
                                day: String) -> Data? {
        return """
        {
            "structuredQuery": {
                "from": { "collectionId": "achievement" },
                "where": {
                    "compositeFilter": {
                        "filters": [
                            {
                                "fieldFilter": {
                                    "field": { "fieldPath": "user_id" },
                                    "op": "EQUAL",
                                    "value": { "stringValue": "\(id)" }
                                }
                            },
                            {
                                "fieldFilter": {
                                    "field": { "fieldPath": "year_month" },
                                    "op": "EQUAL",
                                    "value": { "stringValue": "\(yearMonth)" }
                                },
                            },
                            {
                                "fieldFilter": {
                                    "field": { "fieldPath": "day" },
                                    "op": "EQUAL",
                                    "value": { "stringValue": "\(day)" }
                                },
                            }
                        ],
                        "op": "AND"
                    }
                }
            }
        }
        """.data(using: .utf8)
    }

    internal static func insert(id: String,
                                yearMonth: String,
                                day: String,
                                totalCount: String) -> Data? {
        return """
        {
            "fields": {
                "achievement_count": { "integerValue": "0" },
                "day": { "stringValue": "\(day)" },
                "total_count": { "integerValue": "\(totalCount)" },
                "user_id": { "stringValue": "\(id)" },
                "year_month": { "stringValue": "\(yearMonth)" }
            }
        }
        """.data(using: .utf8)
    }

    internal static func update(document: AchievementField) -> Data? {
        return """
        {
            "fields": {
                "achievement_count": { "integerValue": "\(document.achievementCount.integerValue)" }
            }
        }
        """.data(using: .utf8)
    }
}
