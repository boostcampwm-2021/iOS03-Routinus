//
//  AuthViewModel.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/16.
//

import Combine
import Foundation

protocol AuthViewModelInput {
    func didTappedAuthButton()
}

protocol AuthViewModelOutput {
    var challenge: PassthroughSubject<Challenge, Never> { get }
}

protocol AuthViewModelIO: AuthViewModelInput, AuthViewModelOutput { }

class AuthViewModel: AuthViewModelIO {
    var challenge = PassthroughSubject<Challenge, Never>()
    var usecase: AuthFetchableUsecase
    
    init(challengeID: String, usecase: AuthFetchableUsecase) {
        self.usecase = usecase
        self.fetchChallenge(challengeID: challengeID)
    }
}

extension AuthViewModel {
    func didTappedAuthButton() {
        
    }
}

extension AuthViewModel {
    private func fetchChallenge(challengeID: String) {
        usecase.fetchChallenge(challengeID: challengeID) { [weak self] challenge in
            guard let self = self,
                  let challenge = challenge else { return }
            self.challenge.send(challenge)
        }
    }
}
