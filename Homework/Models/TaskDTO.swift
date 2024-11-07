//
//  Task.swift
//  Homework
//
//  Created by talha.sahin on 20.06.2024.
//

import Foundation

struct TaskDTO {
    let id: UUID
    var title: String
    var details: String
    var isCompleted: Bool

    init(id: UUID = UUID() , title: String, details: String, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.details = details
        self.isCompleted = isCompleted
    }
}
