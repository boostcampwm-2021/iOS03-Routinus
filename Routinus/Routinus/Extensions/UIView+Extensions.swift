//
//  UIView+Extensions.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/17.
//

import UIKit

public extension UIView {
    func anchor(left: NSLayoutXAxisAnchor? = nil,
                paddingLeft: CGFloat = 0,
                right: NSLayoutXAxisAnchor? = nil,
                paddingRight: CGFloat = 0,
                centerX: NSLayoutXAxisAnchor? = nil,
                horizontal: UIView? = nil,
                paddingHorizontal: CGFloat = 0,
                top: NSLayoutYAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                bottom: NSLayoutYAxisAnchor? = nil,
                paddingBottom: CGFloat = 0,
                centerY: NSLayoutYAxisAnchor? = nil,
                vertical: UIView? = nil,
                paddingVertical: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false

        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if let centerX = centerX {
            centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        if let horizontal = horizontal {
            leftAnchor.constraint(equalTo: horizontal.leftAnchor, constant: paddingHorizontal).isActive = true
            rightAnchor.constraint(equalTo: horizontal.rightAnchor, constant: -paddingHorizontal).isActive = true
        }
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        if let centerY = centerY {
            centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
        if let vertical = vertical {
            topAnchor.constraint(equalTo: vertical.topAnchor, constant: paddingVertical).isActive = true
            bottomAnchor.constraint(equalTo: vertical.bottomAnchor, constant: -paddingVertical).isActive = true
        }
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }

    func anchor(edges: UILayoutGuide) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftAnchor.constraint(equalTo: edges.leftAnchor),
            topAnchor.constraint(equalTo: edges.topAnchor),
            rightAnchor.constraint(equalTo: edges.rightAnchor),
            bottomAnchor.constraint(equalTo: edges.bottomAnchor)
        ])
    }

    func anchor(edges: UIView?) {
        guard let edges = edges else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftAnchor.constraint(equalTo: edges.leftAnchor),
            topAnchor.constraint(equalTo: edges.topAnchor),
            rightAnchor.constraint(equalTo: edges.rightAnchor),
            bottomAnchor.constraint(equalTo: edges.bottomAnchor)
        ])
    }

    func removeLastAnchor() {
        guard let lastConstraint = constraints.last else { return }
        removeConstraint(lastConstraint)
    }
}
