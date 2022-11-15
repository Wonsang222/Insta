//
//  LoginController.swift
//  Insta
//
//  Created by 황원상 on 2022/10/05.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore

protocol AuthenticationDelegate:AnyObject{
    func authenticationDidComplete()
}



class LoginController:UIViewController {
    
    //MARK: - Properties
    
    weak var delegate:AuthenticationDelegate?
    
    private var viewModel = LoginViewModel()
    
    let iconImage:UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let emailTextField:UITextField = {
        let tf = CustomTextField(placeholder: "Email")
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    private let passwordTextField:UITextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let loginButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.setHeight(50)
        button.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private let dontHaveAccountButton:UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Dont have an account?", secondPart: "Sign Up")
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    private let forgetPasswordButton:UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Forgot password?", secondPart: "Get help signing it")
        return button
    }()
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObserver()
        
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 80, width: 120)
        iconImage.anchor(top:view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        let stack:UIStackView = {
            let st = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton, forgetPasswordButton])
            st.spacing = 20
            st.axis = .vertical
            return st
        }()
        
        view.addSubview(stack)
        stack.anchor(top:iconImage.bottomAnchor, left:view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerX(inView: view)
        dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    //MARK: - Helpers
    
    func configureUI(){
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemPurple.cgColor, UIColor.systemBlue.cgColor]
        gradient.locations = [0,1]
        view.layer.addSublayer(gradient)
        gradient.frame = view.frame
    }
    
    func configureNotificationObserver(){
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    //MARK: - Actions
    
    @objc func handleLogin(){
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        AuthService.logUserIn(withEmail: email, password: password){ result, error in
            if let error = error{
                return
            }
            self.delegate?.authenticationDidComplete()
            
        }
    }
    
    @objc func handleShowSignUp(){
        let controller = RegistrationController()
        controller.delegate = delegate
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func textDidChange(sender:UITextField){
        if sender == emailTextField{
            viewModel.email == sender.text
        }else{
            viewModel.password == sender.text
        }
        updateForm()
    }
    
    
}

extension LoginController:formViewModel{
    func updateForm() {
        loginButton.backgroundColor = viewModel.buttonBackgroundColor
        loginButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        loginButton.isEnabled = viewModel.formIsValid
    }
    
    
    
}
