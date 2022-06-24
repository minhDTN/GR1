//
//  AuthService.swift
//  dominGR1
//
//  Created by Macbook on 14/06/2022.
//

import UIKit
import Firebase
struct AuthCredentials {
    let email: String
    let password: String
    let username: String
    let fullname: String
    let profileImage: UIImage
    let jobTitle: String
}

struct AuthService {
    static func logUserIn(withEmail email: String, withPassword password: String, completetion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completetion)
    }
    static func registerUser(withCredentials credentials: AuthCredentials, completeion: @escaping(Error?) -> Void){
        ImageUploader.uploadImage(image: credentials.profileImage) { imageURL in
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
                if let error = error {
                    print("DEBUG: Failed to upload image \(error.localizedDescription)")
                    return
                }
                guard let uid = result?.user.uid else {return}
                let data: [String: Any] = ["email": credentials.email,
                                           "fullname": credentials.fullname,
                                           "username": credentials.username,
                                           "uid": uid,
                                           "profileImage": imageURL,
                                           "jobTitle": credentials.jobTitle]
                COLLECTION_USER.document(uid).setData(data, completion: completeion)
            }
        }
    }
}

