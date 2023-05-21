//
//  InLineTextField.swift
//  Earable
//
//  Created by Beacon on 08/06/2022.
//  Copyright © 2022 Earable. All rights reserved.
//

import UIKit
import Foundation

enum InputType: Int {
    case email = 0
    case password = 1
    case confirmPassword = 2
    case name = 3
    case phone = 4
    case verificationCode = 5
    case kycFullName = 6
    case forgotPasswordEmail = 7
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
    @IBOutlet weak var inputTextField: RTLTextField!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var requiredLabel: UILabel!
    
    weak var delegate: InLineDelegate?
    
    private var _textDidChange: Bool = false
    
    var needChangeOtherBorder: (() -> Void)?

    var referenceString = ""
    
    var textFieldType: InputType = .email
    
    var isHiden = false
    
    var textDidChange: Bool { return _textDidChange }
    
    @IBInspectable var isHide: Bool {
        get {
            return self.isHiden
        }
        set {
            self.isHiden = newValue
            if newValue {
                inputTextField.removePasswordToggle(isRTL: AppConstant.isLanguageRightToLeft)
            } else {
                inputTextField.enablePasswordToggle(isRTL: AppConstant.isLanguageRightToLeft)
            }
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
    
    @IBInspectable var maxLength: Int {
        get {
            return inputTextField.maxLength
        }
        set {
            inputTextField.maxLength = newValue
        }
    }
    
    @IBInspectable var required: Bool {
        get {
            return !requiredLabel.isHidden
        }
        set {
            requiredLabel.isHidden = !newValue
        }
    }
    
    @IBInspectable var isEnabled: Bool {
        get {
            return inputTextField.isEnabled
        }
        set {
            inputTextField.isEnabled = newValue
        }
    }
    
    @IBInspectable var title: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }
    
    @IBInspectable var placeholderColor: UIColor? {
        get {
            return inputTextField.placeHolderColor
        }
        set {
            inputTextField.placeHolderColor = newValue
        }
    }
    
    @IBInspectable var isSecureTextEntry: Bool {
        get {
            return inputTextField.isSecureTextEntry
        }
        set {
            inputTextField.isSecureTextEntry = newValue
            guard let button = inputTextField.eyeButton else { return }
            inputTextField.setPasswordToggleImage(button)
        }
    }
    
    var backgroundTextViewColor: UIColor? {
        didSet {
            inputTextView.backgroundColor = backgroundTextViewColor
        }
    }
    
    // MARK: Export view info
    func getInputText() -> String {
        return inputTextField.text?.asTrimmed ?? ""
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
        updateBorderStatus()
    }
    
    func setInputText(newText: String) {
        inputTextField.text = newText
    }
    
    func setKeyboardType(_ type: UIKeyboardType) {
        self.inputTextField.keyboardType = type
    }
    
    func validateInputText() {
        let inputText = self.inputTextField.text ?? ""
        var errorMessage = ""
        let invalidEmailMessage = "fragment_signupemailpassword_invalidemailsyntax".Localizable()
        let wrongFormatEmailMessage = "invalid_email_format".Localizable()
        let invalidPasswordMessage = "fragment_signupemailpassword_tooshortpassword".Localizable()
        let validConfirmPassword = "fragment_signupemailpassword_passworddoesnotmatch".Localizable()
        
        switch self.textFieldType {
        case .email:
            errorMessage = inputText.isValidEmail ? "" : invalidEmailMessage
            errorMessage = inputText.isEmpty ? "commom_field_can_not_empty".Localizable() : errorMessage
        case .password:
            errorMessage = inputText.isValidPassword ? "" : invalidPasswordMessage
            errorMessage = inputText.isEmpty ? "commom_field_can_not_empty".Localizable() : errorMessage
            errorMessage = ((inputText != referenceString) && !inputText.isEmpty && !referenceString.isEmpty) ? validConfirmPassword : errorMessage
        case .confirmPassword:
            errorMessage = inputText.isEmpty ? "commom_field_can_not_empty".Localizable() : errorMessage
            errorMessage = ((inputText != referenceString) && !inputText.isEmpty && !referenceString.isEmpty) ? validConfirmPassword : errorMessage
        case .name:
            errorMessage = ""
            errorMessage = inputText.isEmpty ? "commom_field_can_not_empty".Localizable() : errorMessage
        case .phone:
            errorMessage = inputText.isValidPhone() ? "" : "invalid_phone".Localizable()
            errorMessage = inputText.isEmpty ? "commom_field_can_not_empty".Localizable() : errorMessage
        case .verificationCode:
            
            errorMessage = inputText.isValidCode
            errorMessage = inputText.isEmpty ? "commom_field_can_not_empty".Localizable() : errorMessage
        case .kycFullName:
            errorMessage = ""
        case .forgotPasswordEmail:
            errorMessage = inputText.isValidEmail ? "" : wrongFormatEmailMessage
            errorMessage = inputText.isEmpty ? "commom_field_can_not_empty".Localizable() : errorMessage
        }

        inputTextField.text = String(inputText.prefix(maxLength))
        setupTextField(error: errorMessage)
        delegate?.validationIsSuccessful()
        self.delegate?.didValidationSuccess(self)
    }
    
    func updateBorderStatus() {
        switch textFieldType {
        case .kycFullName:
            let isFocus = inputTextField.isEditing
            let defaultColor = isFocus ? UIColor.color_4231c8_6f6ff7 : UIColor.color_e6e6e6_646464
            let isInputEmpty = inputTextField.text?.isEmpty ?? true
            let borderColor = isInputEmpty ? UIColor.Basic.red : defaultColor
            inputTextView.layer.borderColor = borderColor.cgColor
            
        default:
            let isFocus = inputTextField.isEditing
            let defaultColor = isFocus ? UIColor.color_4231c8_6f6ff7 : UIColor.color_e6e6e6_646464
            let errorMessage = errorLabel.text ?? ""
            var borderColor = errorMessage.isEmpty ? defaultColor : UIColor.Basic.red
            borderColor = (!isFocus && errorMessage.isEmpty) ? defaultColor : borderColor
            inputTextView.layer.borderColor = borderColor.cgColor
        }
    }
    
    func setupRightToLeft(_ isRTL: Bool) {
        if isRTL {
            inputTextField.setLeftPaddingPoints(10)
        }
    }
    
    // MARK: TextField actions
    @IBAction func editingTextField(_ sender: UITextField) {
        self._textDidChange = true
        validateInputText()
    }
    
    @IBAction func bedinEdittingTextField(_ sender: Any) {
        inputTextView.layer.borderColor = UIColor.color_4231c8_6f6ff7.cgColor
        errorLabel.isHidden = true
    }
    @IBAction func didEndEditingTextField(_ sender: UITextField) {
        updateBorderStatus()
        if let changeBorder = self.needChangeOtherBorder {
            changeBorder()
        }
    }
}
