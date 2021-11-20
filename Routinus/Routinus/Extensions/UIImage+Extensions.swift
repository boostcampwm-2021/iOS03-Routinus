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
        guard size.width >= type.length else { return self }

        let width = type.length
        let scale = width / size.width
        let height = size.height * scale
        let size = CGSize(width: width, height: height)
        let render = UIGraphicsImageRenderer(size: size)

        return render.image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }

    func circularBackground(_ color: UIColor?) -> UIImage? {
        let circleDiameter = max((size.width * 2) - 10, (size.height * 2) - 10)
        let circleRadius = circleDiameter * 0.5
        let circleSize = CGSize(width: circleDiameter, height: circleDiameter)
        let circleFrame = CGRect(x: 0, y: 0, width: circleSize.width, height: circleSize.height)
        let imageFrame = CGRect(x: circleRadius - (size.width * 0.5), y: circleRadius - (size.height * 0.5),
                                width: size.width, height: size.height)

        let view = UIView(frame: circleFrame)
        view.backgroundColor = color ?? UIColor(named: "MainColor")
        view.layer.cornerRadius = circleDiameter * 0.5

        UIGraphicsBeginImageContextWithOptions(circleSize, false, UIScreen.main.scale)

        let renderer = UIGraphicsImageRenderer(size: circleSize)
        let circleImage = renderer.image { _ in
            view.drawHierarchy(in: circleFrame, afterScreenUpdates: true)
        }

        circleImage.draw(in: circleFrame, blendMode: .normal, alpha: 1.0)
        draw(in: imageFrame, blendMode: .normal, alpha: 1.0)

        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return image
    }
}
