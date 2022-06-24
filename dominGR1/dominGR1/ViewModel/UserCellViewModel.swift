//
//  UserCellViewModel.swift
//  dominGR1
//
//  Created by Macbook on 21/06/2022.
//

import UIKit
import SDWebImage

struct UserCellViewModel {
    let user: User
    var fullname: String {
        return user.fullname
    }
    var profileImage: URL? {
        return URL(string: user.profileImage)
    }
    var username: String {
        return user.username
    }
    init(user: User){
        self.user = user
    }
}

