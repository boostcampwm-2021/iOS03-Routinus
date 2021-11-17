//
//  ImageSaveUsecase.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/17.
//

import Foundation

protocol ImageSavableUsecase {
    func saveImage(to directory: String,
                   filename: String,
                   data: Data?) -> String?
}

struct ImageSaveUsecase: ImageSavableUsecase {
    var repository: ImageRepository

    init(repository: ImageRepository) {
        self.repository = repository
    }

    func saveImage(to directory: String,
                   filename: String,
                   data: Data?) -> String? {
        return repository.saveImage(to: directory,
                                    filename: filename,
                                    data: data)
    }
}
