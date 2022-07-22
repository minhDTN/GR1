//
//  Task.swift
//  dominGR1
//
//  Created by minhdtn on 19/07/2022.
//

import Firebase
struct Task {
    let taskID: String
    let description: String
    let progress: String
    let createdAt: Timestamp
    let title: String
    let managerID: String
    let deadline: Timestamp
    let projectID: String
    let startDate: String
    
    init(dictionary: [String: Any]) {
        self.projectID = dictionary["projectID"] as? String ?? ""
        self.taskID = dictionary["taskID"] as? String ?? ""
        self.description = dictionary["description"] as? String ?? ""
        self.progress = dictionary["progress"] as? String ?? ""
        self.managerID = dictionary["managerID"] as? String ?? ""
        self.createdAt = dictionary["createdAt"] as? Timestamp ?? Timestamp(date: Date())
        self.title = dictionary["title"] as? String ?? ""
        self.deadline  = dictionary["deadline"] as? Timestamp ?? Timestamp(date: Date())
        self.startDate  = dictionary["startDate"] as? String ?? ""
    }
}
