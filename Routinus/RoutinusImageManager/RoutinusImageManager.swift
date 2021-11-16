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

    public static func cachedImageData(from directory: String, filename: String) -> Data? {
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                             .userDomainMask,
                                                             true).first else { return nil }

        var url = URL(fileURLWithPath: path)
        url.appendPathComponent("\(directory)_\(filename)")
        url.appendPathExtension("jpeg")

        return try? Data(contentsOf: url)
    }

    public static func cachedImageURL(from directory: String, filename: String) -> String {
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                             .userDomainMask,
                                                             true).first else { return "" }

        var url = URL(fileURLWithPath: path)
        url.appendPathComponent("\(directory)_\(filename)")
        url.appendPathExtension("jpeg")

        return url.absoluteString
    }
}
