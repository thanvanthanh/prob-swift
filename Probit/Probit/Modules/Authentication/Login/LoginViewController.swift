//
//  LoginViewController.swift
//  Probit
//
//  Created by Thân Văn Thanh on 22/08/2022.
//  
//

import UIKit

protocol LoginViewControllerDelegate {
    func loginVCDismiss()
}

class LoginViewController: BaseViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    @IBOutlet weak var demo: UIView!
    @IBOutlet weak var emailTitle: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTitle: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var loginButton: StyleButton!
    @IBOutlet weak var spacingBottom: NSLayoutConstraint!
    var delegate: LoginViewControllerDelegate?
    
    // MARK: - Properties
    var presenter: ViewToPresenterLoginProtocol?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.hideKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addObserverKeyBoard()
        scrollView.keyboardDismissMode = .interactive
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let lastEmail = AppConstant.lastEmail {
            emailTextField.text = lastEmail
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
        
    override func setupUI() {
        super.setupUI()
        setupNavigationbar()
        showValidateError(error: nil)
    }
    
    override func setupRightToLeft(_ isRTL: Bool) {
        super.setupRightToLeft(isRTL)
        emailTextField.setRightPaddingPoints(16)
        passwordTextField.setRightPaddingPoints(16)
        emailTextField.setLeftPaddingPoints(16)
        passwordTextField.setLeftPaddingPoints(16)
        passwordTextField.enablePasswordToggle(isRTL: isRTL)
        forgotPasswordButton.contentHorizontalAlignment = isRTL ? .left : .right
    }
    
    override func setupDarkMode() {
        super.setupDarkMode()
        let isValid = errorLabel.text?.isEmpty ?? true
        emailTextField.updateBorderStatus(isValid: isValid)
        passwordTextField.updateBorderStatus(isValid: isValid)
    }
    
    func setupNavigationbar() {
        setupNavigationBar(title: "login_btn_login".Localizable(),
                                titleLeftItem: "common_previous".Localizable())
        addRightBarItem(imageName: "",
                        imageTouch: "",
                        title: "activity_signup_title".Localizable())
    }
    
    override func tappedLeftBarButton(sender: UIButton) {
        let type = presenter?.type
        switch type {
        case .inputPin:
            popToRoot(isAnimated: true)
        case .normal, .none:
            presenter?.dismiss()
        }
    }
    
    override func tappedRightBarButton(sender: UIButton) {
        presenter?.navigateToTerms()
    }
    
    override func localizedString() {
        emailTitle.text = "login_email".Localizable()
        emailTextField.placeholder = "login_email".Localizable()
        
        passwordTitle.text = "login_password".Localizable()
        passwordTextField.placeholder = "login_password".Localizable()
                
        forgotPasswordButton.setTitle("login_forgot_password".Localizable(), for: .normal)
        loginButton.setTitle("login_btn_login".Localizable(), for: .normal)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        let email = emailTextField.text.value.asTrimmed
        let password = passwordTextField.text.value
        presenter?.login(username: email, password: password)
    }
    
    @IBAction func forgotPasswordAction(_ sender: Any) {
        presenter?.navigateToForgotPassword()
    }

    @IBAction func beginEditing(_ sender: UITextField) {
        let isValid = errorLabel.text?.isEmpty ?? true
        if isValid {
            sender.borderColor = UIColor.color_4231c8_6f6ff7
        }
    }
    
    @IBAction func editingDidEnd(_ sender: UITextField) {
        let isValid = errorLabel.text?.isEmpty ?? true
        sender.updateBorderStatus(isValid: isValid)
    }
    
    func showValidateError(error: String?) {
        errorLabel.text = error
        demo.isHidden = error == nil
        if error != nil {
            emailTextField.updateBorderStatus(isValid: false)
            passwordTextField.updateBorderStatus(isValid: false)
        }
    }
    
    override func updateLayoutWhenKeyboardChanged(height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.spacingBottom.constant = height > 0 ? height : 40
            self.view.layoutIfNeeded()
        }
    }
}

extension LoginViewController: PresenterToViewLoginProtocol{
    // TODO: Implement View Output Methods
    func navigateToHome() {
        handleLoginFlow()
    }
    
    func loginError(message: String) {
        showValidateError(error: message)
    }
}
