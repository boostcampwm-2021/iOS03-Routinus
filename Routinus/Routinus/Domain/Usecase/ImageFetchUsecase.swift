//
//  ImageFetchUsecase.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/17.
//

import Foundation

import RoutinusDatabase

protocol ImageFetchableUsecase {
    func fetchImageData(from directory: String,
                        filename: String,
                        completion: ((Data?) -> Void)?)
}

struct ImageFetchUsecase: ImageFetchableUsecase {
    var repository: ImageRepository

    init(repository: ImageRepository) {
        self.repository = repository
    }

    func fetchImageData(from directory: String,
                        filename: String,
                        completion: ((Data?) -> Void)? = nil) {
        repository.fetchImageData(from: directory, filename: filename) { data in
            completion?(data)
        }
    }
}
