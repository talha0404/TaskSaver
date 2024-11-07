//
//  TaskListViewBuilder.swift
//  Homework
//
//  Created by talha.sahin on 6.06.2024.
//

import UIKit

class TaskListViewBuilder {
    static func makeInitialPage() -> UINavigationController {
        let storyboard = UIStoryboard(name: "TaskListViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TaskListView") as! TaskListViewController
        vc.viewModel = TaskListViewModel(service: TaskService())
        vc.viewModel?.delegate = vc
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency

        return navigationController
    }
}
