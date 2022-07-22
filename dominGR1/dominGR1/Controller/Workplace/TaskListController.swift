//
//  TaskController.swift
//  dominGR1
//
//  Created by minhdtn on 19/07/2022.
//

import UIKit
import Firebase
import YPImagePicker
private let reuseIdentifier = "Cell"

class TaskListController: UICollectionViewController {
    
    
    //MARK: - Properties
    var projectID: String = ""
    private var tasks = [Task]()
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.delegate = self.tabBarController as? MainTabController
        configureUI()
        fetchTasks()
    }
    // MARK: Actions
    func fetchTasks() {
        TaskService.fetchTasks(projectID: self.projectID) { tasks in
                print("\nDEBUG: Fetch tasks")
                for task in tasks {
                    print(task.title)
                }
                self.tasks = tasks
                print("Number of tasks: \(tasks.count)\n")
                self.collectionView.refreshControl?.endRefreshing()
                self.collectionView.reloadData()
        }
    }
    @objc func handleRefresh() {
        fetchTasks()
    }
    
    @objc func handleSearch() {
        
    }
    
    @objc func handleAddTask() {
        let controller = AddTaskController(projectID: projectID)
        print("\n\n\n \(self.projectID) \n\n\n")
        let nav = UINavigationController(rootViewController: controller)
       // controller.delegate = self.delegate
        nav.modalPresentationStyle = .formSheet
        self.present(nav, animated: true)
    }
    @objc func didTapCancel(){
        self.dismiss(animated: true)
    }
    // MARK: Helpers
    func configureUI(){
        let searchItem = UIBarButtonItem(image: UIImage(named: "search_selected"), style: .plain, target: self, action: #selector(handleSearch))
        let postItem = UIBarButtonItem(title: "New", style: .done, target: self, action: #selector(handleAddTask))
        navigationItem.rightBarButtonItems = [postItem,searchItem]
        navigationItem.rightBarButtonItems?[0].tintColor = .black
        navigationItem.rightBarButtonItems?[1].tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(didTapCancel))
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        collectionView.backgroundColor = .white
        collectionView.register(TaskCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        navigationItem.title = "Tasks"
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl

    }
}
// MARK: UICollectionViewDataSource
extension TaskListController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TaskCell
        cell.taskViewModel = TaskViewModel(task: tasks[indexPath.row])
        return cell
    }
}
// MARK: UICollectionViewDelegateFlowLayout
extension TaskListController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 380.0
        let height = 105.0
        return CGSize(width: width, height: height)
    }
}

extension TaskListController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = TaskController(taskTitle: tasks[indexPath.row].title, descriptionText: tasks[indexPath.row].description, taskID: tasks[indexPath.row].taskID)
        print("DEBUG: start implement didTapInsideTask")
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
}




