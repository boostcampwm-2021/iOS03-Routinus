//
//  ImageRepository.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/17.
//

import Foundation

import RoutinusNetwork
import RoutinusStorage

protocol ImageRepository {
    func fetchImageData(from directory: String,
                        filename: String,
                        completion: ((Data?) -> Void)?)
    func saveImage(to directory: String,
                   filename: String,
                   data: Data?) -> String?
    func updateImage(challengeID: String,
                     imageURL: String,
                     thumbnailImageURL: String)
    func updateImage(challengeID: String,
                     authExampleImageURL: String,
                     authExampleThumbnailImageURL: String)
}

extension RoutinusRepository: ImageRepository {
    func fetchImageData(from directory: String,
                        filename: String,
                        completion: ((Data?) -> Void)? = nil) {
        if RoutinusStorage.isExist(in: directory, filename: filename) {
            RoutinusStorage.cachedImageData(from: directory, filename: filename) { data in
                completion?(data)
            }
        } else {
            RoutinusNetwork.imageData(from: directory, filename: filename) { data in
                RoutinusStorage.saveImage(to: directory, filename: filename, imageData: data)
                completion?(data)
            }
        }
    }

    func saveImage(to directory: String,
                   filename: String,
                   data: Data?) -> String? {
        return RoutinusStorage.saveImage(to: directory,
                                         filename: filename,
                                         imageData: data)
    }

    func updateImage(challengeID: String,
                     imageURL: String,
                     thumbnailImageURL: String) {
        RoutinusNetwork.uploadImage(id: challengeID,
                                    filename: "image",
                                    imageURL: imageURL,
                                    completion: nil)
        RoutinusNetwork.uploadImage(id: challengeID,
                                    filename: "thumbnail_image",
                                    imageURL: thumbnailImageURL,
                                    completion: nil)
        RoutinusStorage.removeCachedImages(from: challengeID)
    }

    func updateImage(challengeID: String,
                     authExampleImageURL: String,
                     authExampleThumbnailImageURL: String) {
        RoutinusNetwork.uploadImage(id: challengeID,
                                    filename: "auth",
                                    imageURL: authExampleImageURL,
                                    completion: nil)
        RoutinusNetwork.uploadImage(id: challengeID,
                                    filename: "thumbnail_auth",
                                    imageURL: authExampleThumbnailImageURL,
                                    completion: nil)
        RoutinusStorage.removeCachedImages(from: challengeID)
    }
}
