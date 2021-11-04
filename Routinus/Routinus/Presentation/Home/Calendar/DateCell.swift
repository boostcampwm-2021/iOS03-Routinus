//
//  DateCell.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/02.
//

import JTAppleCalendar
import SnapKit
import UIKit

class DateCell: JTACDayCell {
    lazy var dateLabel = UILabel()
    lazy var selectedView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        baseUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        baseUI()
    }

    private func baseUI() {
        dateLabel.textAlignment = .center
        selectedView.backgroundColor = UIColor(named: "MainColor")
        selectedView.isHidden = true

        contentView.addSubview(selectedView)
        contentView.addSubview(dateLabel)

        dateLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }

        selectedView.snp.makeConstraints { make in
            make.width.equalTo(self.contentView.snp.width)
            make.height.equalTo(self.contentView.snp.width)
            make.centerX.centerY.equalToSuperview()
        }
    }
}
