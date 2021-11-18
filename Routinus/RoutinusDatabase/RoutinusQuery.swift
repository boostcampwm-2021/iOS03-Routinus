//
//  RoutinusQuery.swift
//  RoutinusDatabase
//
//  Created by 유석환 on 2021/11/14.
//

import Foundation

internal enum RoutinusQuery {
    internal static func createUserQuery(id: String, name: String) -> Data? {
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

    internal static func insertChallengeQuery(document: ChallengeField) -> Data? {
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

    internal static func insertChallengeParticipationQuery(document: ParticipationField) -> Data? {
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
    
    internal static func insertChallengeAuthQuery(document: ChallengeAuthField) -> Data? {
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

    internal static func userQuery(of id: String) -> Data? {
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
            }
        }
        """.data(using: .utf8)
    }

    internal static func routinesQuery(userID: String) -> Data? {
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
            }
        }
        """.data(using: .utf8)
    }

    internal static func routinesQuery(challengeID: String) -> Data? {
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
                }
            }
            """.data(using: .utf8)
    }

    internal static func achievementQuery(of id: String, in yearMonth: String) -> Data? {
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

    internal static func allChallengesQuery() -> Data? {
        return """
        {
            "structuredQuery": {
                "from": {
                    "collectionId": "challenge",
                },
                "orderBy": [
                    {
                        "field": { "fieldPath": "participant_count" },
                        "direction": "ASCENDING"
                    },
                ],
                "limit": 50
            }
        }
        """.data(using: .utf8)
    }

    internal static func newChallengeQuery() -> Data? {
        return """
        {
            "structuredQuery": {
                "from": {
                    "collectionId": "challenge",
                },
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

    internal static func recommendChallengeQuery() -> Data? {
        return """
        {
            "structuredQuery": {
                "from": {
                    "collectionId": "challenge",
                },
                "orderBy": [
                    {
                        "field": { "fieldPath": "participant_count" },
                        "direction": "DESCENDING"
                    },
                ],
                "limit": 5
            }
        }
        """.data(using: .utf8)
    }

    internal static func searchChallenges(ownerID: String) -> Data? {
        return """
        {
            "structuredQuery": {
                "from": {
                    "collectionId": "challenge",
                },
                "where": {
                    "fieldFilter": {
                        "field": { "fieldPath": "owner_id" },
                        "op": "EQUAL",
                        "value": { "stringValue": "\(ownerID)" }
                    },
                }
            }
        }
        """.data(using: .utf8)
    }

    internal static func searchChallenges(categoryID: String) -> Data? {
        return """
        {
            "structuredQuery": {
                "from": {
                    "collectionId": "challenge",
                },
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
                ]
            }
        }
        """.data(using: .utf8)
    }

    internal static func challenge(challengeID: String) -> Data? {
        return """
        {
            "structuredQuery": {
                "from": {
                    "collectionId": "challenge",
                },
                "where": {
                    "fieldFilter": {
                        "field": { "fieldPath": "id" },
                        "op": "EQUAL",
                        "value": { "stringValue": "\(challengeID)" }
                    },
                }
            }
        }
        """.data(using: .utf8)
    }

    internal static func challenge(ownerID: String, challengeID: String) -> Data? {
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
                }
            }
        }
        """.data(using: .utf8)
    }

    internal static func updateChallenge(document: ChallengeField) -> Data? {
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

    internal static func challengeParticipation(userID: String, challengeID: String) -> Data? {
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
                }
            }
        }
        """.data(using: .utf8)
    }

}
