//
//  TaskCell.swift
//  todolist
//
//  Created by Agha Maulana on 06/08/24.
//

import Foundation
import UIKit

class TaskCell: UITableViewCell {
    internal lazy var containerView: UIView = UIView()
    internal lazy var checkbox: UIView = UIView()
    internal lazy var stackView: UIStackView = UIStackView()
    internal lazy var titleLabel: UILabel = UILabel()
    internal lazy var timeLabel: UILabel = UILabel()
    
    internal var task: TaskModel? {
        didSet {
            titleLabel.text = task?.title
            if task?.hasTime ?? false {
                timeLabel.text = task?.date.timeFormatted
            } else {
                timeLabel.text = ""
            }
            timeLabel.isHidden = !(task?.hasTime ?? false)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not supported")
    }
}

extension TaskCell {
    private func setupView() {
        selectionStyle = .none
        setupContainer()
        setupCheckbox()
        setupStackView()
    }
    
    private func setupContainer() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 4
        // set shadow later
        containerView.set(superView: contentView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    private func setupCheckbox() {
        checkbox.set(superView: containerView)
        checkbox.backgroundColor = .systemBlue
        checkbox.layer.cornerRadius = 4
        
        NSLayoutConstraint.activate([
            checkbox.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            checkbox.heightAnchor.constraint(equalToConstant: 24),
            checkbox.widthAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    private func setupStackView() {
        stackView.set(superView: containerView)
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 4
        
        stackView.addArrangedSubview(titleLabel)
        titleLabel.font = .boldSystemFont(ofSize: 16)
        
        stackView.addArrangedSubview(timeLabel)
        timeLabel.font = .systemFont(ofSize: 14)
        timeLabel.textColor = .systemBlue
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 16),
            stackView.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: checkbox.topAnchor, constant: -4)
        ])
    }
}
