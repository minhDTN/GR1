//
//  PostViewModel.swift
//  dominGR1
//
//  Created by minhdtn on 13/07/2022.
//

import Firebase
struct PostViewModel {
    private let post: Post
    var imageURL: URL? {
        return URL(string: post.imageURL)
    }
    var caption: String {
        return post.caption
    }
    var likes: Int {
        return post.likes
    }
    var userID: String {
        return post.userID
    }
    var createdAt: String {
        let dateFormatter = DateFormatter()

        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short

        return dateFormatter.string(from: post.createdAt.dateValue())
    }
    var likesLabelText: String {
        if post.likes != 1 {
            return "\(post.likes) likes"
        } else {
            return "\(post.likes) like"
        }
    }
    init(post: Post) {
        self.post = post
    }
}
