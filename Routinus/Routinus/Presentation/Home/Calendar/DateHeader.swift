//
//  DateHeader.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/02.
//

import UIKit
import SnapKit
import JTAppleCalendar

class DateHeader: JTACMonthReusableView {
    static let identifier = "month"
    let dateHeader = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        baseUI()
    }

    private func baseUI() {
        dateHeader.textAlignment = .center
        dateHeader.font = .systemFont(ofSize: 20, weight: .medium)
        self.addSubview(dateHeader)
        dateHeader.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
