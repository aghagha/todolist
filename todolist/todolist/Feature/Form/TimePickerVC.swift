//
//  TimePickerVC.swift
//  todolist
//
//  Created by Agha Maulana on 06/08/24.
//

import Foundation
import UIKit

class TimePickerVC: BasePickerVC {
    internal lazy var picker: UIPickerView = UIPickerView()
    
    internal var selectedHour, selectedMinute: Int?
    
    override func setupContentView() {
        super.setupContentView()
        setupDatePicker()
    }
    
    override func getTitle() -> String {
        return "Set time"
    }
    
    override func confirmClicked() {
        dismiss(animated: true) { [weak self] in
            var date: Date = Date()
            date = date.setTime(hour: self?.selectedHour ?? 0, minute: self?.selectedMinute ?? 0)
            self?.didSelectDate?(date)
        }
    }
}

extension TimePickerVC {
    private func setupDatePicker() {
        picker.delegate = self
        picker.dataSource = self
        
        picker.set(superView: contentView)
        NSLayoutConstraint.activate([
            picker.topAnchor.constraint(equalTo: contentView.topAnchor),
            picker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            picker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            picker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        guard let selectedHour = selectedHour, let selectedMinute = selectedMinute else {
            return
        }
        
        picker.selectRow(selectedHour, inComponent: 0, animated: true)
        picker.selectRow(selectedMinute, inComponent: 1, animated: true)
    }
}

extension TimePickerVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 24
        } else {
            return 60
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(format: "%02d", row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedHour = row
        } else {
            selectedMinute = row
        }
    }
}

