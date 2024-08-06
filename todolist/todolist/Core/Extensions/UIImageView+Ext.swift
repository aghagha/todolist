//
//  UIImageView+Ext.swift
//  todolist
//
//  Created by Agha Maulana on 06/08/24.
//

import Foundation
import UIKit

extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage: UIImage? = image?.withRenderingMode(.alwaysTemplate)
        image = templateImage
        tintColor = color
    }
}
