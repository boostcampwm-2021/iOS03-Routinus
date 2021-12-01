//
//  ImageRepository.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/17.
//

import Foundation

protocol ImageRepository {
    func fetchImageData(from directory: String, filename: String, completion: ((Data?) -> Void)?)
    func saveImage(to directory: String, filename: String, data: Data?) -> String?
    func updateImage(challengeID: String,
                     imageURL: String,
                     thumbnailImageURL: String,
                     completion: @escaping (() -> Void))
    func updateImage(challengeID: String,
                     authExampleImageURL: String,
                     authExampleThumbnailImageURL: String,
                     completion: @escaping (() -> Void))
}

extension RoutinusRepository: ImageRepository {
    func fetchImageData(from directory: String,
                        filename: String,
                        completion: ((Data?) -> Void)? = nil) {
        if ImageManager.isExist(in: directory, filename: filename) {
            ImageManager.cachedImageData(from: directory, filename: filename) { data in
                completion?(data)
            }
        } else {
            FirebaseService.imageData(from: directory, filename: filename) { data in
                ImageManager.saveImage(to: directory, filename: filename, imageData: data)
                completion?(data)
            }
        }
    }

    func saveImage(to directory: String, filename: String, data: Data?) -> String? {
        return ImageManager.saveImage(to: directory, filename: filename, imageData: data)
    }

    func updateImage(challengeID: String,
                     imageURL: String,
                     thumbnailImageURL: String,
                     completion: @escaping (() -> Void)) {

        let updateQueue = DispatchQueue(label: "updateQueue")
        let group = DispatchGroup()

        group.enter()
        updateQueue.async(group: group) {
            FirebaseService.uploadImage(id: challengeID, filename: "image", imageURL: imageURL) {
                group.leave()
            }
        }

        group.enter()
        updateQueue.async(group: group) {
            FirebaseService.uploadImage(id: challengeID,
                                        filename: "thumbnail_image",
                                        imageURL: thumbnailImageURL) {
                group.leave()
            }
        }

        group.notify(queue: DispatchQueue.main) {
            ImageManager.removeCachedImages(from: challengeID)
            completion()
        }
    }

    func updateImage(challengeID: String,
                     authExampleImageURL: String,
                     authExampleThumbnailImageURL: String,
                     completion: @escaping (() -> Void)) {

        let updateQueue = DispatchQueue(label: "updateQueue")
        let group = DispatchGroup()

        group.enter()
        updateQueue.async(group: group) {
            FirebaseService.uploadImage(id: challengeID,
                                        filename: "auth_method",
                                        imageURL: authExampleImageURL) {
                group.leave()
            }
        }

        group.enter()
        updateQueue.async(group: group) {
            FirebaseService.uploadImage(id: challengeID,
                                        filename: "thumbnail_auth_method",
                                        imageURL: authExampleThumbnailImageURL) {
                group.leave()
            }
        }

        group.notify(queue: DispatchQueue.main) {
            ImageManager.removeCachedImages(from: challengeID)
            completion()
        }
    }
}
