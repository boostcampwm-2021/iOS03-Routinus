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
    func didTappedShowChallengeButton(challengeID: String)
}

protocol HomeViewModelOutput {
    var userInfo: CurrentValueSubject<User, Never> { get }
    var todayRoutine: CurrentValueSubject<[TodayRoutine], Never> { get }
    var achievementInfo: CurrentValueSubject<[AchievementInfo], Never> { get }

    // coordinator signal
    var showChallengeSignal: PassthroughSubject<Void, Never> { get }
    var showChallengeDetailSignal: PassthroughSubject<String, Never> { get }
}

protocol HomeViewModelType: HomeViewModelInput, HomeViewModelOutput { }

class HomeViewModel: HomeViewModelType {
    var userInfo = CurrentValueSubject<User, Never>(User())
    var todayRoutine = CurrentValueSubject<[TodayRoutine], Never>([])
    var achievementInfo = CurrentValueSubject<[AchievementInfo], Never>([])

    var showChallengeSignal = PassthroughSubject<Void, Never>()
    var showChallengeDetailSignal = PassthroughSubject<String, Never>()

    var usecase: HomeFetchableUsecase
    var cancellables = Set<AnyCancellable>()

    init(usecase: HomeFetchableUsecase) {
        self.usecase = usecase
        self.fetchMyRoutineData()
    }
}

extension HomeViewModel {
    func didTappedTodayRoutine() {
        self.showChallengeSignal.send()
    }

    func didTappedShowChallengeButton(challengeID: String) {
        self.showChallengeDetailSignal.send(challengeID)
    }
}

extension HomeViewModel {
    func fetchMyRoutineData() {
        usecase.fetchUserInfo()
        usecase.fetchTodayRoutine()
        usecase.fetchAcheivementInfo(yearMonth: Date.currentYearMonth())

        usecase.userInfoSignal
            .receive(on: RunLoop.main)
            .sink { [weak self] userInfo in self?.userInfo.value = userInfo }
            .store(in: &cancellables)

        usecase.todayRoutineSignal
            .receive(on: RunLoop.main)
            .sink { [weak self] routineList in self?.todayRoutine.value = routineList }
            .store(in: &cancellables)
        
        usecase.achievementSignal
            .receive(on: RunLoop.main)
            .sink { [weak self] achievementInfo in self?.achievementInfo.value = achievementInfo }
            .store(in: &cancellables)
    }
}
