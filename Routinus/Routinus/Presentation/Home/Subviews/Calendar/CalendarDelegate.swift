//
//  CalendarDelegate.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/04.
//

import UIKit

import JTAppleCalendar

final class CalendarDelegate: JTACMonthViewDelegate {
    static let shared = CalendarDelegate()
    private init() {}
    var dummyCalendar: [AchievementInfo] = []
    var formatter: DateFormatter?

    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath)
    -> JTACDayCell {
        guard let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: DateCell.identifier, for: indexPath)
                as? DateCell else { return JTACDayCell() }
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }

    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date,
                  cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? DateCell else { return }
        configureCell(view: cell, cellState: cellState)
    }

    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date,
                  cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }

    func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date),
                  at indexPath: IndexPath) -> JTACMonthReusableView {
        guard let header = calendar.dequeueReusableJTAppleSupplementaryView(
                            withReuseIdentifier: DateHeader.identifier,
                            for: indexPath)
                as? DateHeader else { return JTACMonthReusableView() }
        header.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        return header
    }

    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        return MonthSize(defaultSize: 50)
    }

    private func configureCell(view: JTACDayCell?, cellState: CellState) {
        guard let cell = view as? DateCell  else { return }
        cell.dateLabel.text = cellState.text
        handleCellTextColor(cell: cell, cellState: cellState)
        handleCellSelected(cell: cell, cellState: cellState)
    }

    private func handleCellTextColor(cell: DateCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            switch cellState.day {
            case .saturday :
                cell.dateLabel.textColor = UIColor(named: "SaturdayColor")
            case .sunday :
                cell.dateLabel.textColor = UIColor(named: "SundayColor")
            default :
                cell.dateLabel.textColor = UIColor(named: "DayColor")
            }
        } else {
            cell.dateLabel.isHidden = true
        }
    }

    private func handleCellSelected(cell: DateCell, cellState: CellState) {
        if cellState.isSelected {
            cell.selectedView.layer.cornerRadius = cell.frame.width / 2
            cell.selectedView.isHidden = false
            handleCellAlpha(cell: cell, date: cellState.date)
        } else {
            cell.selectedView.isHidden = true
        }
    }

    private func handleCellAlpha(cell: DateCell, date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let dateString = dateFormatter.string(from: date)
        guard let dateData = dummyCalendar.filter({ "\($0.yearMonth)\($0.day)" == dateString }).first else { return }
        let date = "\(dateData.yearMonth)\(dateData.day)"
        let percentage = Double(dateData.achievementCount) / Double(dateData.totalCount)

        if dateString == date {
            cell.selectedView.alpha = percentage
        }
    }
}
