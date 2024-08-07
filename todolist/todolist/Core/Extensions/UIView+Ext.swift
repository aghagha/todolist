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

public extension UINavigationController {
    func popViewController(animated: Bool = true, _ completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: animated)
        CATransaction.commit()
    }
}
