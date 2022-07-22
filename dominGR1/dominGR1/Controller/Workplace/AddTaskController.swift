//
//  AddTaskController.swift
//  dominGR1
//
//  Created by minhdtn on 19/07/2022.
//


import UIKit
protocol DidFinishAddingNewTaskDelegate: AnyObject {
    func didFinishAddingNewTask()
}
class AddTaskController: UIViewController {
    //MARK: Properties
    weak var delegate: DidFinishAddingNewTaskDelegate?
    private var projectID: String?
    private var createTaskViewModel =  CreateTaskViewModel()
    private let taskTitleTextField: UITextField = {
        let tf = CustomTextFieldProject(placeholder: "Title")
        return tf
    }()
    
    private lazy var descriptionTextView: CustomTextView = {
        let tv = CustomTextView()
        tv.placeHolder = "Description"
        tv.delegate = self
        tv.layer.borderWidth = 1.0
        tv.layer.borderColor = UIColor.black.cgColor
        tv.layer.cornerRadius = 10.0
        tv.font = UIFont.systemFont(ofSize: 14)
        return tv
    }()
    private let wordCountLabel: UILabel = {
        let lb = UILabel()
        lb.text = "0/\(MAX_LENGTH_PROJECT_DESCRIPTION)"
        lb.textColor = .lightGray
        lb.font = .systemFont(ofSize: 14)
        return lb
    }()
//    var taskTitle: String?
//    var projectID: String?
//    var description: String?
//    var deadline: Date?
    //MARK: Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    init(projectID: String){
        self.projectID = projectID
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    //MARK: Helpers
    func configureUI(){
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancel))
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.title = "Task Infomation"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(didTapAdd))
        navigationItem.rightBarButtonItem?.tintColor = .black
        view.addSubview(taskTitleTextField)
        taskTitleTextField.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 80, paddingLeft: 12, paddingRight: 12)
        view.addSubview(descriptionTextView)
        descriptionTextView.anchor(top: taskTitleTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,paddingTop: 16, paddingLeft: 12, paddingRight: 12, height: 200)
        view.addSubview(wordCountLabel)
        wordCountLabel.anchor(top: descriptionTextView.bottomAnchor, right: view.rightAnchor,paddingTop: 8, paddingRight: 12)
    }
    func checkMaxLength(textView: UITextView) {
        if textView.text.count > MAX_LENGTH_PROJECT_DESCRIPTION {
            textView.deleteBackward()
        }
    }
    //MARK: Actions
    @objc func didTapCancel(){
        self.dismiss(animated: true)
    }
    @objc func didTapAdd(){
        print("DEBUG: Begin create task\n")
        guard let title = taskTitleTextField.text else { return }
        guard let description = descriptionTextView.text else { return }
        createTaskViewModel.taskTitle = title
        createTaskViewModel.description = description
        createTaskViewModel.projectID = self.projectID
        print("\n\n\n \(self.projectID) \n\n\n")
        print("\n\n\n \(createTaskViewModel.projectID) \n\n\n")
        showLoader(true)
        TaskService.addTask(creatTaskViewModel: createTaskViewModel) { error in
                self.showLoader(false)
                if let error = error {
                    print("DEBUG: Failed to create task \(error.localizedDescription)")
                    return
                }
                //self.delegate?.didFinishAddingNewTask()
            self.dismiss(animated: true)
        }
    }
}

//MARK: UITextViewDelegate
extension AddTaskController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkMaxLength(textView: textView)
        let count = textView.text.count
        wordCountLabel.text = "\(count)/\(MAX_LENGTH_PROJECT_DESCRIPTION)"
    }
}
