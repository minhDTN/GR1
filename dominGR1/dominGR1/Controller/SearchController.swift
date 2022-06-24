//
//  SearchController.swift
//  dominGR1
//
//  Created by Macbook on 21/06/2022.
//

import UIKit

private let reuseIdentifier = "UserCell"

class SearchController: UITableViewController {
    //MARK: - Properties
    private var users = [User]()
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
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.placeholder = "Search"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

//MARK: - UITableViewDataSource
extension SearchController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isInSearchMode ? filterUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        let user = isInSearchMode ? filterUsers[indexPath.row] : users[indexPath.row]
        cell.viewModel = UserCellViewModel(user: user)
        return cell
    }
}

//MARK: - UITableViewDelegate
extension SearchController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = isInSearchMode ? filterUsers[indexPath.row] : users[indexPath.row]
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}
//MARK: - SearchResultUpdater
extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        filterUsers = users.filter( {$0.username.contains(searchText) || $0.fullname.lowercased().contains(searchText)} )
        self.tableView.reloadData()
    }
}

