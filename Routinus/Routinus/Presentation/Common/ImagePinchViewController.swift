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
        view.backgroundColor = .black.withAlphaComponent(0.6)
        return view
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private var imageData: Data?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configurePinch()

        fetchImage()
    }

    private func configureViews() {
        view.addSubview(dimmedBackgroundView)
        dimmedBackgroundView.anchor(centerX: view.centerXAnchor,
                                    centerY: view.centerYAnchor,
                                    width: view.frame.width * 2,
                                    height: view.frame.height * 2)
        view.addSubview(imageView)
        imageView.anchor(horizontal: view,
                         centerY: view.centerYAnchor)
    }

    private func configurePinch() {
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(doPinch(_:)))
        pinch.delegate = self
        view.addGestureRecognizer(pinch)

        let pan = UIPanGestureRecognizer(target: self, action: #selector(doPan(_:)))
        pan.delegate = self
        view.addGestureRecognizer(pan)
    }

    func setImage(data: Data) {
        imageData = data
    }

    func fetchImage() {
        guard let image = self.imageData else { return }
        self.imageView.image = UIImage(data: image)
    }
}

extension ImagePinchViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    @objc private func doPinch(_ pinch: UIPinchGestureRecognizer) {
        if pinch.state == .began || pinch.state == .changed {
            let currentScale = imageView.frame.width / imageView.bounds.size.width
            var newScale = currentScale * pinch.scale

            newScale = newScale < 0.5
                       ? 0.5
                       : newScale > 4
                            ? 4
                            : newScale
            let transform = CGAffineTransform(scaleX: newScale, y: newScale)
            imageView.transform = transform
            pinch.scale = 1
        }
    }

    @objc func doPan(_ pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: imageView)
        let currentScale = imageView.frame.width / imageView.bounds.size.width
        if let imageView = pan.view {
            imageView.center = CGPoint(x: imageView.center.x + translation.x,
                                       y: imageView.center.y + translation.y)
        }
        pan.setTranslation(.zero, in: imageView)

        if currentScale <= 1 && pan.state == .ended {
            self.dismiss(animated: true)
        }
    }
}
