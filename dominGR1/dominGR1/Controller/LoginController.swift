//
//  LoginController.swift
//  dominGR1
//
//  Created by Macbook on 13/06/2022.
//


import UIKit

protocol AuthenticationDelegate: class {
    func authenticationDidComplete()
}
class LoginController: UIViewController {
    //MARK: - Properties
    
    weak var delegate: AuthenticationDelegate?
    private var loginViewModel = LoginViewModel()
    
    private let iconImage: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "logo"))
        iv.contentMode = .scaleAspectFill
        return iv
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
    
    private lazy var loginButton: UIButton = {
        let btn = CustomButton(title: "Log In")
        btn.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return btn
    }()
    
    private let forgotPasswordButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.attributedTitle(firstPart: "Forgot your password?  ", secondPart: "Get help signing in.")
        
        return btn
    }()
    private lazy var dontHaveAccountButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.attributedTitle(firstPart: "Don't have an account?  ", secondPart: "Sign up")
        btn.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return btn
    }()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureNotificationObserves()
    }
    
    //MARK: - Actions
    @objc func handleLogin() {
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        AuthService.logUserIn(withEmail: email, withPassword: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to sign in \(error.localizedDescription)")
                return
            }
            print("\nBefore complete\n")
            self.delegate?.authenticationDidComplete()
            
        }
    }
    @objc func handleShowSignUp() {
        let controller = RegistrationController()
        controller.delegate = delegate
        navigationController?.pushViewController(controller, animated: true)
    }
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            loginViewModel.email = sender.text
        } else {
            loginViewModel.password = sender.text
        }
        updateForm()
    }
    
    //MARK: - Helpers
    func configureUI(){
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        configureGradientLayer()
        
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 80, width: 300)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton,forgotPasswordButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerX(inView: view)
        dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    func configureNotificationObserves() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
}
//MARK: - FormViewModel
extension LoginController: FormViewModel {
    func updateForm() {
        loginButton.backgroundColor = loginViewModel.buttonBackgroundColor
        loginButton.isEnabled = loginViewModel.formIsValid
        loginButton.setTitleColor(loginViewModel.buttonTitleColor, for: .normal)
    }
}


