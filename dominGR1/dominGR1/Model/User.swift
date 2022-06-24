//
//  User.swift
//  dominGR1
//
//  Created by Macbook on 14/06/2022.
//

import UIKit
import Firebase
struct User {
    let email: String
    let fullname: String
    let username: String
    let profileImage: String
    let uid: String
    let jobTitle: String
    var isFollowed: Bool
    var stats: UserStats!
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == uid
    }
    init(dictionary: [String: Any]) {
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.profileImage = dictionary["profileImage"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.jobTitle = dictionary["jobTitle"] as? String ?? ""
        self.stats = UserStats(followers: 0, following: 0)
        self.isFollowed = false
    }
}
struct UserStats {
    let followers: Int
    let following: Int
    //let posts: Int
}
