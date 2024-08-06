//
//  DatePickerVC.swift
//  todolist
//
//  Created by Agha Maulana on 06/08/24.
//

import Foundation
import UIKit

class DatePickerVC: UIViewController {
    internal lazy var container: UIView = UIView()
    internal lazy var titleLabel: UILabel = UILabel()
    internal lazy var datePicker: UICalendarView = UICalendarView()
    
    internal var selectedDate: Date?
    internal var didSelectDate: ((Date?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

extension DatePickerVC {
    private func setupView() {
        view.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.6)
        setupContainer()
        setupTitleLabel()
        setupDatePicker()
        setupButtons()
    }
    
    private func setupContainer() {
        container.backgroundColor = .white
        container.set(superView: view)
        container.clipsToBounds = true
        container.layer.cornerRadius = 16
        container.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: 16),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTitleLabel() {
        titleLabel.text = "Set Date"
        titleLabel.font = .boldSystemFont(ofSize: 24)
        
        titleLabel.set(superView: view)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 32)
        ])
    }
    
    private func setupDatePicker() {
        datePicker.set(superView: view)
        datePicker.calendar = Calendar(identifier: .gregorian)
        datePicker.tintColor = .systemBlue
        datePicker.timeZone = Calendar.current.timeZone
        
        let selection = UICalendarSelectionSingleDate(delegate: self)
        datePicker.selectionBehavior = selection
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            datePicker.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 32),
            datePicker.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -32)
        ])
        
        guard let selectedDate = selectedDate else {
            return
        }
        
        selection.selectedDate = Calendar.current.dateComponents([.day, .month, .year], from: selectedDate)
        datePicker.setVisibleDateComponents(selection.selectedDate!, animated: true)
    }
    
    private func setupButtons() {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        
        stackView.set(superView: container)
        stackView.addArrangedSubview(
            makeButton(
                title: "Cancel",
                foregroundColor: .systemBlue,
                backgroundColor: .white,
                action: #selector(cancelClicked))
        )
        
        stackView.addArrangedSubview(
            makeButton(
                title: "Save",
                foregroundColor: .white,
                backgroundColor: .systemBlue,
                action: #selector(confirmClicked))
        )
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 32),
            stackView.leadingAnchor.constraint(equalTo: datePicker.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: datePicker.trailingAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor, constant: -32),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        func makeButton(title: String, foregroundColor: UIColor, backgroundColor: UIColor, action: Selector) -> UIButton {
            let button: UIButton = UIButton()
            var configuration: UIButton.Configuration = .plain()
            configuration.background.backgroundColor = backgroundColor
            configuration.title = title
            configuration.baseForegroundColor = foregroundColor
            configuration.contentInsets = .init(top: 8, leading: 12, bottom: 8, trailing: 12)
            button.configuration = configuration
            button.layer.borderColor = UIColor.systemBlue.cgColor
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 4
            button.addTarget(self, action: action, for: .touchUpInside)
            
            return button
        }
    }
    
    @objc func cancelClicked() {
        dismiss(animated: true)
    }
    
    @objc func confirmClicked() {
        dismiss(animated: true) { [weak self] in
            self?.didSelectDate?(self?.selectedDate)
        }
    }
}

extension DatePickerVC: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        selectedDate = dateComponents?.date
    }
}
