//
//  TaskListViewController.swift
//  Homework
//
//  Created by talha.sahin on 24.05.2024.
//

import UIKit

class TaskListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel: TaskListViewModelProtocol?
    private let bottomSheetTransitioningDelegate = BottomSheetTransitioningDelegate()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupFloatingButton()
        setupBottomSheet()
        activityIndicator.startAnimating()
        viewModel?.fetchTasks()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.fetchTasks() // Refresh tasks whenever the view appears
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func setupUI() {
        title = "Tasks"
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupFloatingButton() {
        // Create the button
        let floatingButton = UIButton(type: .custom)

        // Set button properties
        floatingButton.setTitle("+", for: .normal)
        floatingButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
        floatingButton.backgroundColor = .systemOrange
        floatingButton.layer.cornerRadius = 30
        floatingButton.clipsToBounds = true

        // Add target for button action
        floatingButton.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)

        // Disable Auto Layout for button
        floatingButton.translatesAutoresizingMaskIntoConstraints = false

        // Add button to the view
        view.addSubview(floatingButton)

        // Set button constraints
        NSLayoutConstraint.activate([
            floatingButton.widthAnchor.constraint(equalToConstant: 60),
            floatingButton.heightAnchor.constraint(equalToConstant: 60),
            floatingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            floatingButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
        ])
    }

    private func setupBottomSheet() {
        // Button to present bottom sheet
        let button = UIButton(type: .system)
        button.setTitle("Show Bottom Sheet", for: .normal)
        button.addTarget(self, action: #selector(presentBottomSheet), for: .touchUpInside)
        view.addSubview(button)
        button.center = view.center
    }

    @objc func presentBottomSheet() {
        let bottomSheetVC = BottomSheetViewController()
        bottomSheetVC.delegate = self
        bottomSheetVC.modalPresentationStyle = .custom
        bottomSheetVC.transitioningDelegate = bottomSheetTransitioningDelegate
        present(bottomSheetVC, animated: true, completion: nil)
    }

    @objc func floatingButtonTapped() {
        navigationController?.pushViewController(TaskDetailViewBuilder.build(), animated: true)
    }
}

extension TaskListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.tasksListCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskListTableViewCell.reuseIdentifier, for: indexPath) as? TaskListTableViewCell else {
            return UITableViewCell()
        }

        if let viewModel = self.viewModel {
            cell.configure(data: viewModel.tasks[indexPath.row])
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Selected \(indexPath.row)")

        if let nc = navigationController {
            nc.pushViewController(TaskDetailViewBuilder.build(taskId: viewModel?.tasks[indexPath.row].id), animated: true)
        }
    }
}

extension TaskListViewController: TaskListViewModelDelegate {
    func didUpdateTasks() {
          DispatchQueue.main.async { [weak self] in
              self?.tableView.reloadData()
              self?.activityIndicator.stopAnimating()
          }
    }
}

extension TaskListViewController: BottomSheetDelegate {
    func didSubmitData(data: String) {
        print("Received Data : ", data)
    }
}
