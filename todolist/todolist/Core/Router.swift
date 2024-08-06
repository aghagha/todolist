//
//  Router.swift
//  todolist
//
//  Created by Agha Maulana on 06/08/24.
//

import Foundation
import UIKit

class Router {
    public static var shared = Router()
    
    func openCreateTaskForm(from vc: UIViewController) {
        let form: CreateTaskVC = CreateTaskVC()
        vc.navigationController?.pushViewController(form, animated: true)
    }
}
