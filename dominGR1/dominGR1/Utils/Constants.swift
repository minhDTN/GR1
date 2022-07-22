//
//  Constants.swift
//  dominGR1
//
//  Created by Macbook on 21/06/2022.
//

import Foundation
import Firebase

//MARK: Collections
let COLLECTION_USER = Firestore.firestore().collection("users")
let COLLECTION_FOLLOWERS =  Firestore.firestore().collection("followers")
let COLLECTION_FOLLOWING =  Firestore.firestore().collection("following")
let COLLECTION_POST = Firestore.firestore().collection("posts")
let COLLECTION_PROJECT = Firestore.firestore().collection("projects")
let COLLECTION_TASK = Firestore.firestore().collection("tasks")
let COLLECTION_USERS_TASKS = Firestore.firestore().collection("user-tasks")
let COLLECTION_USERS_PROJECTS = Firestore.firestore().collection("user-projects")
//MARK: Number
let MAX_LENGTH_POST = 1000
let MAX_LENGTH_PROJECT_DESCRIPTION = 1000

