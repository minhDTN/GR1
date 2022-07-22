//
//  Project.swift
//  dominGR1
//
//  Created by minhdtn on 15/07/2022.
//

import Firebase
struct Project {
    let projectID: String
    let description: String
    let progress: String
    let createdAt: Timestamp
    let title: String
    let managerID: String
    
    init(dictionary: [String: Any]) {
        self.projectID = dictionary["projectID"] as? String ?? ""
        self.description = dictionary["description"] as? String ?? ""
        self.progress = dictionary["progress"] as? String ?? ""
        self.managerID = dictionary["managerID"] as? String ?? ""
        self.createdAt = dictionary["createdAt"] as? Timestamp ?? Timestamp(date: Date())
        self.title = dictionary["title"] as? String ?? ""
    }
}
