//
//  RoutinusDatabase.swift
//  RoutinusDatabase
//
//  Created by 유석환 on 2021/11/02.
//

import Foundation

public enum RoutinusDatabase {
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

    public static func createUser(id: String,
                                  name: String,
                                  completion: (() -> Void)?) {
        guard let url = URL(string: "\(firestoreURL)/user") else {
            completion?()
            return
        }
        var request = URLRequest(url: url)
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = RoutinusQuery.createUserQuery(id: id, name: name)

        URLSession.shared.dataTask(with: request) { _, _, _ in
            completion?()
        }.resume()
    }

    public static func createChallenge(challenge: ChallengeDTO,
                                       imageURL: String,
                                       thumbnailImageURL: String,
                                       authExampleImageURL: String,
                                       authExampleThumbnailImageURL: String,
                                       completion: (() -> Void)?) {
        insertChallenge(dto: challenge, completion: nil)
        insertChallengeParticipation(dto: challenge, completion: nil)

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

    public static func insertChallenge(dto: ChallengeDTO,
                                       completion: (() -> Void)?) {
        guard let url = URL(string: "\(firestoreURL)/challenge"),
              let document = dto.document?.fields else { return }
        var request = URLRequest(url: url)
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = RoutinusQuery.insertChallengeQuery(document: document)

        URLSession.shared.dataTask(with: request) { _, _, _ in
            completion?()
        }.resume()
    }

    public static func insertChallengeParticipation(dto: ChallengeDTO,
                                                    completion: (() -> Void)?) {
        guard let url = URL(string: "\(firestoreURL)/challenge_participation"),
              let document = dto.document?.fields else { return }
        var request = URLRequest(url: url)
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = RoutinusQuery.insertChallengeParticipationQuery(document: document)

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
        request.httpBody = RoutinusQuery.userQuery(of: id)

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
        request.httpBody = RoutinusQuery.routinesQuery(userID: id)

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data,
                  let participations = try? JSONDecoder().decode([ParticipationDTO].self,
                                                                 from: data) else { return }
            var todayRoutines = [TodayRoutineDTO]()
            completion?(todayRoutines) // TODO: fetch 로직 수정해야 함

//            let fetchQueue = DispatchQueue(label: "fetchQueue")
//            let group = DispatchGroup()
//
//            fetchQueue.async(group: group) {
//                for participation in participations {
//                    guard let challengeID = participation.document?.fields.challengeID.stringValue else { continue }
//                    request.httpBody = RoutinusQuery.routinesQuery(challengeID: challengeID)
//
//                    URLSession.shared.dataTask(with: request) { data, _, _ in
//                        guard let data = data,
//                              let challenge = try? JSONDecoder().decode([ChallengeDTO].self,
//                                                                        from: data).first else { return }
//                        let todayRoutine = TodayRoutineDTO(participation: participation,
//                                                           challenge: challenge)
//                        todayRoutines.append(todayRoutine)
//                    }.resume()
//                }
//            }
//
//            group.notify(queue: fetchQueue) {
//                completion?(todayRoutines)
//            }
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
        request.httpBody = RoutinusQuery.achievementQuery(of: id, in: yearMonth)

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { return }
            let list = try? JSONDecoder().decode([AchievementDTO].self, from: data)
            completion?(list ?? [])
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
        request.httpBody = RoutinusQuery.allChallengesQuery()

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
        request.httpBody = RoutinusQuery.newChallengeQuery()

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
        request.httpBody = RoutinusQuery.recommendChallengeQuery()

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { return }
            let list = try? JSONDecoder().decode([ChallengeDTO].self, from: data)
            completion?(list ?? [])
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
        request.httpBody = RoutinusQuery.searchChallenges(ownerID: ownerID)

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { return }
            let list = try? JSONDecoder().decode([ChallengeDTO].self, from: data)
            completion?(list ?? [])
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
        request.httpBody = RoutinusQuery.searchChallenges(categoryID: categoryID)

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
        request.httpBody = RoutinusQuery.challenge(ownerID: ownerID, challengeID: challengeID)

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
        request.httpBody = RoutinusQuery.challenge(challengeID: challengeID)

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { return }
            let dto = try? JSONDecoder().decode([ChallengeDTO].self, from: data).first
            completion(dto ?? ChallengeDTO())
        }.resume()
    }

    public static func patchChallenge(challengeDTO: ChallengeDTO,
                                      imageURL: String,
                                      thumbnailImageURL: String,
                                      authExampleImageURL: String,
                                      authExampleThumbnailImageURL: String,
                                      completion: (() -> Void)?) {
        updateChallenge(challengeDTO: challengeDTO, completion: nil)

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
            request.httpBody = RoutinusQuery.updateChallenge(document: challengeField)

            URLSession.shared.dataTask(with: request) { _, _, _ in
                completion?()
            }.resume()
        }
    }
}
