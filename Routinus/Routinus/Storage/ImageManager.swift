//
//  ImageManager.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/29.
//

import Foundation

enum ImageManager {
    static func isExist(in directory: String, filename: String) -> Bool {
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                             .userDomainMask,
                                                             true).first else { return false }

        var url = URL(fileURLWithPath: path)
        url.appendPathComponent("\(directory)_\(filename)")
        url.appendPathExtension("jpeg")

        return FileManager.default.fileExists(atPath: url.path)
    }

    static func cachedFilenames() -> [String] {
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                             .userDomainMask,
                                                             true).first else { return [] }

        let url = URL(fileURLWithPath: path)
        return (try? FileManager.default.contentsOfDirectory(atPath: url.path)) ?? []
    }

    static func cachedImageData(from directory: String,
                                       filename: String,
                                       completion: ((Data?) -> Void)? = nil) {
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                             .userDomainMask,
                                                             true).first else {
            completion?(nil)
            return
        }

        var url = URL(fileURLWithPath: path)
        url.appendPathComponent("\(directory)_\(filename)")
        url.appendPathExtension("jpeg")

        completion?(try? Data(contentsOf: url))
    }

    static func cachedImageURL(from directory: String, filename: String) -> String {
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                             .userDomainMask,
                                                             true).first else { return "" }

        var url = URL(fileURLWithPath: path)
        url.appendPathComponent("\(directory)_\(filename)")
        url.appendPathExtension("jpeg")

        return url.absoluteString
    }

    @discardableResult static func saveImage(to directory: String, filename: String, imageData: Data?) -> String? {
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                             .userDomainMask,
                                                             true).first else { return nil }

        var url = URL(fileURLWithPath: path)
        url.appendPathComponent("\(directory)_\(filename)")
        url.appendPathExtension("jpeg")

        return FileManager.default.createFile(atPath: url.path,
                                              contents: imageData,
                                              attributes: nil) ? url.absoluteString : nil
    }

    static func removeCachedImages(from directory: String) {
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                             .userDomainMask,
                                                             true).first else { return }

        let url = URL(fileURLWithPath: path)
        let filenames = cachedFilenames()
            .filter{ $0.hasPrefix(directory) && $0.hasSuffix(".jpeg") }

        for filename in filenames {
            var url = url
            url.appendPathComponent(filename)

            try? FileManager.default.removeItem(atPath: url.path)
        }
    }
}

// TODO: 개발 완료 후 삭제(개발/테스트용으로 작성된 메소드)
extension ImageManager {
    static func removeAllCachedImages() {
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                             .userDomainMask,
                                                             true).first else { return }

        let url = URL(fileURLWithPath: path)
        let filenames = cachedFilenames()
            .filter { $0.hasSuffix(".jpeg") }

        for filename in filenames {
            var url = url
            url.appendPathComponent(filename)

            try? FileManager.default.removeItem(atPath: url.path)
        }
    }
}
