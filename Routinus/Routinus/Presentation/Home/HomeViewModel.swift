//
//  HomeViewModel.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import Combine
import Foundation

protocol HomeViewModelInput {
    func fetchMyHomeData()
    func didTappedTodayRoutine(index: Int)
    func didTappedAddChallengeButton()
    func didTappedTodayRoutineAuth(index: Int)
    func didTappedExplanationButton()
    func generateDaysInMonth(for baseDate: Date) -> [Day]
    func changeDate(month: Int)
    func themeStyle() -> Int
}

protocol HomeViewModelOutput {
    var user: CurrentValueSubject<User, Never> { get }
    var todayRoutines: CurrentValueSubject<[TodayRoutine], Never> { get }
    var participationAuthStates: [ParticipationAuthState] { get }
    var achievements: [Achievement] { get }
    var challengeAddButtonTap: PassthroughSubject<Void, Never> { get }
    var todayRoutineTap: PassthroughSubject<String, Never> { get }
    var todayRoutineAuthTap: PassthroughSubject<String, Never> { get }
    var calendarExplanationButtonTap: PassthroughSubject<Void, Never> { get }
    var baseDate: CurrentValueSubject<Date, Never> { get }
    var days: CurrentValueSubject<[Day], Never> { get }
    var calendar: Calendar { get }
    var selectedDates: [Date] { get }
    var formatter: DateFormatter { get }
}

protocol HomeViewModelIO: HomeViewModelInput, HomeViewModelOutput { }

final class HomeViewModel: HomeViewModelIO {
    var user = CurrentValueSubject<User, Never>(User())
    var todayRoutines = CurrentValueSubject<[TodayRoutine], Never>([])
    var participationAuthStates = [ParticipationAuthState]()
    var achievements = [Achievement]()

    var challengeAddButtonTap = PassthroughSubject<Void, Never>()
    var todayRoutineTap = PassthroughSubject<String, Never>()
    var todayRoutineAuthTap = PassthroughSubject<String, Never>()
    var calendarExplanationButtonTap = PassthroughSubject<Void, Never>()

    var userCreateUsecase: UserCreatableUsecase
    var userFetchUsecase: UserFetchableUsecase
    var userUpdateUsecase: UserUpdatableUsecase
    var todayRoutineFetchUsecase: TodayRoutineFetchableUsecase
    var achievementFetchUsecase: AchievementFetchableUsecase
    var challengeAuthFetchUsecase: ChallengeAuthFetchableUsecase
    var cancellables = Set<AnyCancellable>()

    var days = CurrentValueSubject<[Day], Never>([])
    var baseDate = CurrentValueSubject<Date, Never>(Date())
    var calendar = Calendar(identifier: .gregorian)
    var selectedDates = [Date]()

    let formatter = DateFormatter()

    let userCreatePublisher = NotificationCenter.default.publisher(for: UserCreateUsecase.didCreateUser,
                                                                   object: nil)
    let userUpdatePublisher = NotificationCenter.default.publisher(for: UserUpdateUsecase.didUpdateUser,
                                                                   object: nil)
    let challengeCreatePublisher = NotificationCenter.default.publisher(for: ChallengeCreateUsecase.didCreateChallenge,
                                                                        object: nil)
    let challengeUpdatePublisher = NotificationCenter.default.publisher(for: ChallengeUpdateUsecase.didUpdateChallenge,
                                                                        object: nil)
    let achievementUpdatePublisher = NotificationCenter.default.publisher(for: AchievementUpdateUsecase.didUpdateAchievement,
                                                                          object: nil)
    let authCreatePublisher = NotificationCenter.default.publisher(for: ChallengeAuthCreateUsecase.didCreateAuth,
                                                                   object: nil)
    let participationCreatePublisher = NotificationCenter.default.publisher(for: ParticipationCreateUsecase.didCreateParticipation,
                                                                            object: nil)
    let participationUpdatePublisher = NotificationCenter.default.publisher(for: ParticipationUpdateUsecase.didUpdateParticipation,
                                                                            object: nil)

    init(userCreateUsecase: UserCreatableUsecase,
         userFetchUsecase: UserFetchableUsecase,
         userUpdateUsecase: UserUpdatableUsecase,
         todayRoutineFetchUsecase: TodayRoutineFetchableUsecase,
         achievementFetchUsecase: AchievementFetchableUsecase,
         challengeAuthFetchUsecase: ChallengeAuthFetchableUsecase) {
        self.userCreateUsecase = userCreateUsecase
        self.userFetchUsecase = userFetchUsecase
        self.userUpdateUsecase = userUpdateUsecase
        self.todayRoutineFetchUsecase = todayRoutineFetchUsecase
        self.achievementFetchUsecase = achievementFetchUsecase
        self.challengeAuthFetchUsecase = challengeAuthFetchUsecase

        self.setDateFormatter()
        self.baseDate.value = Date()
        self.days.value = self.generateDaysInMonth(for: self.baseDate.value)
        self.fetchMyHomeData()
        self.configurePublishers()
    }
}

extension HomeViewModel {
    func fetchMyHomeData() {
        fetchUser()
        fetchTodayRoutine()
        fetchAchievement(date: baseDate.value)
        updateContinuityDay()
    }

    func themeStyle() -> Int {
        return userFetchUsecase.fetchThemeStyle()
    }

    func didTappedTodayRoutine(index: Int) {
        let challengeID = self.todayRoutines.value[index].challengeID
        self.todayRoutineTap.send(challengeID)
    }

    func didTappedAddChallengeButton() {
        self.challengeAddButtonTap.send()
    }

    func didTappedTodayRoutineAuth(index: Int) {
        let challengeID = self.todayRoutines.value[index].challengeID
        self.todayRoutineAuthTap.send(challengeID)
    }
  
    func didTappedExplanationButton() {
        self.calendarExplanationButtonTap.send()
    }

    func configurePublishers() {
        self.userCreatePublisher
            .receive(on: RunLoop.main)
            .sink { _ in
                self.fetchUser()
            }
            .store(in: &cancellables)

        self.userUpdatePublisher
            .receive(on: RunLoop.main)
            .sink { _ in
                self.fetchMyHomeData()
            }
            .store(in: &cancellables)

        self.challengeCreatePublisher
            .receive(on: RunLoop.main)
            .sink { _ in
                self.fetchTodayRoutine()
            }
            .store(in: &cancellables)

        self.challengeUpdatePublisher
            .receive(on: RunLoop.main)
            .sink { _ in
                self.fetchTodayRoutine()
            }
            .store(in: &cancellables)

        self.achievementUpdatePublisher
            .receive(on: RunLoop.main)
            .sink { _ in
                self.fetchAchievement(date: self.baseDate.value)
            }
            .store(in: &cancellables)

        self.authCreatePublisher
            .receive(on: RunLoop.main)
            .sink { _ in
                self.fetchTodayRoutine()
                self.fetchAchievement(date: self.baseDate.value)
            }
            .store(in: &cancellables)

        self.participationCreatePublisher
            .receive(on: RunLoop.main)
            .sink { _ in
                self.fetchTodayRoutine()
                self.fetchAchievement(date: self.baseDate.value)
            }
            .store(in: &cancellables)

        self.participationUpdatePublisher
            .receive(on: RunLoop.main)
            .sink { _ in
                self.fetchTodayRoutine()
                self.fetchAchievement(date: self.baseDate.value)
            }
            .store(in: &cancellables)
    }
}

extension HomeViewModel {
    private func fetchUser() {
        if let userID = userFetchUsecase.fetchUserID() {
            userFetchUsecase.fetchUser(id: userID) { [weak self] user in
                self?.user.value = user
            }
        } else {
            userCreateUsecase.createUser()
        }
    }

    private func fetchTodayRoutine() {
        todayRoutineFetchUsecase.fetchTodayRoutines { [weak self] todayRoutines in
            self?.todayRoutines.value = todayRoutines
            self?.configureParticipationAuthStates(todayRoutines: todayRoutines)
        }
    }

    private func fetchAchievement(date: Date = Date()) {
        achievementFetchUsecase.fetchAchievements(yearMonth: date.toYearMonthString()) { achievement in
            self.selectedDates = achievement.map { Date(dateString: "\($0.yearMonth)\($0.day)") }
            self.achievements = achievement
            self.days.value = self.generateDaysInMonth(for: self.baseDate.value)
        }
    }

    private func fetchAuth(challengeID: String, completion: @escaping (ChallengeAuth?) -> Void) {
        self.challengeAuthFetchUsecase.fetchChallengeAuth(challengeID: challengeID) { challengeAuth in
            completion(challengeAuth)
        }
    }

    private func updateContinuityDay() {
        self.userUpdateUsecase.updateContinuityDay { [weak self] user in
            self?.user.value = user
        }
    }

    private func configureParticipationAuthStates(todayRoutines: [TodayRoutine]) {
        self.participationAuthStates = Array(repeating: .notAuthenticating,
                                              count: todayRoutines.count)

        todayRoutines.enumerated().forEach { [weak self] (idx, routine) in
            self?.fetchAuth(challengeID: routine.challengeID,
                            completion: { challengAuth in
                let authState: ParticipationAuthState = challengAuth != nil ? .authenticated : .notAuthenticating
                self?.participationAuthStates[idx] = authState
            })
        }
    }
}

extension HomeViewModel {
    enum CalendarDataError: Error {
        case metadataGenerationFailed
    }

    func setDateFormatter() {
        self.formatter.timeZone = Calendar.current.timeZone
        self.formatter.locale = Calendar.current.locale
    }

    private func monthMetadata(for baseDate: Date) throws -> MonthMetadata {
        guard let numberOfDaysInMonth = calendar.range(of: .day, in: .month, for: baseDate)?.count,
              let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: baseDate))
        else {
            throw CalendarDataError.metadataGenerationFailed
        }

        let firstDayWeekday = calendar.component(.weekday, from: firstDayOfMonth)

        return MonthMetadata(
            numberOfDays: numberOfDaysInMonth,
            firstDay: firstDayOfMonth,
            firstDayWeekday: firstDayWeekday)
    }

    func generateDaysInMonth(for baseDate: Date) -> [Day] {
        guard let metadata = try? monthMetadata(for: baseDate) else { return [] }

        let numberOfDaysInMonth = metadata.numberOfDays
        let offsetInInitialRow = metadata.firstDayWeekday
        let firstDayOfMonth = metadata.firstDay

        var days: [Day] = (1..<(numberOfDaysInMonth + offsetInInitialRow)).map { day in
            let isWithinDisplayedMonth = day >= offsetInInitialRow
            let dayOffset = isWithinDisplayedMonth ? day - offsetInInitialRow : -(offsetInInitialRow - day)

            return generateDay(
                offsetBy: dayOffset,
                for: firstDayOfMonth,
                isWithinDisplayedMonth: isWithinDisplayedMonth)
        }

        days += generateStartOfNextMonth(using: firstDayOfMonth)

        return days
    }

    private func generateDay(offsetBy dayOffset: Int, for baseDate: Date, isWithinDisplayedMonth: Bool) -> Day {
        let date = calendar.date(byAdding: .day, value: dayOffset, to: baseDate) ?? baseDate
        let achievement = achievements.filter { "\($0.yearMonth)\($0.day)" == date.toDateString() }
        let achievementRate = Double(achievement.first?.achievementCount ?? 0) / Double(achievement.first?.totalCount ?? 0)
        return Day(
            date: date,
            number: "\(date.day)",
            isSelected: selectedDates.contains(date),
            achievementRate: (achievement.count > 0
                              ? achievementRate
                              : 0),
            isWithinDisplayedMonth: isWithinDisplayedMonth
        )
    }

    private func generateStartOfNextMonth(using firstDayOfDisplayedMonth: Date) -> [Day] {
        guard let lastDayInMonth = calendar.date(
            byAdding: DateComponents(month: 1, day: -1),
            to: firstDayOfDisplayedMonth)
        else { return [] }

        let additionalDays = 7 - calendar.component(.weekday, from: lastDayInMonth)
        guard additionalDays > 0 else { return [] }

        let days: [Day] = (1...additionalDays).map {
            generateDay(offsetBy: $0, for: lastDayInMonth, isWithinDisplayedMonth: false)
        }

        return days
    }

    func changeDate(month: Int) {
        let changedDate = calendar.date(byAdding: .month, value: month, to: baseDate.value) ?? Date()
        baseDate.value = month == 0 ? Date() : changedDate
        days.value = generateDaysInMonth(for: baseDate.value)
        fetchAchievement(date: baseDate.value)
    }
}
