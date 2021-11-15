//
//  RoutinusImageManager.swift
//  RoutinusImageManager
//
//  Created by 유석환 on 2021/11/15.
//

import Foundation

public class RoutinusImageManager {
    public static let shared = RoutinusImageManager()

    private let fileManager = FileManager.default
    private var path: String?

    private init() {
        if let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                          .userDomainMask,
                                                          true).first {
            self.path = path
        }
    }

    public func isExist(in directory: String, fileName: String) -> Bool {
        guard let path = path else { return false }

        var url = URL(fileURLWithPath: path)
        url.appendPathComponent("\(directory)/\(fileName).jpeg")

        return fileManager.fileExists(atPath: url.path)
    }
    
    public func saveImage(to directory: String, fileName: String, imageData: Data) {
        guard let path = path else { return }

        var url = URL(fileURLWithPath: path)
        url.appendPathComponent("\(directory)/\(fileName).jpeg")

        fileManager.createFile(atPath: url.path,
                               contents: imageData,
                               attributes: nil)
    }

    public func cachedImageData(from directory: String, fileName: String) -> Data? {
        guard let path = path else { return nil }

        var url = URL(fileURLWithPath: path)
        url.appendPathComponent("\(directory)/\(fileName).jpeg")

        return try? Data(contentsOf: url)
    }

    public func cachedImageURL(from directory: String, fileName: String) -> URL? {
        guard let path = path else { return nil }

        var url = URL(fileURLWithPath: path)
        url.appendPathComponent("\(directory)/\(fileName).jpeg")
        
        return url
    }
}
