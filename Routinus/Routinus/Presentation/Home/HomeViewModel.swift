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
    func didTappedAddChallengeButton()
    func didTappedTodayRoutineAuth(index: Int)
}

protocol HomeViewModelOutput {
    var user: CurrentValueSubject<User, Never> { get }
    var todayRoutine: CurrentValueSubject<[TodayRoutine], Never> { get }
    var achievement: CurrentValueSubject<[Achievement], Never> { get }
    var showChallengeSignal: PassthroughSubject<Void, Never> { get }
    var showChallengeDetailSignal: PassthroughSubject<String, Never> { get }
    var showChallengeAuthSignal: PassthroughSubject<String, Never> { get }
    var formatter: DateFormatter { get }
}

protocol HomeViewModelIO: HomeViewModelInput, HomeViewModelOutput { }

final class HomeViewModel: HomeViewModelIO {
    var user = CurrentValueSubject<User, Never>(User())
    var todayRoutine = CurrentValueSubject<[TodayRoutine], Never>([])
    var achievement = CurrentValueSubject<[Achievement], Never>([])

    var showChallengeSignal = PassthroughSubject<Void, Never>()
    var showChallengeDetailSignal = PassthroughSubject<String, Never>()
    var showChallengeAuthSignal = PassthroughSubject<String, Never>()

    var createUsecase: HomeCreatableUsecase
    var fetchUsecase: HomeFetchableUsecase
    var cancellables = Set<AnyCancellable>()

    let formatter = DateFormatter()

    init(createUsecase: HomeCreatableUsecase, fetchUsecase: HomeFetchableUsecase) {
        self.createUsecase = createUsecase
        self.fetchUsecase = fetchUsecase

        setDateFormatter()
        self.createUserID()
        self.fetchMyHomeData()
    }
}

extension HomeViewModel {
    func didTappedTodayRoutine(index: Int) {
        let challengeID = self.todayRoutine.value[index].challengeID
        self.showChallengeDetailSignal.send(challengeID)
    }

    func didTappedAddChallengeButton() {
        self.showChallengeSignal.send()
    }

    func didTappedTodayRoutineAuth(index: Int) {
        let challengeID = self.todayRoutine.value[index].challengeID
        self.showChallengeAuthSignal.send(challengeID)
    }
}

extension HomeViewModel {
    private func createUserID() {
        createUsecase.createUserID()
    }

    private func fetchMyHomeData() {
        fetchUser()
        fetchTodayRoutine()
        fetchAcheivement()
    }

    private func fetchUser() {
        fetchUsecase.fetchUser { [weak self] user in
            self?.user.value = user
        }
    }

    private func fetchTodayRoutine() {
        fetchUsecase.fetchTodayRoutines { [weak self] todayRoutine in
            self?.todayRoutine.value = todayRoutine
        }
    }

    private func fetchAcheivement() {
        fetchUsecase.fetchAcheivements(yearMonth: Date.currentYearMonth()) { achievement in
            self.achievement.value = achievement
        }
    }
}

extension HomeViewModel {
    func setDateFormatter() {
        self.formatter.timeZone = Calendar.current.timeZone
        self.formatter.locale = Calendar.current.locale
    }
}
