//
//  HomeViewModel.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import Foundation
import Combine

protocol HomeViewModelInput {
    func didTappedTodayRoutine()
    func didTappedShowChallengeButton(identifier: String)
}

protocol HomeViewModelOutput {
    var nickName: CurrentValueSubject<String, Never> { get }
    var continuityDay: CurrentValueSubject<String, Never> { get }
    var todayRoutine: CurrentValueSubject<[ChallengeInfo], Never> { get }
    var archievementInfo: CurrentValueSubject<[ArchievementInfo], Never> { get }

    // coordinator signal
    var showChallengeView: PassthroughSubject<Void, Never> { get }
    var showChallengeDetailView: PassthroughSubject<ChallengeInfo, Never> { get }
}

class HomeViewModel: HomeViewModelOutput {
    var nickName = CurrentValueSubject<String, Never>("")
    var continuityDay = CurrentValueSubject<String, Never>("")
    var todayRoutine = CurrentValueSubject<[ChallengeInfo], Never>([])
    var archievementInfo = CurrentValueSubject<[ArchievementInfo], Never>([])

    var showChallengeView = PassthroughSubject<Void, Never>()
    var showChallengeDetailView = PassthroughSubject<ChallengeInfo, Never>()
    var usecase: HomeFetchableUsecase

    let formatter = DateFormatter()

    init(usecase: HomeFetchableUsecase) {
        self.usecase = usecase
        setDateFormatter()
    }
}

extension HomeViewModel: HomeViewModelInput {
    func didTappedTodayRoutine() {
        self.showChallengeView.send()
    }

    func didTappedShowChallengeButton(identifier: String) {
//        guard let challenge = todayRoutine.value
//                .filter({ $0.identifier == identifier })
//                .first else { return }
//        self.showChallengeDetailView.send(challenge)
    }
}

extension HomeViewModel {
    func fetchMyRoutineData() {
        // TODO: Usecase 데이터 받아오기
    }
}

extension HomeViewModel {
    func setDateFormatter() {
        self.formatter.timeZone = Calendar.current.timeZone
        self.formatter.locale = Calendar.current.locale
    }
}
