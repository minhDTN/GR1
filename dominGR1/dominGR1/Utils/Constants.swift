//
//  Constants.swift
//  dominGR1
//
//  Created by Macbook on 21/06/2022.
//

import Foundation
import Firebase

let COLLECTION_USER = Firestore.firestore().collection("users")
let COLLECTION_FOLLOWERS =  Firestore.firestore().collection("followers")
let COLLECTION_FOLLOWING =  Firestore.firestore().collection("following")
