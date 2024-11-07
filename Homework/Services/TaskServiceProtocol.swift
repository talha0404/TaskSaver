//
//  TaskServiceProtocol.swift
//  Homework
//
//  Created by talha.sahin on 6.06.2024.
//

import Foundation

protocol TaskServiceProtocol {
    func fetchTasks() -> [TaskDTO]
    func fetchTask(by id: UUID) -> TaskDTO?
    func createTask(title: String, details: String) -> TaskDTO
    func toggleTaskCompletion(task: TaskDTO)
}
