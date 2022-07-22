//
//  AssignTaskSearchController.swift
//  dominGR1
//
//  Created by minhdtn on 19/07/2022.
//


import UIKit

private let reuseIdentifier = "UserCell"

class AssignTaskSearchController: UITableViewController {
    //MARK: - Properties
    private var taskID: String?
    private var users = [User]()
    private var assignUserID: String?
    var searchController = UISearchController(searchResultsController: nil)
    private var filterUsers = [User]()
    private var isInSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSeachController()
        configureUI()
        fetchUsers()
    }
    init(taskID: String){
        self.taskID = taskID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 64
    }
    func fetchUsers(){
        UserService.fetchUsers { users in
            self.users = users
            self.tableView.reloadData()
        }
    }
    func configureSeachController() {
        //self.presentingViewController?.navigationItem.titleView = searchController.searchBar
        self.navigationItem.title = "Search"
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backButton.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000, vertical: -1000), for: .default)
        navigationItem.backBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        let assignItem = UIBarButtonItem(title: "Assign", style: .done, target: self, action: #selector(didTapAssign))
        let deleteItem = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(didTapDelete))
        navigationItem.rightBarButtonItems = [assignItem, deleteItem]
        navigationItem.rightBarButtonItems?[0].tintColor = .black
        navigationItem.rightBarButtonItems?[1].tintColor = .red
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.placeholder = "Search"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    //MARK: Actions
    @objc func didTapDelete() {
        guard let taskID = taskID else {
            return
        }
        guard let assignUserID = assignUserID else {
            return
        }
        print("DEBUG: didTapDelete")
        showLoader(true)
        TaskService.deleteAssignedMember(taskID: taskID, userID: assignUserID) { error in
            self.showLoader(false)
            if let error = error {
                print("DEBUG: Failed to delete task \(error.localizedDescription)")
                return
            }
            self.dismiss(animated: true)
        }
    }
    @objc func didTapAssign() {
        guard let assignUserID = assignUserID else {
            return
        }
        guard let taskID = taskID else {
            return
        }
        showLoader(true)
        TaskService.assignTask(userID: assignUserID, taskID: taskID){ error in
            self.showLoader(false)
            if let error = error {
                print("DEBUG: Failed to add task \(error.localizedDescription)")
                return
            }
            self.dismiss(animated: true)
        }
    }
    func CheckAssignedUser(assignUserID: String){
//        guard let assignUserID = assignUserID else {
//            return
//        }
        guard let taskID = taskID else {
            return
        }
        TaskService.fetchAssignedUsers(forTask: taskID, forUser: assignUserID) { isAssigned in
            self.navigationItem.rightBarButtonItems?[0].isEnabled = !isAssigned
            self.navigationItem.rightBarButtonItems?[1].isEnabled = isAssigned
        }
    }
}
    
//MARK: - UITableViewDataSource
extension AssignTaskSearchController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isInSearchMode ? filterUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        let user = isInSearchMode ? filterUsers[indexPath.row] : users[indexPath.row]
        print("\nDEBUG: \(users[indexPath.row].uid)\n")
        cell.viewModel = UserCellViewModel(user: user)
        return cell
    }
}

//MARK: - UITableViewDelegate

extension AssignTaskSearchController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let choosenUser = isInSearchMode ? filterUsers[indexPath.row] : users[indexPath.row]
        print("DEBUG: ChooseUser: \(choosenUser.fullname)")
        assignUserID = choosenUser.uid
        CheckAssignedUser(assignUserID: assignUserID ?? "404")
    }
}
//MARK: - SearchResultUpdater
extension AssignTaskSearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        filterUsers = users.filter( {$0.username.contains(searchText) || $0.fullname.lowercased().contains(searchText)} )
        self.tableView.reloadData()
    }
}


