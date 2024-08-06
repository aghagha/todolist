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
    
    func presentDatePicker(from vc: UIViewController, selectedDate: Date?, closure: ((Date?) -> Void)?) {
        let datePicker: DatePickerVC = DatePickerVC()
        datePicker.selectedDate = selectedDate
        datePicker.didSelectDate = closure
        vc.present(datePicker, animated: true)
    }
}
