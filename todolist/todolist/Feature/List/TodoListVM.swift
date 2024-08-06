//
//  TodoListVM.swift
//  todolist
//
//  Created by Agha Maulana on 06/08/24.
//

import Foundation

class TodoListVM {
    var tasks: [TaskModel] = TaskModel.mockCollection
    var tasksStartingToday: [TaskModel] {
        tasks.filter {
            Calendar.current.isDateInToday($0.date) || $0.date > Date().toLocalDate()
        }
    }
    var groupedTasks: [Date: [TaskModel]] {
        Dictionary(grouping: tasksStartingToday, by: \.dateWithoutTime)
    }
    
    func getFirstCompletedIndex() -> Int {
        return tasks.firstIndex(where: { $0.isCompleted }) ?? tasks.count
    }
}
