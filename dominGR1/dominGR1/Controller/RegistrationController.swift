//
//  RegistrationController.swift
//  dominGR1
//
//  Created by Macbook on 14/06/2022.
//

import UIKit

class RegistrationController: UIViewController {
    //MARK: - Properties
    weak var delegate: AuthenticationDelegate?
    private var registrationViewModel = RegistrationViewModel()
    private var profileImage: UIImage?
    private lazy var plushPhotoButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "plus_photo"), for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(handleProfilePhotoSelect), for: .touchUpInside)
        return btn
    }()
    private let emailTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Email")
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    private let fullNameTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Fullname")
        return tf
    }()
    
    private let userNameTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Username")
        return tf
    }()
    private let jobTitleTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Job")
        return tf
    }()
    private lazy var signUpButton: UIButton = {
        let btn = CustomButton(title: "Sign Up")
        btn.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return btn
    }()
    private let alreadyHaveAccountButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.attributedTitle(firstPart: "Already have an account?  ", secondPart: "Log In")
        btn.addTarget(self, action: #selector(handleShowLogIn), for: .touchUpInside)
        return btn
    }()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureNotificationObserves()
    }
    //MARK: - Actions
    @objc func handleSignUp(){
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let fullname = fullNameTextField.text else {return}
        guard let username = userNameTextField.text?.lowercased() else {return}
        guard let profileImage = self.profileImage else {return}
        guard let jobTitle = jobTitleTextField.text else {return}
        let credential = AuthCredentials(email: email, password: password, username: username, fullname: fullname, profileImage: profileImage, jobTitle: jobTitle)
        AuthService.registerUser(withCredentials: credential) { error in
            if let error = error {
                print("DEBUG: Failed to upload image \(error.localizedDescription)")
                return
            }
            print("\nBefore complete\n")
            self.delegate?.authenticationDidComplete()
        }
    }
    @objc func handleShowLogIn(){
        navigationController?.popViewController(animated: true)
    }
    @objc func textDidChange(sender: UITextField){
        if sender == emailTextField {
            registrationViewModel.email = sender.text
        } else if sender == passwordTextField{
            registrationViewModel.password = sender.text
        } else if sender == fullNameTextField {
            registrationViewModel.fullname = sender.text
        } else if sender == userNameTextField {
            registrationViewModel.username = sender.text
        } else {
            registrationViewModel.jobTitle = sender.text
        }
        updateForm()
    }
    @objc func handleProfilePhotoSelect(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    //MARK: - Helpers
    func configureUI(){
        configureGradientLayer()
        
        view.addSubview(plushPhotoButton)
        plushPhotoButton.centerX(inView: view)
        plushPhotoButton.setDimensions(height: 140, width: 140)
        plushPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, fullNameTextField, userNameTextField, jobTitleTextField, signUpButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: plushPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.centerX(inView: view)
        alreadyHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    func configureNotificationObserves(){
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        userNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        jobTitleTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
}

//MARK: - FormViewModel
extension RegistrationController: FormViewModel {
    func updateForm() {
        signUpButton.backgroundColor = registrationViewModel.buttonBackgroundColor
        signUpButton.isEnabled = registrationViewModel.formIsValid
        signUpButton.setTitleColor(registrationViewModel.buttonTitleColor, for: .normal)
    }
}
//MARK: - UIImagePickerDelegate
extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        profileImage = selectedImage
        plushPhotoButton.layer.cornerRadius = plushPhotoButton.frame.width / 2
        plushPhotoButton.layer.masksToBounds = true
        plushPhotoButton.layer.borderColor = UIColor(white: 1, alpha: 1).cgColor
        plushPhotoButton.layer.borderWidth = 2
        plushPhotoButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        self.dismiss(animated: true, completion: nil)
    }
}


