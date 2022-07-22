//
//  WorkplaceController.swift
//  dominGR1
//
//  Created by Macbook on 13/06/2022.
//

import UIKit
import Firebase
import YPImagePicker
private let reuseIdentifier = "Cell"

class WorkplaceController: UICollectionViewController {
    
    
    //MARK: - Properties
    private var projects = [Project]()
    weak var delegate: DidFinishAddingNewProjectDelegate?
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self.tabBarController as? MainTabController
        configureUI()
        fetchProjects()
    }
    // MARK: Actions
    func fetchProjects() {
        WorkplaceService.fetchProjects { projects in
            print("DEBUG: Fetch Projects")
            for project in projects {
                print(project.title)
            }
            self.projects = projects
            print("Number of projects: \(projects.count)")
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.reloadData()
        }
    }
    @objc func handleRefresh() {
        fetchProjects()
    }
    
    @objc func handleSearch() {
        
    }
    
    @objc func handleAddProject() {
        let controller = AddProjectController()
        let nav = UINavigationController(rootViewController: controller)
        controller.delegate = self.delegate
        nav.modalPresentationStyle = .formSheet
        self.present(nav, animated: true)
    }
    
    // MARK: Helpers
    func configureUI(){
        let searchItem = UIBarButtonItem(image: UIImage(named: "search_selected"), style: .plain, target: self, action: #selector(handleSearch))
        let postItem = UIBarButtonItem(title: "New", style: .done, target: self, action: #selector(handleAddProject))
        navigationItem.rightBarButtonItems = [postItem, searchItem]
        
        
        collectionView.backgroundColor = .white
        collectionView.register(WorkplaceCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        navigationItem.title = "Workplace"
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
}
// MARK: UICollectionViewDataSource
extension WorkplaceController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projects.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! WorkplaceCell
        cell.projectViewModel = ProjectViewModel(project: projects[indexPath.row])
        return cell
    }
}
// MARK: UICollectionViewDelegateFlowLayout
extension WorkplaceController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 380.0
        let height = 105.0
        return CGSize(width: width, height: height)
    }
}

extension WorkplaceController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = ProjectController(project: projects[indexPath.row])
        print("\n\n\n \(projects[indexPath.row].projectID) \n\n\n")
        print("DEBUG: start implement didTapInsideProject")
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
}


