//
//  FeedController.swift
//  dominGR1
//
//  Created by Macbook on 13/06/2022.
//

import UIKit
import Firebase
private let reuseIdentifier = "Cell"
class FeedController: UICollectionViewController {
    //MARK: - Properties
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
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
    // MARK: Helpers
    func configureUI(){
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backButton.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000, vertical: -1000), for: .default)
        navigationItem.backBarButtonItem = backButton
        
        collectionView.backgroundColor = .white
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "search_selected"), style: .plain, target: self, action: #selector(handleSearch))
        navigationItem.title = "Feed"
    }
}
// MARK: UICollectionViewDataSource
extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
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

