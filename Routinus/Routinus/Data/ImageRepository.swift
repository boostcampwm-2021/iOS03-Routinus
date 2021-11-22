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
}
