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
    internal lazy var timeToggle: UISwitch = UISwitch()
    internal lazy var timeField: UITextView = UITextView()
    
    internal var task: TaskModel?
    internal var didSaveTask: ((TaskModel) -> Void)?
    
    internal var router: Router = Router.shared
    
    internal var selectedDate: Date? {
        didSet {
            dateField.text = selectedDate?.formattedDateForDisplay ?? ""
            textViewDidChange(dateField)
        }
    }
    
    internal var isUsingTime: Bool = false {
        didSet {
            timeField.isHidden = !isUsingTime
        }
    }
    
    internal var selectedTime: Date? {
        didSet {
            guard let date = selectedTime else {
                return
            }
            timeField.text = date.timeFormatted
            textViewDidChange(timeField)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add New Task"
        setupView()
    }
}

extension CreateTaskVC {
    @objc func didToggleSwitch(sender: UISwitch) {
        isUsingTime = sender.isOn
    }
    
    @objc func cancelClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func confirmClicked() {
        guard titleField.text != nil, !titleField.text.isEmpty else {
            MySnackbar.show(in: self.view, message: "Title can't be empty", color: .systemRed)
            return
        }
        
        guard let date = selectedDate else {
            MySnackbar.show(in: self.view, message: "Date can't be empty", color: .systemRed)
            return
        }
        
        var taskModel: TaskModel = task ?? TaskModel()
        taskModel.title = titleField.text
        if let description = descriptionField.text {
            taskModel.description = description
        }
        taskModel.date = Calendar.current.startOfDay(for: date)
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
            }
        } else {
            router.presentTimePicker(from: self, selectedDate: selectedTime) { [weak self] selectedTime in
                guard let selectedTime = selectedTime else {
                    return
                }
                
                self?.timeField.resignFirstResponder()
                self?.selectedTime = selectedTime
            }
        }
        return false
    }
    
    func textViewDidChange(_ textView: UITextView) {
        adjustPlaceholderVisibility(of: textView)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        highlightToday(in: textView)
    }
    
    private func highlightToday(in textView: UITextView) {
        guard textView == titleField else {
            return
        }
        
        let keyword: String = "today"
        var text: String = ""
        if !textView.text.isEmpty {
            text = textView.text
            textView.text = nil
        } else if !textView.attributedText.string.isEmpty {
            text = textView.attributedText.string
        }
        
        let fullRange: NSRange = NSRange(location: 0, length: text.count)
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.font, value: textView.font!, range: fullRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: fullRange)
        
        let regex = try! NSRegularExpression(pattern: keyword, options: [])
        let matches = regex.matches(in: text.lowercased(), options: [], range: fullRange)
        
        for match in matches {
            let range = match.range
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.white,
                .backgroundColor: UIColor.purple
            ]
            attributedString.addAttributes(attributes, range: range)
        }
        
        textView.attributedText = attributedString
        selectedDate = Date.localDate()
        adjustPlaceholderVisibility(of: textView)
    }
    
    private func adjustPlaceholderVisibility(of textView: UITextView) {
        guard let placeholderLabel = textView.subviews.first(where: { $0.tag == -1 }) else {
             return
        }
        placeholderLabel.isHidden = !textView.text.isEmpty || !textView.attributedText.string.isEmpty
    }
}
