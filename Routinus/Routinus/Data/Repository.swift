//
//  Repository.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/08.
//

import Foundation

class Repository {

    static let userDefaultKey = "uuid"

    private func isEmptyUserDefaults() -> Bool {
        return UserDefaults.standard.string(forKey: Repository.userDefaultKey) == nil
    }

    func checkUserDefaults() {
        if isEmptyUserDefaults() {
            // 저장된 데이터가 없을 때 uuid 저장 & 랜덤 닉네임 생성
            saveUUID()
            NickNameFactory.shared.createRandomNickName()
        }
        // 있으면 별다른 작업을 하지 않는다...?
    }

    func saveUUID() {
        let uuid = UUID()
        UserDefaults.standard.set(uuid, forKey: Repository.userDefaultKey)
    }
}

class NickNameFactory {

    static let shared = NickNameFactory()

    private init() { }

    func createRandomNickName() -> String {
        // TODO:- 랜덤 닉네임 작업
        return "" 
    }
}



