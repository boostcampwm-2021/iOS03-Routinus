//
//  ImageFetchableUsecaseMock.swift
//  RoutinusTests
//
//  Created by 박상우 on 2021/11/30.
//

import XCTest
@testable import Routinus

class ImageFetchableUsecaseMock: ImageFetchableUsecase {
    func fetchImageData(from directory: String, filename: String, completion: ((Data?) -> Void)?) {
        completion?(Data())
    }
}
