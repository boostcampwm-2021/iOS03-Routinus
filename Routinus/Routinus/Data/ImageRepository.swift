//
//  ImageRepository.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/17.
//

import Foundation

import RoutinusDatabase
import RoutinusImageManager

protocol ImageRepository {
    func fetchImageData(from directory: String,
                        filename: String,
                        completion: ((Data?) -> Void)?)
    func saveImage(to directory: String,
                   filename: String,
                   data: Data?) -> String?
}

extension RoutinusRepository: ImageRepository {
    func fetchImageData(from directory: String,
                        filename: String,
                        completion: ((Data?) -> Void)? = nil) {
        if RoutinusImageManager.isExist(in: directory, filename: filename) {
            RoutinusImageManager.cachedImageData(from: directory, filename: filename) { data in
                completion?(data)
            }
        } else {
            RoutinusDatabase.imageData(from: directory, filename: filename) { data in
                RoutinusImageManager.saveImage(to: directory, filename: filename, imageData: data)
                completion?(data)
            }
        }
    }

    func saveImage(to directory: String,
                   filename: String,
                   data: Data?) -> String? {
        return RoutinusImageManager.saveImage(to: directory,
                                              filename: filename,
                                              imageData: data)
    }
}
