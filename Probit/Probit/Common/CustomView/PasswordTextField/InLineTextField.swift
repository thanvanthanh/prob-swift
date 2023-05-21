//
//  InLineTextField.swift
//  Earable
//
//  Created by Beacon on 08/06/2022.
//  Copyright © 2022 Earable. All rights reserved.
//

import UIKit

enum InputType: Int {
    case email = 0
    case password = 1
    case confirmPassword = 2
    case name = 3
    case phone = 4
}

protocol InLineDelegate: AnyObject {
    func validationIsSuccessful()
    func didValidationSuccess(_ inlineTextfield: InLineTextField)
}

extension InLineDelegate {
    func didValidationSuccess(_ inlineTextfield: InLineTextField) {}
    func validationIsSuccessful() {}
}

class InLineTextField: BaseView {
    @IBOutlet private weak var inputTextView: UIView!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var eyeButton: UIButton!
    @IBOutlet private weak var inputTextField: UITextField!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var requiredLabel: UILabel!
    
    var textFieldType: InputType = .email
    
    weak var delegate: InLineDelegate?
    
    var needChangeOtherBorder: (() -> Void)?

    var compareString = ""
    
    var rightAction: (() -> Void)?
    
    @IBInspectable var isHide: Bool {
        get {
            return eyeButton.isHidden
        }
        set {
            eyeButton.isHidden = newValue
            inputTextField.isSecureTextEntry = !eyeButton.isHidden
        }
    }
    
    @IBInspectable var placeHolder: String {
        get {
            return inputTextField.placeholder ?? ""
        }
        set {
            inputTextField.placeholder = newValue
        }
    }
    
//    @IBInspectable var maxLength: Int {
//        get {
//            return inputTextField.maxLength
//        }
//        set {
//            inputTextField.maxLength = newValue
//        }
//    }
    
    @IBInspectable var required: Bool {
        get {
            return !requiredLabel.isHidden
        }
        set {
            requiredLabel.isHidden = !newValue
        }
    }
    
    @IBInspectable var rightIcon: UIImage? {
        get {
            return eyeButton.image(for: .normal)
        }
        set {
            eyeButton.setImage(newValue, for: .normal)
        }
    }
    
    @IBInspectable var isEnabled: Bool {
        get { return inputTextField.isEnabled }
        set { inputTextField.isEnabled = newValue }
    }
    
    @IBInspectable var text: String? {
        get { return inputTextField.text }
        set { inputTextField.text = newValue }
    }
    
    @IBInspectable var title: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }
    
//    @IBInspectable var placeholderColor: UIColor? {
//        get {
//            return inputTextField.placeHolderColor
//        }
//        set {
//            inputTextField.placeHolderColor = newValue
//        }
//    }
    
    @IBInspectable var isSecureTextEntry: Bool {
        get {
            return inputTextField.isSecureTextEntry
        }
        set {
            inputTextField.isSecureTextEntry = newValue
        }
    }
    
    @IBInspectable var rightIconEnable: Bool {
        get {
            return eyeButton.isEnabled
        }
        set {
            eyeButton.isEnabled = newValue
        }
    }
    
    @IBAction func changeSecureTextEntry(_ sender: UIButton) {
        guard self.textFieldType == .password || self.textFieldType == .confirmPassword else {
            self.rightAction?()
            return
        }
        sender.isSelected = !sender.isSelected
        self.inputTextField.isSecureTextEntry = !sender.isSelected
    }
    
    // MARK: Export view info
    func getInputText() -> String {
        return inputTextField.text ?? ""
    }
    
    func getErrorMessage() -> String {
        return errorLabel.text ?? ""
    }
    
    func inputTextValid() -> Bool {
        return errorLabel.text?.isEmpty ?? false
    }
    
    // MARK: Setup TextField
    func setupTextField(title: String = "", error: String = "") {
        if !title.isEmpty {
            titleLabel.text = title
        }
        errorLabel.text = error
        errorLabel.isHidden = error.isEmpty
//        inputTextField.placeHolderColor = .lightGray
    }
    
    func setInputText(newText: String) {
        inputTextField.text = newText
    }
    
    func enableTextField(isEnable: Bool = true) {
        inputTextField.isEnabled = isEnable
    }
    
    func setKeyboardType(_ type: UIKeyboardType) {
        self.inputTextField.keyboardType = type
    }
    
    // MARK: Validate TextField Value
    func validateConfirmPassword() -> String {
        let inputText = self.text
        let validConfirmPassword = "" //Localization.LoginLocalization.LoginValidateMessage.validConfirmPassword.localizedString()
        let invalidPassword = "" // Localization.LoginLocalization.LoginValidateMessage.validPassword.localizedString()
        guard !(inputText ?? "").isEmpty else {
            return ""
        }
        var error = (inputText == compareString) ? "" : validConfirmPassword
//        error = (inputText ?? "").isValidPassword ? error : invalidPassword
        setupTextField(error: error)
        updateBorderStatus()
        return error
    }
    
    func validateInputText(inputText: String) {
        var errorMessage = ""
//        let invalidPasswordMessage = Localization.LoginLocalization.LoginValidateMessage.validPassword.localizedString()
//        let invalidEmailMessage = Localization.LoginLocalization.LoginValidateMessage.validEmail.localizedString()
        switch self.textFieldType {
        case .email:
//            errorMessage = inputText.isValidEmail ? "" : invalidEmailMessage
            break
        case .password:
//            errorMessage = inputText.isValidPassword ? "" : invalidPasswordMessage
            break
        case .confirmPassword:
            errorMessage = validateConfirmPassword()
        case .name:
            errorMessage = ""
        case .phone:
            break

//            errorMessage = inputText.isValidPhone() ? "" : Localization.LoginLocalization.LoginValidateMessage.invalidPhoneNumber.localizedString()
        }
        
//        inputTextField.text = String(inputText.prefix(maxLength))
        setupTextField(error: inputText.isEmpty ? "" : errorMessage)
        updateBorderStatus()
        delegate?.validationIsSuccessful()
        self.delegate?.didValidationSuccess(self)
    }
    
    func updateBorderStatus() {
        let isFocus = inputTextField.isEditing
        let errorMessage = errorLabel.text ?? ""
        let currentText = inputTextField.text ?? ""
        var borderColor = errorMessage.isEmpty ? UIColor.init(hex: 0x4FF0C9) : UIColor.init(hex: 0xFF6666)
        borderColor = currentText.isEmpty ? UIColor.clear : borderColor
        borderColor = (!isFocus && errorMessage.isEmpty) ? UIColor.clear : borderColor
        inputTextView.layer.borderColor = borderColor.cgColor
    }
    
    // MARK: TextField actions
    @IBAction func editingTextField(_ sender: UITextField) {
        validateInputText(inputText: sender.text ?? "")
    }
    
    @IBAction func didEndEditingTextField(_ sender: UITextField) {
        updateBorderStatus()
        if let changeBorder = self.needChangeOtherBorder {
            changeBorder()
        }
    }
}
