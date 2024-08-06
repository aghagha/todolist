//
//  UIView+Ext.swift
//  todolist
//
//  Created by Agha Maulana on 06/08/24.
//

import Foundation
import UIKit

public extension UIView {
    func set(superView: UIView, translatesAutoresizingMaskIntoConstraints: Bool = false) {
        superView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints
    }
    
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage: UIImage? = image?.withRenderingMode(.alwaysTemplate)
        image = templateImage
        tintColor = color
    }
}
