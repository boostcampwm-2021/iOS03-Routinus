//
//  ParticipantButton.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/16.
//

import UIKit

final class ParticipantButton: UIButton {
    weak var delegate: ParticipantButtonDelegate?

    init() {
        super.init(frame: .zero)
        self.setTitle(ParticipationAuthState.notParticipating.rawValue, for: .normal)
        self.isEnabled = true
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
        delegate?.didTappedParticipantButton()
    }

    func update(to state: ParticipationAuthState) {
        self.isEnabled = state == .authenticated ? false : true
        let backgroundColor = isEnabled ? "MainColor" : "MainColor0.5"
        let titleColor = isEnabled ? "Black" : "DayColor"
        self.setTitle(state.rawValue.localized, for: .normal)
        self.backgroundColor = UIColor(named: backgroundColor)
        self.setTitleColor(UIColor(named: titleColor), for: .normal)
    }
}

protocol ParticipantButtonDelegate: AnyObject {
    func didTappedParticipantButton()
}
