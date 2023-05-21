//
//  SignUpViewController.swift
//  Probit
//
//  Created by Nguyen Quang on 22/08/2022.
//  
//

import UIKit

class SignUpViewController: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailInputView: InLineTextField!
    @IBOutlet weak var validatePassword: ValidatePassword!
    @IBOutlet weak var confirmPasswordInputView: InLineTextField!
    @IBOutlet weak var referralCodeContainer: UIView!
    @IBOutlet weak var referralCodeIcon: UIButton!
    @IBOutlet weak var referralCodeLabel: UILabel!
    @IBOutlet weak var referralCodeInputView: RTLTextField!
    private var referralCodeState: Bool = true
    @IBOutlet weak var nextButton: StyleButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightEmailConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConfirmPasswordConstraint: NSLayoutConstraint!
    // MARK: - Properties
    var presenter: ViewToPresenterSignUpProtocol?

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInputView()
        scrollView.hideKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addObserverKeyBoard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func localizedString() {
        emailInputView.title = "login_email".Localizable()
        validatePassword.title = "login_password".Localizable()
        confirmPasswordInputView.title = "fragment_signupemailpassword_confirmpassword".Localizable()
        nextButton.setTitle("common_next".Localizable(), for: .normal)
        referralCodeLabel.text = "fragment_signupemailpassword_referral".Localizable()
        emailInputView.placeHolder = "placeholder_signupemailpassword_enter_email".Localizable()
        validatePassword.placeHolder = "placeholder_signupemailpassword_enter_password".Localizable()
        confirmPasswordInputView.placeHolder = "placeholder_signupemailpassword_enter_password".Localizable()
        referralCodeInputView.placeholder = "placeholder_signupemailpassword_enter_referral".Localizable()
        
        setupNavigationBar(title: "activity_signup_title".Localizable(),
                                titleLeftItem: "fragment_settings_terms".Localizable())
        addRightBarItem(imageName: "", imageTouch: "", title: "common_login".Localizable())
    }
    
    override func setupDarkMode() {
        super.setupDarkMode()
        emailInputView.updateBorderStatus()
        confirmPasswordInputView.updateBorderStatus()
        validatePassword.setupDarkMode()
        referralCodeInputView.updateBorderStatus(isValid: errorLabel.text?.isEmpty ?? true)
    }
    
    override func setupRightToLeft(_ isRTL: Bool) {
        super.setupRightToLeft(isRTL)
        emailInputView.setupRightToLeft(isRTL)
        validatePassword.setupRightToLeft(isRTL)
        confirmPasswordInputView.setupRightToLeft(isRTL)
        if isRTL {
            referralCodeInputView.setRightPaddingPoints(10)
        } else {
            referralCodeInputView.setLeftPaddingPoints(10)
        }
    }
    
    override func setupUI() {
        validatePassword.inputTextField.delegateRTL = self
        confirmPasswordInputView.inputTextField.delegateRTL = self
    }
    
    @IBAction func referralCodeAction(_ sender: Any) {
        changeStatereferralCode()
    }
    
    
    @IBAction func didBeginEdittingReferral(_ sender: Any) {
        errorLabel.isHidden = true
    }
    
    @IBAction func nextAction(_ sender: Any) {
        guard validateInput() else {
            emailInputView.validateInputText()
            validatePassword.validateInputText()
            confirmPasswordInputView.referenceString = validatePassword.getInputText()
            confirmPasswordInputView.validateInputText()
            return
        }
        register()
    }
    
    private func register() {
        let email = emailInputView.getInputText()
        let password = validatePassword.getInputText()
        let confirmPasswod = confirmPasswordInputView.getInputText()
        let referral = referralCodeInputView.text
        presenter?.register(username: email,
                            password: password,
                            passwordConfirm: confirmPasswod,
                            referralCode: referral)
    }
    
    override func tappedLeftBarButton(sender: UIButton) {
        presenter?.pop()
    }
    
    override func tappedRightBarButton(sender: UIButton) {
        presenter?.navigateToLogin()
    }
    
    func setupInputView() {
        emailInputView.delegate = self
        emailInputView.textFieldType = .email
        
        confirmPasswordInputView.delegate = self
        confirmPasswordInputView.textFieldType = .confirmPassword
        validatePassword.delegate = self
        
        changeStatereferralCode()
        referralCodeInputView.delegate = self
        referralCodeInputView.borderStyle = .none
        referralCodeInputView.keyboardType = .numberPad
        showValidateError(error: nil)
    }
    
    private func checkValidateReferralCode() -> Bool {
        guard referralCodeState else {
            return true
        }
        return !referralCodeInputView.text.value.isEmpty
    }
    
    private func showValidateError(error: String?) {
        errorLabel.text = error
        errorLabel.isHidden = error == nil
        referralCodeInputView.updateBorderStatus(isValid: error == nil)
    }
    
    private func changeStatereferralCode() {
        referralCodeState = !referralCodeState
        referralCodeIcon.setImage(referralCodeState ? UIImage(named: "ico_up") : UIImage(named: "ico_down"),
                                  for: .normal)
        referralCodeContainer.isHidden = !referralCodeState
    }
    
    private func validateInput() -> Bool {
        guard checkValidateReferralCode() else {
            showValidateError(error: "commom_field_can_not_empty".Localizable())
            return false
        }
        
        showValidateError(error: nil)
        let isValid = !emailInputView.getInputText().isEmpty &&
        !validatePassword.getInputText().isEmpty &&
        !confirmPasswordInputView.getInputText().isEmpty &&
        emailInputView.getErrorMessage().isEmpty &&
        validatePassword.getErrorMessage().isEmpty &&
        confirmPasswordInputView.getErrorMessage().isEmpty &&
        checkValidateReferralCode()

        return isValid
    }

    override func updateLayoutWhenKeyboardChanged(height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.bottomConstraint.constant = height > 0 ? height : 40
            self.view.layoutIfNeeded()
        }
    }
}

extension SignUpViewController: PresenterToViewSignUpProtocol{
    // TODO: Implement View Output Methods
    func handerApiError(error: ServiceError) {
        switch error.issueCode {
        case .CODE:
            showValidateError(error: error.issueCode.message)
        case .EMAIL_FORMAT:
            emailInputView.setupTextField(error: error.issueCode.message)
        default:
            showError(error: error)
        }
        
    }
}

extension SignUpViewController: RTLTextFieldDelegate {
    func didChangeIsSecureTextEntry(isSecureTextEntry: Bool) {
        if validatePassword.isSecureTextEntry != isSecureTextEntry {
            validatePassword.isSecureTextEntry = isSecureTextEntry
        }
        if confirmPasswordInputView.isSecureTextEntry != isSecureTextEntry {
            confirmPasswordInputView.isSecureTextEntry = isSecureTextEntry
        }
    }
    
    func focusTextField() {
        
    }
    
    func unFocusTextField() {
        
    }
}

extension SignUpViewController: InLineDelegate {
    func validationIsSuccessful() {
        heightEmailConstraint.constant = emailInputView.inputTextValid() ? 78 : 105
        validationConfirmPassword(password: validatePassword.getInputText())
    }
    
    func validationConfirmPassword(password: String) {
        confirmPasswordInputView.referenceString = password
        heightConfirmPasswordConstraint.constant = confirmPasswordInputView.inputTextValid() ? 78 : 105
    }
}

extension SignUpViewController: ValidatePasswordDelegate {
    var textCompare: String? {
       nil
    }
    
    func validationIsPasswordSuccessful(password: String) {
        if confirmPasswordInputView.getInputText().isEmpty {
            return
        }
        confirmPasswordInputView.referenceString = validatePassword.getInputText()
        confirmPasswordInputView.validateInputText()
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField == referralCodeInputView {
            showValidateError(error: nil)
            if range.location > 9 {
                return false
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == referralCodeInputView {
            textField.borderColor = UIColor.color_4231c8_6f6ff7
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == referralCodeInputView {
            textField.borderColor = UIColor.color_e6e6e6_646464
        }
    }	
}
