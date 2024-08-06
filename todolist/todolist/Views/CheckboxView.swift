//
//  CheckboxView.swift
//  todolist
//
//  Created by Agha Maulana on 06/08/24.
//

import Foundation
import UIKit

class CheckboxView: UIView {
    internal lazy var checkMark: UIImageView = UIImageView(image: UIImage(systemName: "checkmark.square.fill"))
    internal var size: CGFloat = 24
    
    internal var didSelect: ((Bool) -> Void)?
    
    internal var isSelected: Bool = false {
        didSet {
            checkMark.setImageColor(color: isSelected ? .systemBlue : .white)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonClicked)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
}

extension CheckboxView {
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 2
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemBlue.cgColor
        
        checkMark.set(superView: self)
        
        let offMargin: CGFloat = 4
        NSLayoutConstraint.activate([
            checkMark.topAnchor.constraint(equalTo: topAnchor, constant: -offMargin),
            checkMark.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -offMargin),
            checkMark.trailingAnchor.constraint(equalTo: trailingAnchor, constant: offMargin),
            checkMark.bottomAnchor.constraint(equalTo: bottomAnchor, constant: offMargin),
            checkMark.widthAnchor.constraint(equalToConstant: size),
            checkMark.heightAnchor.constraint(equalToConstant: size)
        ])
    }
    
    @objc func buttonClicked(_ sender: Any) {
        isSelected.toggle()
        didSelect?(isSelected)
    }
}
