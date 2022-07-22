//
//  ProjectViewModel.swift
//  dominGR1
//
//  Created by minhdtn on 14/07/2022.
//

import Foundation

struct CreateProjectViewModel {
    
    var projectTitle: String?
    var description: String?
    var formIsValid: Bool {
        return projectTitle?.isEmpty == false && description?.isEmpty == false
    }
}
struct ProjectViewModel {
    
    private let project: Project
    var projectTitle: String {
        return project.title
    }
    var description: String {
        return project.description
    }
    func descriptionLabel() -> String {
        if description.count < 150 {
            return description
        } else {
            return description.substring(toIndex: 149) + "..."
        }
    }
    init(project: Project) {
        self.project = project
    }
}

