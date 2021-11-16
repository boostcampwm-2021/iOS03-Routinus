//
//  RoutinusImageManager.swift
//  RoutinusImageManager
//
//  Created by 유석환 on 2021/11/15.
//

import Foundation

public enum RoutinusImageManager {
    public static func isExist(in directory: String, filename: String) -> Bool {
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                             .userDomainMask,
                                                             true).first else { return false }

        var url = URL(fileURLWithPath: path)
        url.appendPathComponent("\(directory)_\(filename)")
        url.appendPathExtension("jpeg")

        return FileManager.default.fileExists(atPath: url.path)
    }

    public static func cachedFilenames() -> [String] {
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                             .userDomainMask,
                                                             true).first else { return [] }

        let url = URL(fileURLWithPath: path)
        return (try? FileManager.default.contentsOfDirectory(atPath: url.path)) ?? []
    }

    // TODO: 제대로 동작하는지 테스트 필요
    public static func cachedImageData(from directory: String, filename: String) -> Data? {
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                             .userDomainMask,
                                                             true).first else { return nil }

        var url = URL(fileURLWithPath: path)
        url.appendPathComponent("\(directory)_\(filename)")
        url.appendPathExtension("jpeg")

        return try? Data(contentsOf: url)
    }

    // TODO: 제대로 동작하는지 테스트 필요
    public static func cachedImageURL(from directory: String, filename: String) -> String {
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                             .userDomainMask,
                                                             true).first else { return "" }

        var url = URL(fileURLWithPath: path)
        url.appendPathComponent("\(directory)_\(filename)")
        url.appendPathExtension("jpeg")

        return url.absoluteString
    }

    @discardableResult
    public static func saveImage(to directory: String, filename: String, imageData: Data?) -> String? {
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

    public static func removeTempCachedImages() {
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                             .userDomainMask,
                                                             true).first else { return }

        let url = URL(fileURLWithPath: path)
        let filenames = cachedFilenames()
            .filter{ $0.hasPrefix("temp") && $0.hasSuffix(".jpeg") }

        for filename in filenames {
            var url = url
            url.appendPathComponent(filename)

            try? FileManager.default.removeItem(atPath: url.path)
        }
    }
}

// TODO: 개발 완료 후 삭제(개발/테스트용으로 작성된 메소드)
extension RoutinusImageManager {
    // TODO: 제대로 동작하는지 테스트 필요
    public static func removeAllCachedImages() {
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                             .userDomainMask,
                                                             true).first else { return }

        let url = URL(fileURLWithPath: path)
        let filenames = cachedFilenames()
            .filter{ $0.hasSuffix(".jpeg") }

        for filename in filenames {
            var url = url
            url.appendPathComponent(filename)

            try? FileManager.default.removeItem(atPath: url.path)
        }
    }
}
