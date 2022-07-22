//
//  PostService.swift
//  dominGR1
//
//  Created by Macbook on 12/07/2022.
//

import Firebase

struct PostService {
    static func uploadPost(caption: String, image: UIImage, completion: @escaping(Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let postID = UUID().uuidString
        ImageUploader.uploadImage(image: image) { imageURL in
            let data: [String: Any] = ["postID": postID,
                                       "caption": caption,
                                       "imageURL": imageURL,
                                       "createdAt": Timestamp(date: Date()),
                                       "likes": 0,
                                       "userID": uid]
            COLLECTION_POST.document(postID).setData(data, completion: completion)
        }
    }
    static func fetchPosts(completion: @escaping([Post]) -> Void) {
        COLLECTION_POST.order(by: "createdAt", descending: true).getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            let posts = snapshot.documents.map({Post(dictionary: $0.data())})
            completion(posts)
        }
    }
    static func fetchPosts( forUser uid: String, completion: @escaping([Post]) -> Void) {
            let query = COLLECTION_POST.whereField("userID", isEqualTo: uid)
            query.getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            let posts = snapshot.documents.map({Post(dictionary: $0.data())})
            completion(posts)
        }
    }
}
