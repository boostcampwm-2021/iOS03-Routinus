//
//  AchievementQuery.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/29.
//

import Foundation

enum AchievementQuery {
    static func select(id: String, yearMonth: String) -> Data? {
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
                },
                "limit": 50
            }
        }
        """.data(using: .utf8)
    }

    static func select(id: String, yearMonth: String, day: String) -> Data? {
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
                },
                "limit": 50
            }
        }
        """.data(using: .utf8)
    }

    static func insert(id: String, yearMonth: String, day: String, totalCount: String) -> Data? {
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

    static func update(document: AchievementFields) -> Data? {
        return """
        {
            "fields": {
                "achievement_count": { "integerValue": "\(document.achievementCount.integerValue)" }
            }
        }
        """.data(using: .utf8)
    }

    static func updateTotalCount(document: AchievementFields) -> Data? {
        return """
        {
            "fields": {
                "total_count": { "integerValue": "\(document.totalCount.integerValue)" }
            }
        }
        """.data(using: .utf8)
    }
}
