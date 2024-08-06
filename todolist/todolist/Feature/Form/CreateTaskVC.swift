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
        label.font = .boldSystemFont(ofSize: 20)
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
        label.font = .boldSystemFont(ofSize: 20)
        label.text = "Description"
        label.set(superView: container)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 32),
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
            descriptionField.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            descriptionField.heightAnchor.constraint(equalToConstant: 98)
        ])
        
        setupPlaceholderLabel(to: descriptionField, placeholder: "Description text")
    }
    
    private func setupPlaceholderLabel(to textView: UITextView, placeholder: String) {
        let placeholderLabel: UILabel = UILabel()
        placeholderLabel.tag = -1
        placeholderLabel.text = placeholder
        
        textView.addSubview(placeholderLabel)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        placeholderLabel.textColor = .tertiaryLabel
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: 16),
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 16)
        ])
    }
    
    private func setupDateField() {
        
    }
    
    private func setupTimeField() {
        
    }
}

extension CreateTaskVC: UITextFieldDelegate {
    
}

extension CreateTaskVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let placeholderLabel = textView.subviews.first(where: { $0.tag == -1 }) else {
             return
        }
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
