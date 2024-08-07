//
//  TaskModel.swift
//  todolist
//
//  Created by Agha Maulana on 06/08/24.
//

import Foundation

struct TaskModel {
    var id: UUID = UUID()
    var title: String = ""
    var description: String = ""
    var isCompleted: Bool = false
    var date: Date = Date()
    var hasTime: Bool = false
    
    var dateWithoutTime: Date {
        Calendar.current.startOfDay(for: date)
    }
}

extension TaskModel {
    static var mockCollection: [TaskModel] = [
        TaskModel(id: UUID(), title: "Stand up meeting", description: "", isCompleted: false, date: Date.localDate().setTime(hour: 8, minute: 30), hasTime: true),
        TaskModel(id: UUID(), title: "Register UI", description: "", isCompleted: false, date: Date.localDate().setTime(hour: 9, minute: 0), hasTime: true),
        TaskModel(id: UUID(), title: "Retrospective meeting", description: "", isCompleted: false, date: Date.localDate().setTime(hour: 8, minute: 30), hasTime: true),
        TaskModel(id: UUID(), title: "To do List Mockup", description: "", isCompleted: false, date: Date.localDate().setTime(hour: 10, minute: 00), hasTime: true),
        TaskModel(id: UUID(), title: "Checkout Mockup", description: "", isCompleted: false, date: Date.localDate().setTime(hour: 13, minute: 30), hasTime: true),
        TaskModel(id: UUID(), title: "Delete Mockup", description: "", isCompleted: false, date: Date.localDate().setTime(hour: 14, minute: 30), hasTime: true),
        TaskModel(id: UUID(), title: "Edit Mockup", description: "", isCompleted: false, date: Date.localDate().setTime(hour: 15, minute: 30), hasTime: true),
        TaskModel(id: UUID(), title: "Slice screen", description: "", isCompleted: false, date: Date.localDate().setTime(hour: 15, minute: 30), hasTime: true),
        
        TaskModel(id: UUID(), title: "Stand up meeting", description: "", isCompleted: false, date: Date.localDate().getFutureDay(amount: 1).setTime(hour: 8, minute: 30), hasTime: true),
        TaskModel(id: UUID(), title: "Register UI", description: "", isCompleted: false, date: Date.localDate().getFutureDay(amount: 1).setTime(hour: 9, minute: 0), hasTime: true),
        TaskModel(id: UUID(), title: "Retrospective meeting", description: "", isCompleted: false, date: Date.localDate().getFutureDay(amount: 1).setTime(hour: 8, minute: 30), hasTime: true),
        
        TaskModel(id: UUID(), title: "To do List Mockup", description: "", isCompleted: false, date: Date.localDate().getFutureDay(amount: 2).setTime(hour: 10, minute: 00), hasTime: true),
        TaskModel(id: UUID(), title: "Checkout Mockup", description: "", isCompleted: false, date: Date.localDate().getFutureDay(amount: 2).setTime(hour: 13, minute: 30), hasTime: true),
        
        
        TaskModel(id: UUID(), title: "Delete Mockup", description: "", isCompleted: false, date: Date.localDate().getFutureDay(amount: 3).setTime(hour: 14, minute: 30), hasTime: true),
        TaskModel(id: UUID(), title: "Edit Mockup", description: "", isCompleted: false, date: Date.localDate().getFutureDay(amount: 3).setTime(hour: 15, minute: 30), hasTime: true),
        TaskModel(id: UUID(), title: "Slice screen", description: "", isCompleted: false, date: Date.localDate().getFutureDay(amount: 3).setTime(hour: 15, minute: 30), hasTime: true),
    ]
}
