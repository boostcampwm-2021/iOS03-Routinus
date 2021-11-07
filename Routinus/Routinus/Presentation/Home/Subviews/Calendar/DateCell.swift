//
//  DateCell.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/02.
//

import UIKit

import JTAppleCalendar
import SnapKit

final class DateCell: JTACDayCell {
    static let identifier = "DateCell"
    
    lazy var dateLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        return label
    }()

    lazy var selectedView: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(named: "MainColor")
        view.isHidden = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }
}

extension DateCell {
    private func configureViews() {
        contentView.addSubview(selectedView)
        contentView.addSubview(dateLabel)

        dateLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }

        selectedView.snp.makeConstraints { make in
            make.width.equalTo(contentView.snp.width)
            make.height.equalTo(contentView.snp.width)
            make.centerX.centerY.equalToSuperview()
        }
    }
}
