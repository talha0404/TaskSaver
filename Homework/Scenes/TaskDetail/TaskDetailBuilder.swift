//
//  TaskDetailBuilder.swift
//  Homework
//
//  Created by talha.sahin on 8.06.2024.
//

import Foundation


class TaskDetailViewBuilder {
    static func build(taskId: UUID? = nil) -> TaskDetailViewController {
        let viewController = TaskDetailViewController()
        viewController.taskId = taskId // We will send taskId and fetch data in viewModel
        viewController.viewModel = TaskDetailViewModel(service: TaskService())
        viewController.viewModel.delegate = viewController
        return viewController
    }
}
