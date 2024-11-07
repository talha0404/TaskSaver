//
//  TaskListViewModel.swift
//  Homework
//
//  Created by talha.sahin on 6.06.2024.
//

import Foundation


class TaskListViewModel: TaskListViewModelProtocol {
    private let service: TaskServiceProtocol
    var delegate: TaskListViewModelDelegate?

    init(service: TaskServiceProtocol) {
        self.service = service
    }

    var tasks: [TaskDTO] = []

    var tasksListCount: Int {
        return tasks.count
    }

    func fetchTasks() {
        DispatchQueue.global(qos: .background).async {
            // Simulate fetching tasks
            let newTasks = self.service.fetchTasks()
            sleep(2) // Simulate a delay
            DispatchQueue.main.async {
                self.tasks = newTasks
                self.delegate?.didUpdateTasks()
            }
        }
    }
}
