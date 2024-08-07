//
//  DeleteConfimationVC.swift
//  todolist
//
//  Created by Agha Maulana on 07/08/24.
//

import Foundation
import UIKit

class DeleteConfimationVC: UIViewController {
    internal lazy var container: UIView = UIView()
    internal lazy var titleLabel: UILabel = UILabel()
    internal lazy var subtitleLabel: UILabel = UILabel()
    internal lazy var contentView: UIView = UIView()
    
    internal var selectedDate: Date?
    internal var didDelete: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func getTitle() -> String {
        return "Delete"
    }
}

extension DeleteConfimationVC {
    private func setupView() {
        view.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.6)
        setupContainer()
        setupTitleLabel()
        setupSubtitleLabel()
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
        titleLabel.text = getTitle()
        titleLabel.font = .boldSystemFont(ofSize: 24)
        
        titleLabel.set(superView: view)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 32)
        ])
    }
    
    private func setupSubtitleLabel() {
        subtitleLabel.text = "Are you sure to delete?"
        subtitleLabel.font = .systemFont(ofSize: 18)
        
        subtitleLabel.set(superView: container)
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16)
        ])
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
                foregroundColor: .systemRed,
                backgroundColor: .white,
                action: #selector(cancelClicked))
        )
        
        stackView.addArrangedSubview(
            makeButton(
                title: "Delete",
                foregroundColor: .white,
                backgroundColor: .systemRed,
                action: #selector(confirmClicked))
        )
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 32),
            stackView.leadingAnchor.constraint(equalTo: subtitleLabel.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: subtitleLabel.trailingAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor, constant: -32)
        ])
        
        func makeButton(title: String, foregroundColor: UIColor, backgroundColor: UIColor, action: Selector) -> UIButton {
            let button: UIButton = UIButton()
            var configuration: UIButton.Configuration = .plain()
            configuration.background.backgroundColor = backgroundColor
            configuration.title = title
            configuration.baseForegroundColor = foregroundColor
            configuration.contentInsets = .init(top: 8, leading: 12, bottom: 8, trailing: 12)
            button.configuration = configuration
            button.layer.borderColor = UIColor.systemRed.cgColor
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
            self?.didDelete?()
        }
    }
}
