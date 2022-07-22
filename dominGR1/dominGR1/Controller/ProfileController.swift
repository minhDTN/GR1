//
//  ProfileController.swift
//  dominGR1
//
//  Created by Macbook on 13/06/2022.
//

import UIKit
import Firebase
private let cellIdentifier = "ProfileCell"
private let headerIdentifier = "ProfileHeader"

protocol ProfileControllerDelegate: AnyObject {
    func updateProfileTab(user: User)
}
class ProfileController: UICollectionViewController {
    //MARK: - Properties
    private var user: User
    private var posts = [Post]()
    weak var delegate: ProfileControllerDelegate?
    //MARK: - Lifecycles
    init(user: User){
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self.tabBarController as? MainTabController
        configureUI()
        fetchUserStats()
        checkIfUserIsFollowed()
        fetchPosts()
    }
    //MARK: - API
    func checkIfUserIsFollowed() {
        UserService.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
            self.user.isFollowed = isFollowed
            self.collectionView.reloadData()
        }
    }
    func fetchUserStats() {
        UserService.fetchUserStats(uid: user.uid) { stats in
            self.user.stats = stats
            self.collectionView.reloadData()
        }
    }
    func fetchPosts() {
        PostService.fetchPosts(forUser: user.uid) { posts in
            self.posts = posts
            self.collectionView.reloadData()
        }
    }
    //MARK: - Helpers
    func configureUI() {
        navigationItem.title = user.username
        view.backgroundColor = .white
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(ProfileHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: headerIdentifier)
    }
}

//MARK: - UICollectionViewDataSource
extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ProfileCell
        cell.postViewModel = PostViewModel(post: posts[indexPath.row])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        header.delegate = self
        header.viewModel = ProfileHeaderViewModel(user: user)
        return header
    }
}

//MARK: - UICollectionViweDelegate
extension ProfileController {
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ProfileController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 240)
    }
}

//MARK: - ProfileHeaderDelegate
extension ProfileController: ProfileHeaderDelegate {
    func header(_ profileHeader: ProfileHeader, didTapActionButtonFor user: User) {
        if user.isCurrentUser {
            self.fetchUserStats()
        } else if user.isFollowed {
            UserService.unfollow(uid: user.uid) { error in
                self.user.isFollowed = false
                self.fetchUserStats()
                UserService.fetchUser { currentUser in
                        self.delegate?.updateProfileTab(user: currentUser)
                }
                //self.collectionView.reloadData()
            }
        } else {
            UserService.follow(uid: user.uid) { error in
                self.user.isFollowed = true
                self.fetchUserStats()
                UserService.fetchUser { currentUser in
                        self.delegate?.updateProfileTab(user: currentUser)
                }
                //self.collectionView.reloadData()
            }
        }
    }
}

