//
//  TodoListVM.swift
//  todolist
//
//  Created by Agha Maulana on 06/08/24.
//

import Foundation

class TodoListVM {
    var tasks: [TaskModel] = TaskModel.mockCollection
    
    func getFirstCompletedIndex() -> Int {
        return tasks.firstIndex(where: { $0.isCompleted }) ?? tasks.count
    }
}
