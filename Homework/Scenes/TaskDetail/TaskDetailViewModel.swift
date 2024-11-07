//
//  TaskDetailViewModel.swift
//  Homework
//
//  Created by talha.sahin on 6.06.2024.
//

import Foundation

class TaskDetailViewModel: TaskDetailViewModelProtocol {
    private let service: TaskServiceProtocol
    weak var delegate: TaskDetailViewModelDelegate?
    var task: TaskDTO?

    init(service: TaskServiceProtocol) {
        self.service = service
    }

    // We will fetch data when view did load in viewController
    func fetchTaskDetails(taskId: UUID) {
        task = service.fetchTask(by: taskId) /// Fetch From Database
        guard let task = task else { return }
        delegate?.didUpdateTaskDetail(task: task)
    }

    func saveTask(title: String, details: String) {
        if let existingTask = task {
            // Update existing task
            var updatedTask = existingTask
            updatedTask.title = title
            updatedTask.details = details
            // Task will be saved here
            service.toggleTaskCompletion(task: updatedTask)
            delegate?.didToggleTaskCompletion()
        } else {
            // Create new task
            let newTask = service.createTask(title: title, details: details)
        }
    }

    func toggleTaskCompletion() {
        // Service will be called and detail page will be dismissed
        delegate?.didToggleTaskCompletion()
    }
}
