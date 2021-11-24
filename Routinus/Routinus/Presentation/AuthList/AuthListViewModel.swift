//
//  AuthListViewModel.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/24.
//

import Combine
import Foundation

protocol AuthListViewModelInput {

}

protocol AuthListViewModelOutput {
    var auths: CurrentValueSubject<[ChallengeAuth], Never> { get }
}

protocol AuthListViewModelIO: AuthListViewModelInput, AuthListViewModelOutput { }

final class AuthListViewModel: AuthListViewModelIO {
    var auths = CurrentValueSubject<[ChallengeAuth], Never>([])
    let challengeAuthFetchUsecase: ChallengeAuthFetchableUsecase

    private var challengeID: String?

    init(challengeID: String,
         challengeAuthFetchUsecase: ChallengeAuthFetchableUsecase) {
        self.challengeID = challengeID
        self.challengeAuthFetchUsecase = challengeAuthFetchUsecase
        self.fetchChallengeAuths()
    }
}

extension AuthListViewModel {
    private func fetchChallengeAuths() {
        guard let challengeID = challengeID else { return }
        challengeAuthFetchUsecase.fetchChallengeAuths(challengeID: challengeID) { challengeAuths in
            self.auths.value = challengeAuths
        }
    }
}
