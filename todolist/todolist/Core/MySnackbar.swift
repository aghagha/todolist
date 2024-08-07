//
//  MySnackbar.swift
//  todolist
//
//  Created by Agha Maulana on 07/08/24.
//

import Foundation
import SnackBar_swift

class MySnackbar: SnackBar {
    static var backgroundColor: UIColor = .darkGray
    static var textColor: UIColor = .white
    
    override var style: SnackBarStyle {
        var style = SnackBarStyle()
        style.background = MySnackbar.backgroundColor
        style.textColor = MySnackbar.textColor
        return style
    }
    
    static func show(in view: UIView, message: String, color: UIColor = .darkGray, textColor: UIColor = .white) {
        MySnackbar.backgroundColor = color
        MySnackbar.textColor = textColor
        make(in: view, message: message, duration: .lengthShort).show()
    }
}
