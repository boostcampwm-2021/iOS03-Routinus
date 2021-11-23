//
//  UIImage+Extension.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/10.
//

import UIKit

extension UIImage {
    enum RoutinusImageType {
        case original
        case thumbnail

        var length: CGFloat {
            switch self {
            case .original:
                return CGFloat(200.0)
            case .thumbnail:
                return CGFloat(80.0)
            }
        }
    }

    func resizedImage(_ type: RoutinusImageType) -> UIImage {
        let isWidthLongerThanHeight = size.width > size.height
        guard (isWidthLongerThanHeight ? size.width : size.height) >= type.length else { return self }

        let longerSide = type.length
        let scale = longerSide / (isWidthLongerThanHeight ? size.width : size.height)
        let shorterSide = (isWidthLongerThanHeight ? size.height : size.width) * scale
        let size = CGSize(width: (isWidthLongerThanHeight ? longerSide : shorterSide),
                          height: (isWidthLongerThanHeight ? shorterSide : longerSide))
        let render = UIGraphicsImageRenderer(size: size)

        return render.image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }

    func insertText(name: String, date: String, time: String) -> UIImage {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(self.size, false, scale)

        let label = UILabel(frame: CGRect(origin: .zero, size: self.size))
        label.backgroundColor = UIColor.clear
        label.textAlignment = .center
        label.numberOfLines = 2
        label.textColor = .white.withAlphaComponent(0.5)
        label.font = UIFont.boldSystemFont(ofSize: 200)
        label.text = "\(name)\n\(date) \(time)"

        let imageView = UIImageView(image: self)
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
        imageView.layer.render(in: context)
        label.layer.render(in: context)
        guard let imageWithText = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()

        return imageWithText
    }
}
