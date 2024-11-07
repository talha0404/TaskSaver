//
//  TaskListContracts.swift
//  Homework
//
//  Created by talha.sahin on 6.06.2024.
//

import Foundation


protocol TaskListViewModelProtocol {
    var delegate: TaskListViewModelDelegate? { get set }
    var tasks: [TaskDTO] { get set }
    var tasksListCount: Int { get } //To add tableView List
    mutating func fetchTasks()
}


//  Provide a way for the ViewModel to communicate back to the View (ViewController) when data changes or actions are completed.
protocol TaskListViewModelDelegate: AnyObject {
    func didUpdateTasks() // We will update screen
}
