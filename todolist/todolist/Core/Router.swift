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
    
    func openCreateTaskForm(from vc: UIViewController, completion: ((TaskModel) -> Void)?) {
        let form: CreateTaskVC = CreateTaskVC()
        form.didSaveTask = completion
        vc.navigationController?.pushViewController(form, animated: true)
    }
    
    func presentDatePicker(from vc: UIViewController, selectedDate: Date?, closure: ((Date?) -> Void)?) {
        let datePicker: DatePickerVC = DatePickerVC()
        datePicker.selectedDate = selectedDate
        datePicker.didSelectDate = closure
        vc.present(datePicker, animated: true)
    }
    
    func presentTimePicker(from vc: UIViewController, selectedDate: Date?, closure: ((Date?) -> Void)?) {
        let timePicker: TimePickerVC = TimePickerVC()
        if let date = selectedDate {
            timePicker.selectedHour = date.hour
            timePicker.selectedHour = date.minute
        }
        timePicker.didSelectDate = closure
        vc.present(timePicker, animated: true)
    }
}
