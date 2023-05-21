//
//  ForgotPasswordViewController.swift
//  Probit
//
//  Created by Nguyen Quang on 23/08/2022.
//  
//

import UIKit

final class ForgotPasswordViewController: BaseViewController {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var noiticeLabel: UILabel!
    @IBOutlet private weak var emailInputText: InLineTextField!
    @IBOutlet private weak var nextButton: StyleButton!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var heightEmailConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    var presenter: ViewToPresenterForgotPasswordProtocol?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }
    
    override func setupUI() {
        super.setupUI()
        setupNavigationBar(title: "login_forgot_password".Localizable().removing(charactersOf: "?"),
                           titleLeftItem: "common_login".Localizable())
        setupTextField()
        emailInputText.inputTextField.font = UIFont(name: "SFPro-Regular", size: 16) ?? .systemFont(ofSize: 16)
    }
    
    override func setupRightToLeft(_ isRTL: Bool) {
        super.setupRightToLeft(isRTL)
        emailInputText.setupRightToLeft(isRTL)
    }
    
    override func setupDarkMode() {
        super.setupDarkMode()
        emailInputText.updateBorderStatus()
    }
    
    override func localizedString() {
        titleLabel.text = "login_forgot_password".Localizable()
        noiticeLabel.text = "forgot_password_notice_72hrsuspend".Localizable()
        emailInputText.title = "login_email".Localizable()
        emailInputText.placeHolder = "login_email".Localizable()
        nextButton.setTitle("common_next".Localizable(), for: .normal)
        loginButton.setTitle("common_login".Localizable(), for: .normal)
        registerButton.setTitle("activity_signup_title".Localizable(), for: .normal)
    }
}

// MARK: - IBAction
private extension ForgotPasswordViewController {
    @IBAction func nextAction(_ sender: Any) {
        emailInputText.validateInputText()
        if !emailInputText.getErrorMessage().isEmpty {
            return
        }
        
        let email = emailInputText.getInputText()
        presenter?.forgotPassword(of: email)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        pop()
    }
    
    @IBAction func registerAction(_ sender: Any) {
        presenter?.popToTermScreen()
    }
}

// MARK: - Private
private extension ForgotPasswordViewController {
    func setupTextField() {
        emailInputText.isHide = true
        emailInputText.delegate = self
        emailInputText.textFieldType = .forgotPasswordEmail
        emailInputText.setBackgroundColor(color: .clear)
    }
}

// MARK: - PresenterToView
extension ForgotPasswordViewController: PresenterToViewForgotPasswordProtocol {
    
}

// MARK: - InLineDelegate
extension ForgotPasswordViewController: InLineDelegate {
    func validationIsSuccessful() {
        heightEmailConstraint.constant = emailInputText.inputTextValid() ? 78 : 105
    }
}
