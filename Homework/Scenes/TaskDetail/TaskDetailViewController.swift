//
//  TaskDetailViewController.swift
//  Homework
//
//  Created by talha.sahin on 6.06.2024.
//

import UIKit

class TaskDetailViewController: UIViewController {
    
    var taskId: UUID?
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    var viewModel: TaskDetailViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }

    private func setupUI() {
        if let taskId = taskId {
            // Show existing task details
            viewModel?.fetchTaskDetails(taskId: taskId)
        } else {
            // New task, initialize UI for creation
            titleTextField.text = ""
            descTextView.text = ""
        }
    }

    @IBAction func titleTextChanged(_ sender: Any) { }

    private func setTextViewUI() {
        descTextView.layer.borderWidth = 1.0  // Set border width
        descTextView.layer.borderColor = UIColor.gray.cgColor  // Set border color
        descTextView.layer.cornerRadius = 8.0  // Set corner radius
    }

    @IBAction func saveClicked(_ sender: Any) {
        guard let title = titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !title.isEmpty else {
            showAlert(message: "Please enter a title.")
            return
        }

        guard let details = descTextView.text, !details.isEmpty else {
            showAlert(message: "Please enter task details.")
            return
        }

        viewModel.saveTask(title: title, details: details)
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Validation Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// We notify view by using delegate protocol pattern
extension TaskDetailViewController: TaskDetailViewModelDelegate {
    func didUpdateTaskDetail(task: TaskDTO) {
        titleTextField.text = task.title
        descTextView.text = task.details
    }

    func didToggleTaskCompletion() {
        navigationController?.popViewController(animated: true)
    }
}
