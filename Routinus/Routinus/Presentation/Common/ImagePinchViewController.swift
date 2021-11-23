//
//  ImagePinchViewController.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/23.
//

import UIKit

class ImagePinchViewController: UIViewController {
    private lazy var dimmedBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        return view
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "seed")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configurePinch()
    }

    func configureViews() {
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve

        view.addSubview(dimmedBackgroundView)
        dimmedBackgroundView.anchor(edges: view)
        view.addSubview(imageView)
        imageView.anchor(horizontal: view,
                         centerY: view.centerYAnchor)
    }

    func configurePinch() {
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(doPinch(_:)))
        view.addGestureRecognizer(pinch)
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
}
