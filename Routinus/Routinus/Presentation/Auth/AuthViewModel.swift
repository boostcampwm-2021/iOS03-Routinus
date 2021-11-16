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
    
    init(challengeID: String) {
        self.fetchChallenge(challengeID: challengeID)
    }
}

extension AuthViewModel {
    func didTappedAuthButton() {
        
    }
}

extension AuthViewModel {
    private func fetchChallenge(challengeID: String) {
        
    }
}
