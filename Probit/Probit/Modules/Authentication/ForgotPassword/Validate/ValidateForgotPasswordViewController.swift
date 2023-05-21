//
//  ValidateForgotPasswordViewController.swift
//  Probit
//
//  Created by Thân Văn Thanh on 05/09/2022.
//  
//

import UIKit

class ValidateForgotPasswordViewController: BaseViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var validatePassword: ValidatePassword!
    @IBOutlet weak var confirmPassword: ValidatePassword!
    @IBOutlet weak var confirmButton: StyleButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addObserverKeyBoard()
        scrollView.keyboardDismissMode = .interactive
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func setupUI() {
        super.setupUI()
        setupNavigationBar(title: "login_forgot_password".Localizable().removing(charactersOf: "?"),
                           titleLeftItem: "activity_verification_title".Localizable())
        
        validatePassword.validateType = .showWarning
        validatePassword.showHintWarning(true)
        validatePassword.inputTextField.font = UIFont(name: "SFPro-Regular", size: 16)!
        validatePassword.hintWarningLabel.font = UIFont(name: "SFPro-Regular", size: 12)!
        confirmPassword.validateType = .confirm
        confirmPassword.showHintWarning(false)
        confirmPassword.hiddenWarningAndStrength(true)
        confirmPassword.inputTextField.font = UIFont(name: "SFPro-Regular", size: 16)!
        
        validatePassword.delegate = self
        confirmPassword.delegate = self
        validatePassword.inputTextField.delegateRTL = self
        confirmPassword.inputTextField.delegateRTL = self
        validatePassword.setBackgroundColor(color: .clear)
        confirmPassword.setBackgroundColor(color: .clear)
    }
    
    override func localizedString() {
        titleLabel.text = "login_forgot_password".Localizable()
        validatePassword.title = "login_password".Localizable()
        validatePassword.placeHolder = "login_password".Localizable()
        confirmPassword.title = "fragment_signupemailpassword_confirmpassword".Localizable()
        confirmPassword.placeHolder = "fragment_signupemailpassword_confirmpassword".Localizable()
        confirmButton.setTitle("common_change_password".Localizable(), for: .normal)
        updateSignUpButton()
    }
    
    func updateSignUpButton() {
        let isValid = !validatePassword.getInputText().isEmpty &&
        !confirmPassword.getInputText().isEmpty &&
        validatePassword.getErrorMessage().isEmpty &&
        confirmPassword.getErrorMessage().isEmpty
        confirmButton.setEnable(isEnable: isValid)
    }
    
    override func setupDarkMode() {
        super.setupDarkMode()
        confirmPassword.setupDarkMode()
        validatePassword.setupDarkMode()
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        if validatePassword.getInputText() == confirmPassword.getInputText() {
            presenter?.processForgotPassword(password: validatePassword.getInputText(),
                                             confirmPassword: confirmPassword.getInputText())
        } else {
            confirmPassword.passwordNotMatch()
        }
    }
    
    override func updateLayoutWhenKeyboardChanged(height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.bottomConstraint.constant = height > 0 ? height : 0
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Properties
    var presenter: ViewToPresenterValidateForgotPasswordProtocol?
    
}

// MARK: - PresenterToView
extension ValidateForgotPasswordViewController: PresenterToViewValidateForgotPasswordProtocol{
    func showPasswordError(_ error: ServiceError) {
        validatePassword.passwordUsedBefore()
    }
}

extension ValidateForgotPasswordViewController: RTLTextFieldDelegate {
    func didChangeIsSecureTextEntry(isSecureTextEntry: Bool) {
        if validatePassword.isSecureTextEntry != isSecureTextEntry {
            validatePassword.isSecureTextEntry = isSecureTextEntry
        }
        if confirmPassword.isSecureTextEntry != isSecureTextEntry {
            confirmPassword.isSecureTextEntry = isSecureTextEntry
        }
    }
    
    func focusTextField() {
        
    }
    
    func unFocusTextField() {
        
    }
}

extension ValidateForgotPasswordViewController: ValidatePasswordDelegate {
    var textCompare: String? {
        validatePassword.getInputText()
    }
    
    func validationIsPasswordSuccessful(password: String) {
        if validatePassword.getInputText().isEmpty {
            validatePassword.passwordNotEmpty()
        }
        updateSignUpButton()
    }
}
