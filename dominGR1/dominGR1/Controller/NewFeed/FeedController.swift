//
//  FeedController.swift
//  dominGR1
//
//  Created by Macbook on 13/06/2022.
//

import UIKit
import Firebase
import YPImagePicker
private let reuseIdentifier = "Cell"

class FeedController: UICollectionViewController {
    //MARK: - Properties
    private var posts = [Post]()
    weak var delegate: DidFinishUploadingPostDelegate?
    weak var delegateFeedCell: DidTapUserNameOnFeedDelegate?
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegateFeedCell = self
        self.delegate = self.tabBarController as? MainTabController
        configureUI()
        fetchPosts()
    }
    // MARK: Actions
    @objc func handleLogout(){
        do{
            try Auth.auth().signOut()
            let controller = LoginController()
            controller.delegate = self.tabBarController as? MainTabController
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        } catch {
            print("DEBUG: Failed to sign out user")
        }
        
    }
    @objc func handleSearch(){
        let tableView = SearchController()
        navigationController?.pushViewController(tableView, animated: true)
    }
    @objc func handlePost(){
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photo
        config.shouldSaveNewPicturesToAlbum = false
        config.startOnScreen = .library
        config.screens = [.library]
        config.hidesStatusBar = false
        config.hidesBottomBar = false
        config.library.maxNumberOfItems = 1
        
        let picker = YPImagePicker(configuration: config)
        picker.modalPresentationStyle = .fullScreen
        picker.navigationItem.rightBarButtonItem?.tintColor = .black
        present(picker, animated: true, completion: nil)
        
        picker.didFinishPicking { items, cancelled in
            if cancelled {
                picker.dismiss(animated: true, completion: nil)
                return
            }
            picker.dismiss(animated: true) {
                guard let selectedImage = items.singlePhoto?.image else {return}
                print("Did finish picking image to post: \(selectedImage)")
                
                let controller = PostController()
                controller.delegate = self.delegate
                controller.selectedImage = selectedImage
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
        }
    }
    @objc func handleRefresh() {
        fetchPosts()
    }
    // MARK: Helpers
    func fetchPosts() {
        PostService.fetchPosts { posts in
            print("DEBUG: starting fetch posts")
            self.posts = posts
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.reloadData()
        }
    }
    func configureUI(){
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backButton.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000, vertical: -1000), for: .default)
        navigationItem.backBarButtonItem = backButton
        
        collectionView.backgroundColor = .white
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        let searchItem = UIBarButtonItem(image: UIImage(named: "search_selected"), style: .plain, target: self, action: #selector(handleSearch))
        let postItem = UIBarButtonItem(image: UIImage(named: "more"), style: .plain, target: self, action: #selector(handlePost))
        navigationItem.rightBarButtonItems = [postItem,searchItem]
        navigationItem.title = "Feed"
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
}
// MARK: UICollectionViewDataSource
extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        cell.postViewModel = PostViewModel(post: posts[indexPath.row])
        cell.delegate = delegateFeedCell
        return cell
    }
}
// MARK: UICollectionViewDelegateFlowLayout
extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        var height = width + 8 + 40 + 8
        height += 50
        height += 60
        return CGSize(width: width, height: height)
    }
}
extension FeedController: DidTapUserNameOnFeedDelegate {
    func didTapUserNameOnFeed(user: User) {
        print("DEBUG: Did tap user name")
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}

