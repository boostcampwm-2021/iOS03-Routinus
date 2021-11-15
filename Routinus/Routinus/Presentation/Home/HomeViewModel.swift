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
    var challengeAddButtonTap: PassthroughSubject<Void, Never> { get }
    var todayRoutineTap: PassthroughSubject<String, Never> { get }
    var todayRoutineAuthTap: PassthroughSubject<String, Never> { get }
    var formatter: DateFormatter { get }
}

protocol HomeViewModelIO: HomeViewModelInput, HomeViewModelOutput { }

final class HomeViewModel: HomeViewModelIO {
    var user = CurrentValueSubject<User, Never>(User())
    var todayRoutine = CurrentValueSubject<[TodayRoutine], Never>([])
    var achievement = CurrentValueSubject<[Achievement], Never>([])

    var challengeAddButtonTap = PassthroughSubject<Void, Never>()
    var todayRoutineTap = PassthroughSubject<String, Never>()
    var todayRoutineAuthTap = PassthroughSubject<String, Never>()

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
        self.todayRoutineTap.send(challengeID)
    }

    func didTappedAddChallengeButton() {
        self.challengeAddButtonTap.send()
    }

    func didTappedTodayRoutineAuth(index: Int) {
        let challengeID = self.todayRoutine.value[index].challengeID
        self.todayRoutineAuthTap.send(challengeID)
    }
}

extension HomeViewModel {
    private func createUserID() {
        createUsecase.createUserID()
    }

    private func fetchMyHomeData() {
        fetchUser()
        fetchTodayRoutine()
        fetchAchievement()
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

    private func fetchAchievement() {
        fetchUsecase.fetchAchievements(yearMonth: Date.currentYearMonth()) { achievement in
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
