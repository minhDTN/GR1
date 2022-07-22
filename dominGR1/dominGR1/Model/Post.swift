//
//  Post.swift
//  dominGR1
//
//  Created by minhdtn on 12/07/2022.
//

import Firebase
struct Post {
    let postID: String
    let caption: String
    let imageURL: String
    let createdAt: Timestamp
    let likes: Int
    let userID: String
    
    init(dictionary: [String: Any]) {
        self.postID = dictionary["postID"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
        self.imageURL = dictionary["imageURL"] as? String ?? ""
        self.userID = dictionary["userID"] as? String ?? ""
        self.createdAt = dictionary["createdAt"] as? Timestamp ?? Timestamp(date: Date())
        self.likes = dictionary["likes"] as? Int ?? 0
    }
}
