//
//  ImagePinchViewController.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/23.
//

import UIKit

final class ImagePinchViewController: UIViewController {
    private lazy var dimmedBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "Black")?.withAlphaComponent(0.8)
        return view
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private var imageData: Data? {
        didSet {
            fetchImage()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureGesture()
    }

    func updateImage(data: Data) {
        imageData = data
    }
}

extension ImagePinchViewController {
    private func configureViews() {
        view.addSubview(dimmedBackgroundView)
        dimmedBackgroundView.anchor(centerX: view.centerXAnchor,
                                    centerY: view.centerYAnchor,
                                    width: view.frame.width * 2,
                                    height: view.frame.height * 2)
        view.addSubview(imageView)
        imageView.anchor(centerX: view.centerXAnchor,
                         centerY: view.centerYAnchor,
                         width: UIScreen.main.bounds.width,
                         height: UIScreen.main.bounds.height)
    }

    private func configureGesture() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(doPan(_:)))
        pan.delegate = self
        view.addGestureRecognizer(pan)
    }

    @objc func doPan(_ pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: imageView)
        let centerX = imageView.center.x
        let centerY = imageView.center.y

        if let imageView = pan.view {
            imageView.center = CGPoint(x: imageView.center.x + translation.x,
                                       y: imageView.center.y + translation.y)
            let xDistance = imageView.center.x - centerX
            let yDistacne = imageView.center.y - centerY
            let distanceFromCenter = sqrt(xDistance * xDistance + yDistacne * yDistacne)
            dimmedBackgroundView.alpha = 0.9 -  (distanceFromCenter / 250)
        }
        pan.setTranslation(.zero, in: imageView)

        if pan.state == .ended {
            dismiss(animated: true)
        }
    }

    private func fetchImage() {
        guard let image = imageData else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.imageView.image = UIImage(data: image)
        }
    }
}

extension ImagePinchViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }
}
