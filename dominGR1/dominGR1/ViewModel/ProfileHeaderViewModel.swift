//
//  ProfileHeaderViewModel.swift
//  dominGR1
//
//  Created by Macbook on 21/06/2022.
//

import Foundation
import SDWebImage
struct ProfileHeaderViewModel {
    let user: User
    var fullname: String {
        return user.fullname
    }
    var profileImage: URL? {
        return URL(string: user.profileImage)
    }
    var followButtonText: String {
        if user.isCurrentUser {
            return "Edit Profile"
        }
        return user.isFollowed ? "Following" : "Follow"
    }
    var followButtonColor: UIColor {
        return user.isCurrentUser ? .white : .systemBlue
    }
    var followButtonTextColor: UIColor {
        return user.isCurrentUser ? .black : .white
    }
    var numberOfFollowers: NSAttributedString {
        return attributedStatText(value: user.stats.followers, label: "followers")
    }
    var numberOfFollowing: NSAttributedString {
        return attributedStatText(value: user.stats.following, label: "following")
    }
    var numberOfPosts: NSAttributedString {
        return attributedStatText(value: 5, label: "posts")
    }
    init(user: User){
        self.user = user
    }
    func attributedStatText(value: Int, label: String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "\(value)\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: label, attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray.cgColor]))
        return attributedText
    }
}

