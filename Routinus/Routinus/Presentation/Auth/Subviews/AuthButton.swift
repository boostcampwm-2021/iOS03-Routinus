//
//  AuthButton.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/16.
//

import UIKit

final class AuthButton: UIButton {
    weak var delegate: AuthButtonDelegate?

    init() {
        super.init(frame: .zero)
        self.setTitle("certify".localized, for: .normal)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 26)
        self.setTitleColor(.black, for: .normal)
        self.backgroundColor = UIColor(named: "MainColor")
        self.layer.cornerRadius = 15
        self.addTarget(self, action: #selector(didTappedAuthButton), for: .touchUpInside)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    @objc func didTappedAuthButton() {
        delegate?.didTappedAuthButton()
    }

    func configureEnabled(isEnabled: Bool) {
        self.isEnabled = isEnabled
        let color = isEnabled ? "MainColor" : "MainColor0.5"
        self.backgroundColor = UIColor(named: color)
    }
}

protocol AuthButtonDelegate: AnyObject {
    func didTappedAuthButton()
}
