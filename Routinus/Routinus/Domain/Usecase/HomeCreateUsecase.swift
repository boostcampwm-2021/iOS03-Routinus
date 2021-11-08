//
//  HomeCreateUsecase.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/08.
//

import CryptoKit
import Foundation

protocol HomeCreatableUsecase {
    func createUserID()
}

struct HomeCreateUsecase: HomeCreatableUsecase {
    var repository: HomeRepository

    init(repository: HomeRepository) {
        self.repository = repository
    }

    private func createID() -> String {
        let uuid = UUID().uuidString
        guard let data = uuid.data(using: .utf8) else { return "" }
        let sha256 = SHA256.hash(data: data)
        return sha256.compactMap{String(format: "%02x", $0)}.joined()
    }

    func createUserID() {
        guard !repository.isEmptyUserID() else { return }
        let id = createID()
        let name = UserNameFactory.createRandomName()
        repository.save(id: id, name: name)
    }
}
