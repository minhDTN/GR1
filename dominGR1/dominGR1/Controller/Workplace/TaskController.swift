//
//  TaskController.swift
//  dominGR1
//
//  Created by minhdtn on 19/07/2022.
//

import UIKit
class TaskController: UIViewController {
    //MARK: Properties
    private var taskID: String?
    private var taskTitle: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
        lb.textAlignment = .center
        lb.font = .boldSystemFont(ofSize: 24)
        return lb
    }()
    
    private var descriptionText: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
        lb.textAlignment = .left
        lb.font = .systemFont(ofSize: 16)
        lb.textColor = .black
        return lb
    }()
    //MARK: Helpers
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(didTapCancel))
        let deleteItem = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(didTapDelete))
        let assignItem = UIBarButtonItem(title: "Assign", style: .done, target: self, action: #selector(didTapAssign))
        navigationItem.rightBarButtonItems = [assignItem, deleteItem]
        navigationItem.rightBarButtonItems?[0].tintColor = .black
        navigationItem.rightBarButtonItems?[1].tintColor = .red
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.title = ""
        view.addSubview(taskTitle)
        taskTitle.anchor(top: view.topAnchor, left: view.leftAnchor,right: view.rightAnchor, paddingTop: 55, paddingLeft: 10,paddingRight: 10)
        view.addSubview(descriptionText)
        descriptionText.anchor(top: taskTitle.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 8, paddingRight: 8, width: 375)
    }
    
    //MARK: Actions
    @objc func didTapDelete() {
        guard let taskID = taskID else {
            return
        }
        print("DEBUG: didTapDelete")
        showLoader(true)
        TaskService.deleteTask(taskID: taskID) { error in
            self.showLoader(false)
            if let error = error {
                print("DEBUG: Failed to delete task \(error.localizedDescription)")
                return
            }
            self.dismiss(animated: true)
        }
    }
    @objc func didTapAssign(){
        guard let taskID = taskID else {
            return
        }
        let tableView = AssignTaskSearchController(taskID: taskID)
        navigationController?.pushViewController(tableView, animated: true)
    }
    @objc func didTapCancel(){
        self.dismiss(animated: true)
    }

    //MARK: Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    init(taskTitle: String, descriptionText: String, taskID: String){
        self.taskTitle.text = taskTitle
        self.taskID = taskID
        self.descriptionText.text = "    " + descriptionText
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

