//
//  TaskViewModel.swift
//  dominGR1
//
//  Created by minhdtn on 19/07/2022.
//

import Firebase

struct CreateTaskViewModel {
    
    var taskTitle: String?
    var projectID: String?
    var description: String?
//    var deadline: Date?
    var formIsValid: Bool {
        return taskTitle?.isEmpty == false && description?.isEmpty == false
    }
}
struct TaskViewModel {
    
    private let task: Task
    var taskTitle: String {
        return task.title
    }
    var description: String {
        return task.description
    }
    var deadline: String {
        let dateFormatter = DateFormatter()

        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short

        return dateFormatter.string(from: task.deadline.dateValue())
    }
    var startDate: String {
        return task.startDate
    }
    func descriptionLabel() -> String {
        if description.count < 150 {
            return description
        } else {
            return description.substring(toIndex: 149) + "..."
        }
    }
    
    init(task: Task) {
        self.task = task
    }
}
