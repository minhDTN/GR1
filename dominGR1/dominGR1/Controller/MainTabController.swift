//
//  MainTabController.swift
//  dominGR1
//
//  Created by Macbook on 13/06/2022.
//

import UIKit
import Firebase
class MainTabController: UITabBarController {
    // MARK: - Properties
    private var user: User? {
        didSet {
            guard let user = user else {
                return
            }
            configureViewControllers(withUser: user)
        }
    }
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserLoggedIn()
        fetchUser()
    }
    // MARK: - API
    func fetchUser() {
        UserService.fetchUser { user in
            self.user = user
        }
    }
    
    func checkIfUserLoggedIn() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let controller = LoginController()
                controller.delegate = self
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: false, completion: nil)
            }
        }
    }
    // MARK: - Helpers
    func configureViewControllers( withUser user: User) {
          tabBar.backgroundColor = .systemGray5
          view.backgroundColor = .white
          
        let freelayout =  UICollectionViewFlowLayout()
          let feed = templateNavigationController(unselectedImage: UIImage(named: "home_unselected")!, selectedImage: UIImage(named: "home_selected")!, rootViewController: FeedController(collectionViewLayout: freelayout))
          
          let mess = templateNavigationController(unselectedImage: UIImage(named: "messenger_unselected")!, selectedImage: UIImage(named: "messenger_selected")!, rootViewController: MessController())
          
          let workplace = templateNavigationController(unselectedImage: UIImage(named: "workplace_unselected")!, selectedImage: UIImage(named: "workplace_selected")!, rootViewController: WorkplaceController())
          
          let profile = templateNavigationController(unselectedImage: UIImage(named: "profile_unselected")!, selectedImage: UIImage(named: "profile_selected")!, rootViewController: ProfileController(user: user))
          
          
          viewControllers = [feed, workplace, mess, profile ]
          tabBar.tintColor = .black
      }
    func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        return nav
    }
}
//MARK: - AuthenticationDelegate
extension MainTabController: AuthenticationDelegate {
    func authenticationDidComplete() {
        fetchUser()
        self.dismiss(animated: true, completion: nil)
    }
}
