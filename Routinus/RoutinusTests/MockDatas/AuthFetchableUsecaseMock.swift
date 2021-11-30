//
//  AuthFetchableUsecaseMock.swift
//  RoutinusTests
//
//  Created by 박상우 on 2021/11/30.
//

import XCTest
@testable import Routinus

class AuthFetchableUsecaseMock: AuthFetchableUsecase {
    func fetchAuth(challengeID: String, completion: @escaping (Auth?) -> Void) {
//        let auth = Auth(challengeID: "testChallenge1",
//                        userID: "testUserID",
//                        date: Date(dateString: "20211129"),
//                        time: Date(timeString: "1130"))
        completion(nil)
    }
    
    func fetchAuths(challengeID: String, completion: @escaping ([Auth]) -> Void) {
        let auths: [Auth] = [Auth(challengeID: "testChallenge2",
                                  userID: "testUserID",
                                  date: Date(dateString: "20211129"),
                                  time: Date(timeString: "1230")),
                             Auth(challengeID: "testChallenge3",
                                  userID: "testUserID",
                                  date: Date(dateString: "20211130"),
                                  time: Date(timeString: "1330"))]
        completion(auths)
    }
    
    func fetchMyAuths(challengeID: String, completion: @escaping ([Auth]) -> Void) {
        let auths: [Auth] = [Auth(challengeID: "testChallenge4",
                                  userID: "testUserID",
                                  date: Date(dateString: "20211129"),
                                  time: Date(timeString: "1430")),
                             Auth(challengeID: "testChallenge5",
                                  userID: "testUserID",
                                  date: Date(dateString: "20211130"),
                                  time: Date(timeString: "1530"))]
        completion(auths)
    }
}
