//
//  ProjectController.swift
//  dominGR1
//
//  Created by minhdtn on 14/07/2022.
//



import UIKit
protocol DidFinishAddingNewProjectDelegate: AnyObject {
    func didFinishAddingNewProject()
}
class AddProjectController: UIViewController {
    //MARK: Properties
    weak var delegate: DidFinishAddingNewProjectDelegate?
    private var createProjectViewModel =  CreateProjectViewModel()
    private let projectTitleTextField: UITextField = {
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
    
    //MARK: Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    //MARK: Helpers
    func configureUI(){
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancel))
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.title = "Project Infomation"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(didTapAdd))
        navigationItem.rightBarButtonItem?.tintColor = .black
        view.addSubview(projectTitleTextField)
        projectTitleTextField.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 80, paddingLeft: 12, paddingRight: 12)
        view.addSubview(descriptionTextView)
        descriptionTextView.anchor(top: projectTitleTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,paddingTop: 16, paddingLeft: 12, paddingRight: 12, height: 200)
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
        print("DEBUG: Begin create project\n")
        guard let title = projectTitleTextField.text else { return }
        guard let description = descriptionTextView.text else { return }
        createProjectViewModel.projectTitle = title
        createProjectViewModel.description = description
        showLoader(true)
        WorkplaceService.addProject(creatProjectViewModel: createProjectViewModel) { error in
            self.showLoader(false)
            if let error = error {
                print("DEBUG: Failed to create project \(error.localizedDescription)")
                return
            }
            self.delegate?.didFinishAddingNewProject()
        }
        print("DEBUG: After create project\n")
    }
}

//MARK: UITextViewDelegate
extension AddProjectController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkMaxLength(textView: textView)
        let count = textView.text.count
        wordCountLabel.text = "\(count)/\(MAX_LENGTH_PROJECT_DESCRIPTION)"
    }
}

