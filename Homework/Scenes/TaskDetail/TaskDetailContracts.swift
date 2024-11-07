//
//  TaskDetailContracts.swift
//  Homework
//
//  Created by talha.sahin on 6.06.2024.
//

import Foundation

protocol TaskDetailViewModelProtocol {
    var delegate: TaskDetailViewModelDelegate? { get set }
    var task: TaskDTO? { get }
    func fetchTaskDetails(taskId: UUID)
    func toggleTaskCompletion()
    func saveTask(title: String, details: String)
}


//  Provide a way for the ViewModel to communicate back to the View (ViewController) when data changes or actions are completed.
protocol TaskDetailViewModelDelegate: AnyObject {
    func didUpdateTaskDetail(task: TaskDTO)
    func didToggleTaskCompletion()
}
