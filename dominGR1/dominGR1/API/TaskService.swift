//
//  TaskService.swift
//  dominGR1
//
//  Created by minhdtn on 19/07/2022.
//

import Firebase

struct TaskService {
    static func addTask(creatTaskViewModel: CreateTaskViewModel, completion: @escaping(Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let taskID = UUID().uuidString
        let data: [String: Any] = ["projectID": creatTaskViewModel.projectID ?? "404",
                                   "taskID": taskID,
                                   "title": creatTaskViewModel.taskTitle ?? "Task",
                                   "createdAt": Timestamp(date: Date()),
                                   "deadline": "404" ,
                                   "progress": "0%",
                                   "manageID": uid,
                                   "startDate": "not started yet",
                                   "description": creatTaskViewModel.description ?? "Task"]
        COLLECTION_TASK.document(taskID).setData(data, completion: completion)
    }
    static func fetchTasks(projectID: String,completion: @escaping([Task]) -> Void) {
        COLLECTION_TASK.whereField("projectID", isEqualTo: projectID).getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            let tasks = snapshot.documents.map({Task(dictionary: $0.data())})
            completion(tasks)
        }
    }
    static func assignTask(userID: String, taskID: String,completion: @escaping(Error?) -> Void) {
        let users_tasksID = UUID().uuidString
        let data: [String: Any] = ["userID": userID,
                                   "taskID": taskID]
        COLLECTION_USERS_TASKS.document(users_tasksID).setData(data, completion: completion)
    }
    static func fetchAssignedUsers( forTask taskID: String,forUser userID: String, completion: @escaping(Bool) -> Void) {
        let query = COLLECTION_USERS_TASKS.whereField("taskID", isEqualTo: taskID).whereField("userID", isEqualTo: userID)
            query.getDocuments { snapshot, error in
                guard let snapshot = snapshot else { return }
                let isAssigned = !snapshot.isEmpty
                completion(isAssigned)
        }
    }
    static func deleteTask(taskID: String, completion: @escaping(FirestoreCompletion) ) {
        COLLECTION_TASK.document(taskID).delete(completion: completion)
    }
    static func deleteAssignedMember(taskID: String, userID: String, completion: @escaping(FirestoreCompletion) ) {
        COLLECTION_USERS_TASKS.whereField("taskID", isEqualTo: taskID).whereField("userID", isEqualTo: userID).getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            let documentID = snapshot.documents[0].documentID
            COLLECTION_USERS_TASKS.document(documentID).delete(completion: completion)
        }
    }
}

