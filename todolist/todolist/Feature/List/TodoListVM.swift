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
        return tasks.filter {
            Calendar.current.isDateInToday($0.date) || $0.date > Date().toLocalDate()
        }
    }
    var groupedTasks: [Date: [TaskModel]] {
        return Dictionary(grouping: tasksStartingToday, by: \.dateWithoutTime)
    }
    
    func getFirstCompletedIndex(in date: Date) -> Int {
        return groupedTasks[date]?.firstIndex(where: { $0.isCompleted }) ?? (groupedTasks[date]?.count ?? 0)
    }
}
