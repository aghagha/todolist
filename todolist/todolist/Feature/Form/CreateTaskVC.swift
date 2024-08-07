//
//  CreateTaskVC.swift
//  todolist
//
//  Created by Agha Maulana on 06/08/24.
//

import Foundation
import UIKit

class CreateTaskVC: UIViewController {
    internal lazy var scrollView: UIScrollView = UIScrollView()
    internal lazy var container: UIView = UIView()
    
    internal lazy var titleField: UITextView = UITextView()
    internal lazy var descriptionField: UITextView = UITextView()
    internal lazy var descriptionPlaceholderLabel : UILabel = UILabel()
    internal lazy var dateField: UITextView = UITextView()
    internal lazy var timeField: UITextView = UITextView()
    
    internal var didSaveTask: ((TaskModel) -> Void)?
    
    internal var router: Router = Router.shared
    
    private var selectedDate: Date? {
        didSet {
            dateField.text = selectedDate?.formattedDateForDisplay ?? ""
        }
    }
    
    private var isUsingTime: Bool = false {
        didSet {
            timeField.isHidden = !isUsingTime
        }
    }
    
    private var selectedTime: Date? {
        didSet {
            guard let date = selectedTime else {
                return
            }
            timeField.text = date.timeFormatted
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add New Task"
        setupView()
    }
}

extension CreateTaskVC {
    private func setupView() {
        view.backgroundColor = .white
        setupScrollView()
        setupTitleField()
        setupDescriptionField()
        setupDateField()
        setupTimeField()
        setupButtons()
    }
    
    private func setupScrollView() {
        scrollView.set(superView: view)
        scrollView.showsVerticalScrollIndicator = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        container.set(superView: scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: container.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            container.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    private func setupTitleField() {
        let label: UILabel = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.text = "Title"
        label.set(superView: container)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 32),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -32)
        ])
        
        titleField.set(superView: container)
        titleField.isUserInteractionEnabled = true
        titleField.delegate = self
        titleField.textContainer.maximumNumberOfLines = 1
        titleField.textContainer.lineBreakMode = .byTruncatingTail
        titleField.backgroundColor = .systemGray6
        titleField.layer.cornerRadius = 8
        titleField.font = .systemFont(ofSize: 18)
        titleField.textContainerInset = UIEdgeInsets(top: 16, left: 14, bottom: 16, right: 14)
        
        NSLayoutConstraint.activate([
            titleField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
            titleField.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            titleField.trailingAnchor.constraint(equalTo: label.trailingAnchor),
            titleField.heightAnchor.constraint(equalToConstant: 54)
        ])
        
        setupPlaceholderLabel(to: titleField, placeholder: "Title text")
    }
    
    private func setupDescriptionField() {
        let label: UILabel = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.text = "Description"
        label.set(superView: container)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 24),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 32),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -32)
        ])
        
        descriptionField.delegate = self
        descriptionField.set(superView: container)
        descriptionField.textContainer.maximumNumberOfLines = 3
        descriptionField.textContainer.lineBreakMode = .byTruncatingTail
        descriptionField.font = .systemFont(ofSize: 18)
        descriptionField.textContainerInset = UIEdgeInsets(top: 16, left: 14, bottom: 16, right: 14)
        descriptionField.isScrollEnabled = false
        
        descriptionField.isUserInteractionEnabled = true
        descriptionField.backgroundColor = .systemGray6
        descriptionField.layer.cornerRadius = 8
        
        NSLayoutConstraint.activate([
            descriptionField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
            descriptionField.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            descriptionField.trailingAnchor.constraint(equalTo: label.trailingAnchor),
            descriptionField.heightAnchor.constraint(equalToConstant: 98)
        ])
        
        setupPlaceholderLabel(to: descriptionField, placeholder: "Description text")
    }
    
    private func setupPlaceholderLabel(to textView: UITextView, placeholder: String, leadingPadding: CGFloat = 16) {
        let placeholderLabel: UILabel = UILabel()
        placeholderLabel.tag = -1
        placeholderLabel.text = placeholder
        
        textView.addSubview(placeholderLabel)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        placeholderLabel.textColor = .tertiaryLabel
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: 16),
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: leadingPadding)
        ])
    }
    
    private func setupDateField() {
        let label: UILabel = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.text = "Date"
        label.set(superView: container)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: descriptionField.bottomAnchor, constant: 24),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 32),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -32)
        ])
        
        dateField.delegate = self
        dateField.set(superView: container)
        dateField.textContainer.maximumNumberOfLines = 1
        dateField.textContainer.lineBreakMode = .byTruncatingTail
        dateField.font = .systemFont(ofSize: 18)
        dateField.textContainerInset = UIEdgeInsets(top: 16, left: 46, bottom: 16, right: 14)
        dateField.isScrollEnabled = false
        
        dateField.isUserInteractionEnabled = true
        dateField.backgroundColor = .systemGray6
        dateField.layer.cornerRadius = 8
        
        NSLayoutConstraint.activate([
            dateField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
            dateField.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            dateField.trailingAnchor.constraint(equalTo: label.trailingAnchor),
            dateField.heightAnchor.constraint(equalToConstant: 54)
        ])
        
        setupCalendarIcon()
        setupPlaceholderLabel(to: dateField, placeholder: "Select Date", leadingPadding: 48)
        
        func setupCalendarIcon() {
            let imageView: UIImageView = UIImageView(image: UIImage(systemName: "calendar"))
            imageView.setImageColor(color: .tertiaryLabel)
            
            imageView.set(superView: dateField)
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: dateField.topAnchor, constant: 16),
                imageView.leadingAnchor.constraint(equalTo: dateField.leadingAnchor, constant: 16),
                imageView.widthAnchor.constraint(equalToConstant: 24)
            ])
        }
    }
    
    private func setupTimeField() {
        let imageView: UIImageView = UIImageView(image: UIImage(systemName: "stopwatch"))
        imageView.setImageColor(color: .tertiaryLabel)
        imageView.contentMode = .scaleAspectFill
        imageView.set(superView: container)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: dateField.bottomAnchor, constant: 24),
            imageView.leadingAnchor.constraint(equalTo: dateField.leadingAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 24)
        ])
        
        let label: UILabel = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.text = "Time"
        label.set(superView: container)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16)
        ])
        
        let toggle: UISwitch = UISwitch()
        toggle.isOn = false
        toggle.onTintColor = .systemBlue
        toggle.addTarget(self, action: #selector(didToggleSwitch(sender:)), for: .valueChanged)
        toggle.set(superView: container)
        
        NSLayoutConstraint.activate([
            toggle.trailingAnchor.constraint(equalTo: dateField.trailingAnchor),
            toggle.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            toggle.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        timeField.set(superView: container)
        timeField.delegate = self
        timeField.textContainer.maximumNumberOfLines = 1
        timeField.textContainer.lineBreakMode = .byTruncatingTail
        timeField.font = .systemFont(ofSize: 18)
        timeField.textContainerInset = UIEdgeInsets(top: 16, left: 14, bottom: 16, right: 14)
        timeField.isScrollEnabled = false
        
        timeField.isUserInteractionEnabled = true
        timeField.backgroundColor = .systemGray6
        timeField.layer.cornerRadius = 8
        
        NSLayoutConstraint.activate([
            timeField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
            timeField.leadingAnchor.constraint(equalTo: dateField.leadingAnchor),
            timeField.trailingAnchor.constraint(equalTo: dateField.trailingAnchor)
        ])
        
        setupPlaceholderLabel(to: timeField, placeholder: "Set time")
        timeField.isHidden = true
        
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
            stackView.topAnchor.constraint(greaterThanOrEqualTo: timeField.bottomAnchor, constant: 32),
            stackView.leadingAnchor.constraint(equalTo: dateField.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: dateField.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32)
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
    
    @objc func didToggleSwitch(sender: UISwitch) {
        isUsingTime = sender.isOn
    }
    
    @objc func cancelClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func confirmClicked() {
        guard titleField.text != nil, let date = selectedDate else {
            // show toast
            return
        }
        
        var taskModel: TaskModel = TaskModel()
        taskModel.title = titleField.text
        if let description = descriptionField.text {
            taskModel.description = description
        }
        taskModel.date = date.toLocalDate()
        if isUsingTime, let hour = selectedTime?.hour, let minute = selectedTime?.minute {
            taskModel.date = taskModel.date.setTime(hour: hour, minute: minute)
        }
        taskModel.hasTime = isUsingTime
        navigationController?.popViewController(animated: true) { [weak self] in
            self?.didSaveTask?(taskModel)
        }
    }
}

extension CreateTaskVC: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        guard textView == dateField || textView == timeField else {
            return true
        }
        
        if textView == dateField {
            router.presentDatePicker(from: self, selectedDate: selectedDate) { [weak self] selectedDate in
                guard let selectedDate = selectedDate else {
                    return
                }
                self?.dateField.resignFirstResponder()
                self?.selectedDate = selectedDate
                self?.textViewDidChange(textView)
            }
        } else {
            router.presentTimePicker(from: self, selectedDate: selectedTime) { [weak self] selectedTime in
                guard let selectedTime = selectedTime else {
                    return
                }
                
                self?.timeField.resignFirstResponder()
                self?.selectedTime = selectedTime
                self?.textViewDidChange(textView)
            }
        }
        return false
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let placeholderLabel = textView.subviews.first(where: { $0.tag == -1 }) else {
             return
        }
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
