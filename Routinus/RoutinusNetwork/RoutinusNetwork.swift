//
//  RoutinusNetwork.swift
//  RoutinusNetwork
//
//  Created by 유석환 on 2021/11/02.
//

import Foundation

public enum RoutinusNetwork {
    private enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case patch = "PATCH"
    }

    private static let firestoreURL = "https://firestore.googleapis.com/v1/projects/boostcamp-ios03-routinus/databases/(default)/documents"
    private static let storageURL = "https://firebasestorage.googleapis.com/v0/b/boostcamp-ios03-routinus.appspot.com/o"

    public static func imageURL(id: String,
                                filename: String) -> URL? {
        return URL(string: "\(storageURL)/\(id)%2F\(filename).jpeg?alt=media")
    }

    public static func insertUser(id: String,
                                  name: String,
                                  completion: (() -> Void)?) {
        guard let url = URL(string: "\(firestoreURL)/user") else {
            completion?()
            return
        }
        var request = URLRequest(url: url)
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = UserQuery.insert(id: id, name: name)

        URLSession.shared.dataTask(with: request) { _, _, _ in
            completion?()
        }.resume()
    }

    public static func insertChallenge(challenge: ChallengeDTO,
                                       participation: ParticipationDTO,
                                       imageURL: String,
                                       thumbnailImageURL: String,
                                       authExampleImageURL: String,
                                       authExampleThumbnailImageURL: String,
                                       completion: (() -> Void)?) {
        insertChallenge(dto: challenge, completion: nil)
        insertChallengeParticipation(dto: participation, completion: nil)

        let uploadQueue = DispatchQueue(label: "uploadQueue")
        let group = DispatchGroup()

        uploadQueue.async(group: group) {
            let id = challenge.document?.fields.id.stringValue ?? ""
            uploadImage(id: id,
                        filename: "image",
                        imageURL: imageURL,
                        completion: nil)
            uploadImage(id: id,
                        filename: "thumbnail_image",
                        imageURL: thumbnailImageURL,
                        completion: nil)
            uploadImage(id: id,
                        filename: "auth",
                        imageURL: authExampleImageURL,
                        completion: nil)
            uploadImage(id: id,
                        filename: "thumbnail_auth",
                        imageURL: authExampleThumbnailImageURL,
                        completion: nil)
        }

        group.notify(queue: uploadQueue) {
            completion?()
        }
    }

    public static func insertChallengeAuth(challengeAuth: ChallengeAuthDTO,
                                           userAuthImageURL: String,
                                           userAuthThumbnailImageURL: String,
                                           completion: @escaping () -> Void) {
        insertChallengeAuth(dto: challengeAuth)

        let uploadQueue = DispatchQueue(label: "uploadQueue")
        let group = DispatchGroup()

        uploadQueue.async(group: group) {
            let id = challengeAuth.document?.fields.challengeID.stringValue ?? ""
            uploadImage(id: id,
                        filename: "userAuth",
                        imageURL: userAuthImageURL,
                        completion: nil)
            uploadImage(id: id,
                        filename: "thumbnail_userAuth",
                        imageURL: userAuthThumbnailImageURL,
                        completion: nil)
        }

        group.notify(queue: uploadQueue) {
            completion()
        }
    }

    public static func insertChallenge(dto: ChallengeDTO,
                                       completion: (() -> Void)?) {
        guard let url = URL(string: "\(firestoreURL)/challenge"),
              let document = dto.document?.fields else { return }
        var request = URLRequest(url: url)
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = ChallengeQuery.insert(document: document)

        URLSession.shared.dataTask(with: request) { _, _, _ in
            completion?()
        }.resume()
    }

    public static func insertChallengeParticipation(dto: ParticipationDTO,
                                                    completion: (() -> Void)? = nil) {
        guard let url = URL(string: "\(firestoreURL)/challenge_participation"),
              let document = dto.document?.fields else { return }
        var request = URLRequest(url: url)
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = ParticipationQuery.insert(document: document)

        URLSession.shared.dataTask(with: request) { _, _, _ in
            completion?()
        }.resume()
    }

    public static func insertChallengeAuth(dto: ChallengeAuthDTO,
                                           completion: (() -> Void)? = nil) {
        guard let url = URL(string: "\(firestoreURL)/challenge_auth"),
              let document = dto.document?.fields else { return }
        var request = URLRequest(url: url)

        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = AuthQuery.insert(document: document)

        URLSession.shared.dataTask(with: request) { _, _, _ in
            completion?()
        }.resume()
    }

    public static func uploadImage(id: String,
                                   filename: String,
                                   imageURL: String,
                                   completion: (() -> Void)?) {
        guard let url = URL(string: "\(storageURL)?uploadType=media&name=\(id)%2F\(filename).jpeg"),
              let imageURL = URL(string: imageURL) else { return }
        var request = URLRequest(url: url)
        request.addValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = try? Data(contentsOf: imageURL)

        URLSession.shared.dataTask(with: request) { _, _, _ in
            completion?()
        }.resume()
    }

    public static func imageData(from id: String,
                                 filename: String,
                                 completion: ((Data?) -> Void)?) {
        guard let url = imageURL(id: id, filename: filename) else {
            completion?(nil)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue

        URLSession.shared.dataTask(with: request) { data, _, _ in
            completion?(data)
        }.resume()
    }

    public static func user(of id: String,
                            completion: ((UserDTO) -> Void)?) {
        guard let url = URL(string: "\(firestoreURL):runQuery") else {
            completion?(UserDTO())
            return
        }
        var request = URLRequest(url: url)
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = UserQuery.select(id: id)

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { return }
            let dto = try? JSONDecoder().decode([UserDTO].self, from: data).first
            completion?(dto ?? UserDTO())
        }.resume()
    }

    public static func routines(of id: String,
                                completion: (([TodayRoutineDTO]) -> Void)?) {
        guard let url = URL(string: "\(firestoreURL):runQuery") else {
            completion?([])
            return
        }
        var request = URLRequest(url: url)
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = ParticipationQuery.select(userID: id)

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data,
                  let participations = try? JSONDecoder().decode([ParticipationDTO].self,
                                                                 from: data) else { return }
            var todayRoutines = [TodayRoutineDTO]()

            let fetchQueue = DispatchQueue(label: "fetchQueue")
            let group = DispatchGroup()

            for participation in participations {
                group.enter()
                guard let challengeID = participation.document?.fields.challengeID.stringValue else { continue }
                request.httpBody = ChallengeQuery.select(challengeID: challengeID)

                URLSession.shared.dataTask(with: request) { data, _, _ in
                    guard let data = data,
                          let challenge = try? JSONDecoder().decode([ChallengeDTO].self,
                                                                    from: data).first else { return }
                    let todayRoutine = TodayRoutineDTO(participation: participation,
                                                       challenge: challenge)
                    todayRoutines.append(todayRoutine)
                    group.leave()
                }.resume()
            }

            group.notify(queue: fetchQueue) {
                todayRoutines.sort { $0.challengeID > $1.challengeID }
                completion?(todayRoutines)
                todayAchievement(of: id,
                                 totalCount: todayRoutines.count,
                                 completion: nil)
            }
        }.resume()
    }

    public static func todayAchievement(of id: String,
                                        totalCount: Int,
                                        completion: (() -> Void)?) {
        guard let url = URL(string: "\(firestoreURL):runQuery") else { return }

        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        guard let year = dateComponents.year,
              let month = dateComponents.month,
              let day = dateComponents.day else { return }
        let yearMonthString = "\(year)\(String(format: "%02d", month))"
        let dayString = String(format: "%02d", day)

        var request = URLRequest(url: url)
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = AchievementQuery.select(id: id,
                                                   yearMonth: yearMonthString,
                                                   day: dayString)

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data,
                  let dto = try? JSONDecoder().decode([AchievementDTO].self, from: data).first else { return }
            if dto.document == nil {
                insertAchievement(of: id,
                                  yearMonth: yearMonthString,
                                  day: dayString,
                                  totalCount: totalCount,
                                  completion: nil)
            }
        }.resume()
    }

    public static func insertAchievement(of id: String,
                                         yearMonth: String,
                                         day: String,
                                         totalCount: Int,
                                         completion: (() -> Void)?) {
        guard let url = URL(string: "\(firestoreURL)/achievement") else {
            completion?()
            return
        }
        var request = URLRequest(url: url)
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = AchievementQuery.insert(id: id,
                                                   yearMonth: yearMonth,
                                                   day: day,
                                                   totalCount: "\(totalCount)")

        URLSession.shared.dataTask(with: request) { _, _, _ in
            completion?()
        }.resume()
    }

    public static func achievements(of id: String,
                                    in yearMonth: String,
                                    completion: (([AchievementDTO]) -> Void)?) {
        guard let url = URL(string: "\(firestoreURL):runQuery") else {
            completion?([])
            return
        }
        var request = URLRequest(url: url)
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = AchievementQuery.select(id: id,
                                                   yearMonth: yearMonth)

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { return }
            let list = try? JSONDecoder().decode([AchievementDTO].self, from: data)
            completion?(list ?? [])
        }.resume()
    }

    public static func achievement(userID: String,
                                   yearMonth: String,
                                   day: String,
                                   completion: @escaping (AchievementDTO?) -> Void) {
        guard let url = URL(string: "\(firestoreURL):runQuery") else { return }
        var request = URLRequest(url: url)
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = AchievementQuery.select(id: userID,
                                                   yearMonth: yearMonth,
                                                   day: day)

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { return }
            let dto = try? JSONDecoder().decode([AchievementDTO].self, from: data).first
            completion(dto ?? nil)
        }.resume()
    }

    public static func latestChallenges(completion: (([ChallengeDTO]) -> Void)?) {
        guard let url = URL(string: "\(firestoreURL):runQuery") else {
            completion?([])
            return
        }
        var request = URLRequest(url: url)
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = ChallengeQuery.selectOrderByParticipantCount(ascending: true,
                                                                        limit: 50)

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { return }
            let list = try? JSONDecoder().decode([ChallengeDTO].self, from: data)
            completion?(list ?? [])
        }.resume()
    }

    public static func newChallenges(completion: (([ChallengeDTO]) -> Void)?) {
        guard let url = URL(string: "\(firestoreURL):runQuery") else {
            completion?([])
            return
        }
        var request = URLRequest(url: url)
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = ChallengeQuery.selectOrderByStartDate()

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { return }
            let list = try? JSONDecoder().decode([ChallengeDTO].self, from: data)
            completion?(list ?? [])
        }.resume()
    }

    public static func recommendChallenges(completion: (([ChallengeDTO]) -> Void)?) {
        guard let url = URL(string: "\(firestoreURL):runQuery") else {
            completion?([])
            return
        }
        var request = URLRequest(url: url)
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = ChallengeQuery.selectOrderByParticipantCount(ascending: false,
                                                                        limit: 5)

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { return }
            let list = try? JSONDecoder().decode([ChallengeDTO].self, from: data)
            if list?.first?.document != nil {
                completion?(list ?? [])
            }
        }.resume()
    }

    public static func searchChallenges(ownerID: String,
                                        completion: (([ChallengeDTO]) -> Void)?) {
        guard let url = URL(string: "\(firestoreURL):runQuery") else {
            completion?([])
            return
        }
        var request = URLRequest(url: url)
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = ChallengeQuery.select(ownerID: ownerID)

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { return }
            let list = try? JSONDecoder().decode([ChallengeDTO].self, from: data)
            if list?.first?.document != nil {
                completion?(list ?? [])
            }
        }.resume()
    }

    public static func searchChallenges(participantID: String,
                                        completion: (([ChallengeDTO]) -> Void)?) {
        guard let url = URL(string: "\(firestoreURL):runQuery") else {
            completion?([])
            return
        }
        var request = URLRequest(url: url)
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = ParticipationQuery.select(userID: participantID)

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data,
                let participations = try? JSONDecoder().decode([ParticipationDTO].self,
                                                               from: data) else { return }

            var challenges = [ChallengeDTO]()
            let fetchQueue = DispatchQueue(label: "fetchQueue")
            let group = DispatchGroup()

            for participation in participations {
                group.enter()
                guard let challengeID = participation.document?.fields.challengeID.stringValue else { continue }
                request.httpBody = ChallengeQuery.select(challengeID: challengeID)

                URLSession.shared.dataTask(with: request) { data, _, _ in
                    guard let data = data,
                        let challenge = try? JSONDecoder().decode([ChallengeDTO].self,
                                                                  from: data).first else { return }
                    challenges.append(challenge)
                    group.leave()
                }.resume()
            }

            group.notify(queue: fetchQueue) {
                completion?(challenges)
            }
        }.resume()
    }

    public static func searchChallenges(categoryID: String,
                                        completion: (([ChallengeDTO]) -> Void)?) {
        guard let url = URL(string: "\(firestoreURL):runQuery") else {
            completion?([])
            return
        }
        var request = URLRequest(url: url)
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = ChallengeQuery.select(categoryID: categoryID)

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { return }
            let list = try? JSONDecoder().decode([ChallengeDTO].self, from: data)
            completion?(list ?? [])
        }.resume()
    }

    public static func challenge(ownerID: String,
                                 challengeID: String,
                                 completion: ((ChallengeDTO) -> Void)?) {
        guard let url = URL(string: "\(firestoreURL):runQuery") else {
            completion?(ChallengeDTO())
            return
        }
        var request = URLRequest(url: url)
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = ChallengeQuery.select(ownerID: ownerID,
                                                 challengeID: challengeID)

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { return }
            let dto = try? JSONDecoder().decode([ChallengeDTO].self, from: data).first
            completion?(dto ?? ChallengeDTO())
        }.resume()
    }

    public static func challenge(challengeID: String,
                                 completion: @escaping (ChallengeDTO) -> Void) {
        guard let url = URL(string: "\(firestoreURL):runQuery") else { return }
        var request = URLRequest(url: url)
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = ChallengeQuery.select(challengeID: challengeID)

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { return }
            let dto = try? JSONDecoder().decode([ChallengeDTO].self, from: data).first
            completion(dto ?? ChallengeDTO())
        }.resume()
    }

    public static func challengeParticipation(userID: String,
                                              challengeID: String,
                                              completion: @escaping (ParticipationDTO?) -> Void) {
        guard let url = URL(string: "\(firestoreURL):runQuery") else { return }
        var request = URLRequest(url: url)
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = ParticipationQuery.select(userID: userID,
                                                     challengeID: challengeID)

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { return }
            let dto = try? JSONDecoder().decode([ParticipationDTO].self, from: data).first
            completion(dto ?? nil)
        }.resume()
    }

    public static func patchChallenge(challengeDTO: ChallengeDTO,
                                      imageURL: String,
                                      thumbnailImageURL: String,
                                      authExampleImageURL: String,
                                      authExampleThumbnailImageURL: String,
                                      completion: (() -> Void)?) {
        updateChallenge(challengeDTO: challengeDTO,
                        completion: nil)

        let patchQueue = DispatchQueue(label: "patchQueue")
        let group = DispatchGroup()

        patchQueue.async(group: group) {
            let id = challengeDTO.document?.fields.id.stringValue ?? ""
            uploadImage(id: id,
                        filename: "image",
                        imageURL: imageURL,
                        completion: nil)
            uploadImage(id: id,
                        filename: "thumbnail_image",
                        imageURL: thumbnailImageURL,
                        completion: nil)
            uploadImage(id: id,
                        filename: "auth",
                        imageURL: authExampleImageURL,
                        completion: nil)
            uploadImage(id: id,
                        filename: "thumbnail_auth",
                        imageURL: authExampleImageURL,
                        completion: nil)
        }

        group.notify(queue: patchQueue) {
            completion?()
        }
    }

    public static func updateContinuityDay(of id: String,
                                           completion: (() -> Void)?) {
        user(of: id) { dto in
            guard let document = dto.document,
                  let grade = Int(document.fields.grade.integerValue),
                  let continuityDay = Int(document.fields.continuityDay.integerValue),
                  let lastAuthDay = Int(document.fields.lastAuthDay.stringValue) else { return }

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            guard let date = Int(dateFormatter.string(from: Date())),
                  lastAuthDay < date else { return }

            let name = document.fields.name.stringValue
            let userImageCategoryID = document.fields.userImageCategoryID.stringValue

            let userDTO = UserDTO(id: id,
                                  name: name,
                                  grade: grade,
                                  continuityDay: continuityDay + 1,
                                  userImageCategoryID: userImageCategoryID,
                                  lastAuthDay: "\(date)")

            guard let userField = userDTO.document?.fields else { return }
            let documentID = dto.documentID ?? ""
            var urlComponent = URLComponents(string: "\(firestoreURL)/user/\(documentID)?")
            let queryItems = [
                URLQueryItem(name: "updateMask.fieldPaths", value: "continuity_day"),
                URLQueryItem(name: "updateMask.fieldPaths", value: "last_auth_day")
            ]
            urlComponent?.queryItems = queryItems

            guard let url = urlComponent?.url else { return }
            var request = URLRequest(url: url)
            request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
            request.httpMethod = HTTPMethod.patch.rawValue
            request.httpBody = UserQuery.update(document: userField)

            URLSession.shared.dataTask(with: request) { _, _, _ in
                completion?()
            }.resume()
        }
    }

    public static func updateChallenge(challengeDTO: ChallengeDTO,
                                       completion: (() -> Void)?) {
        guard let ownerID = challengeDTO.document?.fields.ownerID.stringValue,
              let challengeID = challengeDTO.document?.fields.id.stringValue,
              let challengeField = challengeDTO.document?.fields else { return }

        challenge(ownerID: ownerID, challengeID: challengeID) { dto in
            let documentID = dto.documentID ?? ""
            var urlComponent = URLComponents(string: "\(firestoreURL)/challenge/\(documentID)?")
            let queryItems = [
                URLQueryItem(name: "updateMask.fieldPaths", value: "auth_method"),
                URLQueryItem(name: "updateMask.fieldPaths", value: "category_id"),
                URLQueryItem(name: "updateMask.fieldPaths", value: "title"),
                URLQueryItem(name: "updateMask.fieldPaths", value: "desc"),
                URLQueryItem(name: "updateMask.fieldPaths", value: "week"),
                URLQueryItem(name: "updateMask.fieldPaths", value: "end_date")
            ]
            urlComponent?.queryItems = queryItems

            guard let url = urlComponent?.url else { return }
            var request = URLRequest(url: url)
            request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
            request.httpMethod = HTTPMethod.patch.rawValue
            request.httpBody = ChallengeQuery.update(document: challengeField)

            URLSession.shared.dataTask(with: request) { _, _, _ in
                completion?()
            }.resume()
        }
    }

    public static func updateChallengeParticipationAuthCount(challengeID: String,
                                                             userID: String,
                                                             completion: (() -> Void)?) {
        challengeParticipation(userID: userID, challengeID: challengeID) { dto in
            guard let dto = dto,
                  let document = dto.document,
                  let authCount = Int(document.fields.authCount.integerValue) else { return }

            let joinDate = document.fields.joinDate.stringValue
            let participationDTO = ParticipationDTO(authCount: authCount + 1,
                                                    challengeID: challengeID,
                                                    joinDate: joinDate,
                                                    userID: userID)

            guard let participationField = participationDTO.document?.fields else { return }
            let documentID = dto.documentID ?? ""
            var urlComponent = URLComponents(string: "\(firestoreURL)/challenge_participation/\(documentID)?")
            let queryItems = [
                URLQueryItem(name: "updateMask.fieldPaths", value: "auth_count")
            ]
            urlComponent?.queryItems = queryItems

            guard let url = urlComponent?.url else { return }
            var request = URLRequest(url: url)
            request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
            request.httpMethod = HTTPMethod.patch.rawValue
            request.httpBody = ParticipationQuery.update(document: participationField)

            URLSession.shared.dataTask(with: request) { _, _, _ in
                completion?()
            }.resume()
        }
    }

    public static func challengeAuth(todayDate: String,
                                     userID: String,
                                     challengeID: String,
                                     completion: @escaping (ChallengeAuthDTO?) -> Void) {
        guard let url = URL(string: "\(firestoreURL):runQuery") else { return }
        var request = URLRequest(url: url)

        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = AuthQuery.select(userID: userID,
                                            challengeID: challengeID,
                                            todayDate: todayDate)

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { return }
            let dto = try? JSONDecoder().decode([ChallengeAuthDTO].self, from: data).first
            completion(dto)
        }.resume()
    }

    public static func updateAchievementCount(userID: String,
                                              yearMonth: String,
                                              day: String,
                                              completion: (() -> Void)?) {
        achievement(userID: userID, yearMonth: yearMonth, day: day) { dto in
            guard let dto = dto,
                  let document = dto.document,
                  let achievementCount = Int(document.fields.achievementCount.integerValue),
                  let totalCount = Int(document.fields.totalCount.integerValue) else { return }

            let achievementDTO = AchievementDTO(totalCount: totalCount,
                                                day: day,
                                                userID: userID,
                                                achievementCount: achievementCount + 1,
                                                yearMonth: yearMonth)

            guard let achievementField = achievementDTO.document?.fields else { return }
            let documentID = dto.documentID ?? ""
            var urlComponent = URLComponents(string: "\(firestoreURL)/achievement/\(documentID)?")
            let queryItems = [
                URLQueryItem(name: "updateMask.fieldPaths", value: "achievement_count")
            ]
            urlComponent?.queryItems = queryItems

            guard let url = urlComponent?.url else { return }
            var request = URLRequest(url: url)
            request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
            request.httpMethod = HTTPMethod.patch.rawValue
            request.httpBody = AchievementQuery.update(document: achievementField)

            URLSession.shared.dataTask(with: request) { _, _, _ in
                completion?()
            }.resume()
        }
    }

    public static func updateParticipantCount(challengeID: String,
                                                completion: (() -> Void)?) {
        challenge(challengeID: challengeID) { dto in
            guard let document = dto.document,
                  let week = Int(document.fields.week.integerValue),
                  let participationCount = Int(document.fields.participantCount.integerValue) else { return }

            let title = document.fields.title.stringValue
            let authMethod = document.fields.authMethod.stringValue
            let categoryID = document.fields.categoryID.stringValue
            let desc = document.fields.desc.stringValue
            let startDate = document.fields.startDate.stringValue
            let endDate = document.fields.endDate.stringValue
            let ownerID = document.fields.ownerID.stringValue

            let challengeDTO = ChallengeDTO(id: challengeID,
                                            title: title,
                                            authMethod: authMethod,
                                            categoryID: categoryID,
                                            week: week,
                                            desc: desc,
                                            startDate: startDate,
                                            endDate: endDate,
                                            participantCount: participationCount + 1,
                                            ownerID: ownerID)

            guard let challengeField = challengeDTO.document?.fields, let documentID = dto.documentID else { return }
            var urlComponent = URLComponents(string: "\(firestoreURL)/challenge/\(documentID)?")
            let queryItems = [
                URLQueryItem(name: "updateMask.fieldPaths", value: "participant_count")
            ]
            urlComponent?.queryItems = queryItems

            guard let url = urlComponent?.url else { return }
            var request = URLRequest(url: url)
            request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
            request.httpMethod = HTTPMethod.patch.rawValue
            request.httpBody = ChallengeQuery.updateParticipantCount(document: challengeField)

            URLSession.shared.dataTask(with: request) { _, _, _ in
                completion?()
            }.resume()
        }
    }
}
