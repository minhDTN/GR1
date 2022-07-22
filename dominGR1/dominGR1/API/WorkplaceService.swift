//
//  WorkplaceService.swift
//  dominGR1
//
//  Created by minhdtn on 14/07/2022.
//

import Firebase

struct WorkplaceService {
    static func addProject(creatProjectViewModel: CreateProjectViewModel, completion: @escaping(Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let projectID = UUID().uuidString
        let data: [String: Any] = ["projectID": projectID,
                                   "title": creatProjectViewModel.projectTitle ?? "Project",
                                   "createdAt": Timestamp(date: Date()),
                                   "progress": "0",
                                   "manageID": uid,
                                   "description": creatProjectViewModel.description ?? "Project"]
        COLLECTION_PROJECT.document(projectID).setData(data, completion: completion)
    }
    static func fetchProjects(completion: @escaping([Project]) -> Void) {
        COLLECTION_PROJECT.order(by: "createdAt", descending: true).getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            let posts = snapshot.documents.map({Project(dictionary: $0.data())})
            completion(posts)
        }
    }
    static func addMember(userID: String, projectID: String,completion: @escaping(Error?) -> Void) {
        let users_projectsID = UUID().uuidString
        let data: [String: Any] = ["userID": userID,
                                   "projectID": projectID,
                                   "users_projectsID": users_projectsID]
        COLLECTION_USERS_PROJECTS.document(users_projectsID).setData(data, completion: completion)
    }
    static func fetchAddedUsers( forProject projectID: String,forUser userID: String, completion: @escaping(Bool) -> Void) {
        let query = COLLECTION_USERS_PROJECTS.whereField("projectID", isEqualTo: projectID).whereField("userID", isEqualTo: userID)
            query.getDocuments { snapshot, error in
                guard let snapshot = snapshot else { return }
                let isAssigned = !snapshot.isEmpty
                completion(isAssigned)
        }
    }
    static func deleteProject(projectID: String, completion: @escaping(FirestoreCompletion) ) {
        COLLECTION_PROJECT.document(projectID).delete(completion: completion)
    }
    static func deleteAddedMember(projectID: String, userChoosenID: String, completion: @escaping(FirestoreCompletion) ) {
        COLLECTION_USERS_PROJECTS.whereField("projectID", isEqualTo: projectID).whereField("userID", isEqualTo: userChoosenID).getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            let documentID = snapshot.documents[0].documentID
            COLLECTION_USERS_PROJECTS.document(documentID).delete(completion: completion)
        }
    }
}
