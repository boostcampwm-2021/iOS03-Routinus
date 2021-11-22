//
//  UIView+Extensions.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/17.
//

import UIKit

public extension UIView {
    func anchor(leading: NSLayoutXAxisAnchor? = nil,
                paddingLeading: CGFloat = 0,
                trailing: NSLayoutXAxisAnchor? = nil,
                paddingTrailing: CGFloat = 0,
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

        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: paddingLeading).isActive = true
        }
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -paddingTrailing).isActive = true
        }
        if let centerX = centerX {
            centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        if let horizontal = horizontal {
            leadingAnchor.constraint(equalTo: horizontal.leadingAnchor, constant: paddingHorizontal).isActive = true
            trailingAnchor.constraint(equalTo: horizontal.trailingAnchor, constant: -paddingHorizontal).isActive = true
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
            leadingAnchor.constraint(equalTo: edges.leadingAnchor),
            topAnchor.constraint(equalTo: edges.topAnchor),
            trailingAnchor.constraint(equalTo: edges.trailingAnchor),
            bottomAnchor.constraint(equalTo: edges.bottomAnchor)
        ])
    }

    func anchor(edges: UIView?) {
        guard let edges = edges else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: edges.leadingAnchor),
            topAnchor.constraint(equalTo: edges.topAnchor),
            trailingAnchor.constraint(equalTo: edges.trailingAnchor),
            bottomAnchor.constraint(equalTo: edges.bottomAnchor)
        ])
    }

    func removeLastAnchor() {
        guard let lastConstraint = constraints.last else { return }
        removeConstraint(lastConstraint)
    }
}
