//
//  ProjectController.swift
//  dominGR1
//
//  Created by minhdtn on 15/07/2022.
//

import UIKit
import Firebase
class ProjectController: UIViewController {
    //MARK: Properties
    private var progressNumber: Int?
    private var projectID: String?
    private var createdAt: Timestamp?
    private var projectTitle: UILabel = {
        let lb = UILabel()
//        lb.numberOfLines = 0
//        lb.textAlignment = .center
//        lb.font = .boldSystemFont(ofSize: 24)
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
    private var progressTitle: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
        lb.textAlignment = .left
        lb.font = .boldSystemFont(ofSize: 16)
        lb.attributedText = NSMutableAttributedString()
            .bold("Progress: ")
        lb.textColor = .black
        return lb
    }()
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.red, for: .normal)
        button.setTitle("Delete", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
        return button
    }()
//    let progress: String
//    let createdAt: Timestamp
    private var progress: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.trackTintColor = .gray
        progressView.progressTintColor = .purple
        return progressView
    }()
    private var progressText: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
        lb.textAlignment = .right
        lb.font = .systemFont(ofSize: 16)
        lb.textColor = .purple
        return lb
    }()
    private var createdAtLabel: UILabel = {
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
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        navigationItem.title = projectTitle.text
        let addUserItem = UIBarButtonItem(image: UIImage(named: "add-user"), style: .plain, target: self, action: #selector(didTapAddMember))
        let listItem = UIBarButtonItem(image: UIImage(named: "list"), style: .done, target: self, action: #selector(didTapListTask))
        navigationItem.rightBarButtonItems = [listItem, addUserItem]
        navigationItem.rightBarButtonItems?[0].tintColor = .black
        navigationItem.rightBarButtonItems?[1].tintColor = .black
        guard let createdAt = createdAt else {
            return
        }
        createdAtLabel.attributedText = NSMutableAttributedString()
            .bold("Created At: ")
            .normal(configTimestamp(createdAt: createdAt))
        progress.setProgress(Float(self.progressNumber!)/100, animated: true)
//        view.addSubview(projectTitle)
//        projectTitle.anchor(top: view.topAnchor, left: view.leftAnchor,right: view.rightAnchor, paddingTop: 55, paddingLeft: 10,paddingRight: 10)
        view.addSubview(progressTitle)
        progressTitle.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 95, paddingLeft: 8)
        view.addSubview(progress)
        progress.centerY(inView: progressTitle)
        progress.anchor(left: progressTitle.rightAnchor, paddingLeft: 8, width: 200,height: 7)
        view.addSubview(progressText)
        progressText.centerY(inView: progressTitle)
        progressText.anchor(right: view.rightAnchor, paddingRight: 50)
        view.addSubview(createdAtLabel)
        createdAtLabel.anchor(top: progressTitle.bottomAnchor, left: view.leftAnchor, paddingTop: 10,paddingLeft: 8)
        view.addSubview(descriptionText)
        descriptionText.anchor(top: createdAtLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 8, paddingRight: 8, width: 375)
        view.addSubview(deleteButton)
        deleteButton.anchor(top: descriptionText.bottomAnchor, right: view.rightAnchor, paddingTop: 8,paddingRight: 30)
    }
    //MARK: Actions
    @objc func didTapDelete() {
        guard let projectID = projectID else {
            return
        }
        print("DEBUG: didTapDelete")
        showLoader(true)
        WorkplaceService.deleteProject(projectID: projectID) { error in
            self.showLoader(false)
            if let error = error {
                print("DEBUG: Failed to delete project \(error.localizedDescription)")
                return
            }
            self.dismiss(animated: true)
        }
    }
    @objc func didTapAddMember(){
        print("DEBUG: didTapAddMember")
        guard let projectID = projectID else {
            return
        }
        let tableView = AddMemberProjectSearchController(projectID: projectID)
        navigationController?.pushViewController(tableView, animated: true)
    }
    @objc func didTapCancel(){
        self.dismiss(animated: true)
    }
    @objc func didTapListTask(){
        print("DEBUG: Did tap list task\n")
        let layout = UICollectionViewFlowLayout()
        let controller = TaskListController(collectionViewLayout: layout)
        print("\n\n\n \(self.projectID) \n\n\n")
        guard let projectID = self.projectID else {
            return
        }
        controller.projectID = projectID
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
    func configTimestamp(createdAt: Timestamp) -> String {
        let dateFormatter = DateFormatter()

        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short

        return dateFormatter.string(from: createdAt.dateValue())
    }
    //MARK: Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    init(project: Project){
        if let myNumber = NumberFormatter().number(from: project.progress) {
            self.progressNumber = myNumber.intValue
            // do what you need to do with myInt
          } else {
            // what ever error code you need to write
          }
        self.progressText.text = "\(self.progressNumber ?? 100)%"
        self.projectTitle.text = project.title
        self.projectID = project.projectID
        self.createdAt = project.createdAt
        self.descriptionText.attributedText = NSMutableAttributedString()
            .bold("Description: ")
            .normal(project.description)
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
