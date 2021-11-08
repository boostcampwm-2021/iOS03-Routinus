//
//  HomeViewModel.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import Combine
import Foundation

protocol HomeViewModelInput {
    func didTappedTodayRoutine(index: Int)
    func didTappedShowChallengeButton()
    func didTappedTodayRoutineAuth(index: Int)
}

protocol HomeViewModelOutput {
    var userInfo: CurrentValueSubject<User, Never> { get }
    var todayRoutine: CurrentValueSubject<[TodayRoutine], Never> { get }
    var achievementInfo: CurrentValueSubject<[AchievementInfo], Never> { get }

    // coordinator signal
    var showChallengeSignal: PassthroughSubject<Void, Never> { get }
    var showChallengeDetailSignal: PassthroughSubject<String, Never> { get }
    var showChallengeAuthSignal: PassthroughSubject<String, Never> { get }
    var formatter: DateFormatter { get }
}

protocol HomeViewModelType: HomeViewModelInput, HomeViewModelOutput { }

class HomeViewModel: HomeViewModelType {
    var userInfo = CurrentValueSubject<User, Never>(User())
    var todayRoutine = CurrentValueSubject<[TodayRoutine], Never>([])
    var achievementInfo = CurrentValueSubject<[AchievementInfo], Never>([])

    var showChallengeSignal = PassthroughSubject<Void, Never>()
    var showChallengeDetailSignal = PassthroughSubject<String, Never>()
    var showChallengeAuthSignal = PassthroughSubject<String, Never>()

    var usecase: HomeFetchableUsecase
    var cancellables = Set<AnyCancellable>()

    let formatter = DateFormatter()

    init(usecase: HomeFetchableUsecase) {
        self.usecase = usecase
        setDateFormatter()
        self.fetchMyHomeData()
    }
}

extension HomeViewModel {
    func didTappedTodayRoutine(index: Int) {
        let challengeID = self.todayRoutine.value[index].challengeID
        self.showChallengeDetailSignal.send(challengeID)
    }

    func didTappedShowChallengeButton() {
        self.showChallengeSignal.send()
    }

    func didTappedTodayRoutineAuth(index: Int) {
        let challengeID = self.todayRoutine.value[index].challengeID
        self.showChallengeAuthSignal.send(challengeID)
    }
}

extension HomeViewModel {
    private func fetchMyHomeData() {
        fetchUserInfo()
        fetchTodayRoutine()
        fetchAcheivementInfo()
    }

    private func fetchUserInfo() {
        usecase.fetchUserInfo { [weak self] user in
            self?.userInfo.value = user
        }
    }

    private func fetchTodayRoutine() {
        usecase.fetchTodayRoutine { [weak self] todayRoutine in
            self?.todayRoutine.value = todayRoutine
        }
    }

    private func fetchAcheivementInfo() {
        usecase.fetchAcheivementInfo(yearMonth: Date.currentYearMonth()) { achievementInfo in
            self.achievementInfo.value = achievementInfo
        }
    }
}

extension HomeViewModel {
    func setDateFormatter() {
        self.formatter.timeZone = Calendar.current.timeZone
        self.formatter.locale = Calendar.current.locale
    }
}
