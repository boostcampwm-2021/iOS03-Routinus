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
    func themeStyle() -> Int
    func updateDate(month: Int)
    func didTappedTodayRoutine(index: Int)
    func didTappedAddChallengeButton()
    func didTappedTodayRoutineAuth(index: Int)
    func didTappedExplanationButton()
}

protocol HomeViewModelOutput {
    var user: CurrentValueSubject<User, Never> { get }
    var days: CurrentValueSubject<[Day], Never> { get }
    var baseDate: CurrentValueSubject<Date, Never> { get }
    var todayRoutines: CurrentValueSubject<[TodayRoutine], Never> { get }

    var todayRoutineTap: PassthroughSubject<String, Never> { get }
    var todayRoutineAuthTap: PassthroughSubject<String, Never> { get }
    var challengeAddButtonTap: PassthroughSubject<Void, Never> { get }
    var calendarExplanationButtonTap: PassthroughSubject<Void, Never> { get }

    var participationAuthStates: [ParticipationAuthState] { get }
}

protocol HomeViewModelIO: HomeViewModelInput, HomeViewModelOutput { }

final class HomeViewModel: HomeViewModelIO {
    var user = CurrentValueSubject<User, Never>(User())
    var todayRoutines = CurrentValueSubject<[TodayRoutine], Never>([])
    var days = CurrentValueSubject<[Day], Never>([])
    var baseDate = CurrentValueSubject<Date, Never>(Date())

    let formatter = DateFormatter()
    var selectedDates = [Date]()
    var achievements = [Achievement]()
    var calendar = Calendar(identifier: .gregorian)
    var participationAuthStates = [ParticipationAuthState]()
    var cancellables = Set<AnyCancellable>()

    var challengeAddButtonTap = PassthroughSubject<Void, Never>()
    var todayRoutineTap = PassthroughSubject<String, Never>()
    var todayRoutineAuthTap = PassthroughSubject<String, Never>()
    var calendarExplanationButtonTap = PassthroughSubject<Void, Never>()

    var userCreateUsecase: UserCreatableUsecase
    var userFetchUsecase: UserFetchableUsecase
    var userUpdateUsecase: UserUpdatableUsecase
    var todayRoutineFetchUsecase: TodayRoutineFetchableUsecase
    var achievementFetchUsecase: AchievementFetchableUsecase
    var authFetchUsecase: AuthFetchableUsecase

    let userCreatePublisher = NotificationCenter.default.publisher(
        for: UserCreateUsecase.didCreateUser,
        object: nil
    )
    let userUpdatePublisher = NotificationCenter.default.publisher(
        for: UserUpdateUsecase.didUpdateUser,
        object: nil
    )
    let challengeCreatePublisher = NotificationCenter.default.publisher(
        for: ChallengeCreateUsecase.didCreateChallenge,
        object: nil
    )
    let challengeUpdatePublisher = NotificationCenter.default.publisher(
        for: ChallengeUpdateUsecase.didUpdateChallenge,
        object: nil
    )
    let achievementUpdatePublisher = NotificationCenter.default.publisher(
        for: AchievementUpdateUsecase.didUpdateAchievement,
        object: nil
    )
    let authCreatePublisher = NotificationCenter.default.publisher(
        for: AuthCreateUsecase.didCreateAuth,
        object: nil
    )
    let participationCreatePublisher = NotificationCenter.default.publisher(
        for: ParticipationCreateUsecase.didCreateParticipation,
        object: nil
    )
    let participationUpdatePublisher = NotificationCenter.default.publisher(
        for: ParticipationUpdateUsecase.didUpdateParticipation,
        object: nil
    )

    init(userCreateUsecase: UserCreatableUsecase,
         userFetchUsecase: UserFetchableUsecase,
         userUpdateUsecase: UserUpdatableUsecase,
         todayRoutineFetchUsecase: TodayRoutineFetchableUsecase,
         achievementFetchUsecase: AchievementFetchableUsecase,
         authFetchUsecase: AuthFetchableUsecase) {
        self.userCreateUsecase = userCreateUsecase
        self.userFetchUsecase = userFetchUsecase
        self.userUpdateUsecase = userUpdateUsecase
        self.todayRoutineFetchUsecase = todayRoutineFetchUsecase
        self.achievementFetchUsecase = achievementFetchUsecase
        self.authFetchUsecase = authFetchUsecase

        configureDateFormatter()
        configureCalendar()
        configurePublishers()
        fetchMyHomeData()
    }
}

extension HomeViewModel {
    private func configureDateFormatter() {
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
    }

    private func configureCalendar() {
        baseDate.value = Date()
        days.value = generateDaysInMonth(for: baseDate.value)
    }

    private func configurePublishers() {
        userCreatePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.fetchUser()
            }
            .store(in: &cancellables)

        userUpdatePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.fetchMyHomeData()
            }
            .store(in: &cancellables)

        challengeCreatePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.fetchTodayRoutine()
            }
            .store(in: &cancellables)

        challengeUpdatePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.fetchTodayRoutine()
            }
            .store(in: &cancellables)

        achievementUpdatePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.fetchAchievement(date: self.baseDate.value)
            }
            .store(in: &cancellables)

        authCreatePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.fetchTodayRoutine()
                self.fetchAchievement(date: self.baseDate.value)
            }
            .store(in: &cancellables)

        participationCreatePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.fetchTodayRoutine()
                self.fetchAchievement(date: self.baseDate.value)
            }
            .store(in: &cancellables)

        participationUpdatePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.fetchTodayRoutine()
                self.fetchAchievement(date: self.baseDate.value)
            }
            .store(in: &cancellables)
    }

    private func fetchUser() {
        if let userID = userFetchUsecase.fetchUserID() {
            userFetchUsecase.fetchUser(id: userID) { [weak self] user in
                guard let self = self else { return }
                self.user.value = user
            }
        } else {
            userCreateUsecase.createUser()
        }
    }

    private func fetchTodayRoutine() {
        todayRoutineFetchUsecase.fetchTodayRoutines { [weak self] todayRoutines in
            guard let self = self else { return }
            self.todayRoutines.value = todayRoutines
            self.updateParticipationAuthStates(todayRoutines: todayRoutines)
        }
    }

    private func fetchAchievement(date: Date = Date()) {
        achievementFetchUsecase.fetchAchievements(
            yearMonth: date.toYearMonthString()
        ) { [weak self] achievement in
            guard let self = self else { return }
            self.selectedDates = achievement.map { Date(dateString: "\($0.yearMonth)\($0.day)") }
            self.achievements = achievement
            self.days.value = self.generateDaysInMonth(for: self.baseDate.value)
        }
    }

    private func fetchAuth(challengeID: String, completion: @escaping (Auth?) -> Void) {
        authFetchUsecase.fetchAuth(challengeID: challengeID) { auth in
            completion(auth)
        }
    }

    private func updateContinuityDay() {
        userUpdateUsecase.updateContinuityDay { [weak self] user in
            guard let self = self else { return }
            self.user.value = user
        }
    }

    private func updateParticipationAuthStates(todayRoutines: [TodayRoutine]) {
        participationAuthStates = Array(repeating: .notAuthenticating, count: todayRoutines.count)

        todayRoutines.enumerated().forEach { [weak self] (idx, routine) in
            guard let self = self else { return }
            self.fetchAuth(challengeID: routine.challengeID, completion: { challengAuth in
                let authState: ParticipationAuthState = challengAuth != nil ? .authenticated : .notAuthenticating
                self.participationAuthStates[idx] = authState
            })
        }
    }
}

extension HomeViewModel {
    func fetchMyHomeData() {
        fetchUser()
        fetchTodayRoutine()
        fetchAchievement(date: baseDate.value)
        updateContinuityDay()
    }

    func updateDate(month: Int) {
        let changedDate = calendar.date(byAdding: .month,
                                        value: month,
                                        to: baseDate.value) ?? Date()
        baseDate.value = month == 0 ? Date() : changedDate
        days.value = generateDaysInMonth(for: baseDate.value)
        fetchAchievement(date: baseDate.value)
    }

    func themeStyle() -> Int {
        return userFetchUsecase.fetchThemeStyle()
    }

    func didTappedTodayRoutine(index: Int) {
        let challengeID = todayRoutines.value[index].challengeID
        todayRoutineTap.send(challengeID)
    }

    func didTappedAddChallengeButton() {
        challengeAddButtonTap.send()
    }

    func didTappedTodayRoutineAuth(index: Int) {
        let challengeID = todayRoutines.value[index].challengeID
        todayRoutineAuthTap.send(challengeID)
    }

    func didTappedExplanationButton() {
        calendarExplanationButtonTap.send()
    }
}

extension HomeViewModel {
    enum CalendarDataError: Error {
        case metadataGenerationFailed
    }

    private func monthMetadata(for baseDate: Date) throws -> MonthMetadata {
        guard let numberOfDaysInMonth = calendar.range(of: .day, in: .month, for: baseDate)?.count,
              let firstDayOfMonth = calendar.date(from: calendar.dateComponents(
                [.year, .month],
                from: baseDate)
              ) else { throw CalendarDataError.metadataGenerationFailed }
        let firstDayWeekday = calendar.component(.weekday, from: firstDayOfMonth)

        return MonthMetadata(numberOfDays: numberOfDaysInMonth,
                             firstDay: firstDayOfMonth,
                             firstDayWeekday: firstDayWeekday)
    }

    private func generateDaysInMonth(for baseDate: Date) -> [Day] {
        guard let metadata = try? monthMetadata(for: baseDate) else { return [] }

        let numberOfDaysInMonth = metadata.numberOfDays
        let offsetInInitialRow = metadata.firstDayWeekday
        let firstDayOfMonth = metadata.firstDay

        var days: [Day] = (1..<(numberOfDaysInMonth + offsetInInitialRow)).map { day in
            let isWithinDisplayedMonth = day >= offsetInInitialRow
            let dayOffset = isWithinDisplayedMonth ? day - offsetInInitialRow : -(offsetInInitialRow - day)

            return generateDay(offsetBy: dayOffset,
                               for: firstDayOfMonth,
                               isWithinDisplayedMonth: isWithinDisplayedMonth)
        }

        days += generateStartOfNextMonth(using: firstDayOfMonth)

        return days
    }

    private func generateDay(offsetBy dayOffset: Int,
                             for baseDate: Date,
                             isWithinDisplayedMonth: Bool) -> Day {
        let date = calendar.date(byAdding: .day, value: dayOffset, to: baseDate) ?? baseDate
        let achievement = achievements.filter { "\($0.yearMonth)\($0.day)" == date.toDateString() }
        let achievementRate = Double(achievement.first?.achievementCount ?? 0) / Double(achievement.first?.totalCount ?? 0)

        return Day(date: date,
                   number: "\(date.day)",
                   isSelected: selectedDates.contains(date),
                   achievementRate: (achievement.count > 0 ? achievementRate : 0),
                   isWithinDisplayedMonth: isWithinDisplayedMonth
        )
    }

    private func generateStartOfNextMonth(using firstDayOfDisplayedMonth: Date) -> [Day] {
        guard let lastDayInMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1),
                                                 to: firstDayOfDisplayedMonth) else { return [] }

        let additionalDays = 7 - calendar.component(.weekday, from: lastDayInMonth)
        guard additionalDays > 0 else { return [] }

        let days: [Day] = (1...additionalDays).map {
            generateDay(offsetBy: $0, for: lastDayInMonth, isWithinDisplayedMonth: false)
        }

        return days
    }
}
