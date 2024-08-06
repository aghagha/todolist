//
//  TodoListVC.swift
//  todolist
//
//  Created by Agha Maulana on 06/08/24.
//

import Foundation
import UIKit

class TodoListVC: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

extension TodoListVC {
    private func setupView() {
        view.backgroundColor = .blue
    }
}
