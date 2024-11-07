//
//  TaskListTableViewCell.swift
//  Homework
//
//  Created by talha.sahin on 6.06.2024.
//

import UIKit

class TaskListTableViewCell: UITableViewCell {

    static let reuseIdentifier = "TaskListTableViewCell"

    @IBOutlet weak var taskTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(data: TaskDTO) {
        taskTitle.text = data.title
    }
}
