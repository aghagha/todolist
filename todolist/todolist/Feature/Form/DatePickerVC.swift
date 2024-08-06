//
//  DatePickerVC.swift
//  todolist
//
//  Created by Agha Maulana on 06/08/24.
//

import Foundation
import UIKit

class DatePickerVC: BasePickerVC {
    internal lazy var datePicker: UICalendarView = UICalendarView()
    
    override func setupContentView() {
        super.setupContentView()
        setupDatePicker()
    }
    
    override func getTitle() -> String {
        return "Set date"
    }
}

extension DatePickerVC {
    private func setupDatePicker() {
        datePicker.set(superView: contentView)
        datePicker.calendar = Calendar(identifier: .gregorian)
        datePicker.tintColor = .systemBlue
        datePicker.timeZone = Calendar.current.timeZone
        
        let selection = UICalendarSelectionSingleDate(delegate: self)
        datePicker.selectionBehavior = selection
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: contentView.topAnchor),
            datePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        guard let selectedDate = selectedDate else {
            return
        }
        
        selection.selectedDate = Calendar.current.dateComponents([.day, .month, .year], from: selectedDate)
        datePicker.setVisibleDateComponents(selection.selectedDate!, animated: true)
    }
}

extension DatePickerVC: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        selectedDate = dateComponents?.date
    }
}
