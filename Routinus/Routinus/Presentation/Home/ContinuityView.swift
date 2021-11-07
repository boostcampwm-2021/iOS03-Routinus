//
//  ContinuityView.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/07.
//

import UIKit

import SnapKit

final class ContinuityView: UIView {
    private lazy var seedImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "seed")
        imageView.isHidden = true
        return imageView
    }()

    private lazy var initContinuityLabel: UILabel = {
        let label = UILabel()
        label.text = "시작이 반이다"
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.isHidden = true
        return label
    }()

    private lazy var continuityDayLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.boldSystemFont(ofSize: 48)
        label.isHidden = true
        return label
    }()

    private lazy var continuityInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "일 연속 달성"
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    func configureContinuityLabel(userInfo: User) {
        guard !userInfo.name.isEmpty else { return }
        if userInfo.continuityDay == 0 {
            self.seedImage.isHidden = true
            self.initContinuityLabel.isHidden = false
            self.continuityDayLabel.isHidden = true
            self.continuityInfoLabel.isHidden = true
        } else {
            self.seedImage.isHidden = false
            self.initContinuityLabel.isHidden = true
            self.continuityDayLabel.isHidden = false
            self.continuityInfoLabel.isHidden = false
            self.continuityDayLabel.text = String(userInfo.continuityDay)
        }
    }
}

private extension ContinuityView {
    func configure() {
        configureLayout()
        configureSubviews()
    }
    
    func configureLayout() {
        layer.borderWidth = 1
        layer.cornerRadius = 5
    }
    
    func configureSubviews() {
        addSubview(seedImage)
        seedImage.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }

        addSubview(self.initContinuityLabel)
        initContinuityLabel.snp.makeConstraints { make in
            make.leading.equalTo(seedImage.snp.trailing).offset(20)
            make.centerY.equalToSuperview()
        }

        addSubview(self.continuityDayLabel)
        continuityDayLabel.snp.makeConstraints { make in
            make.leading.equalTo(seedImage.snp.trailing).offset(20)
            make.centerY.equalToSuperview()
        }

        addSubview(self.continuityInfoLabel)
        continuityInfoLabel.snp.makeConstraints { make in
            make.leading.equalTo(continuityDayLabel.snp.trailing).offset(5)
            make.lastBaseline.equalTo(continuityDayLabel.snp.lastBaseline).offset(-2)
        }
    }
}
