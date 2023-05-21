//
//  ValidatePassword.swift
//  Probit
//
//  Created by Thân Văn Thanh on 05/09/2022.
//

import UIKit

enum ValidateType {
    case showWarning
    case confirm
}

protocol ValidatePasswordDelegate: AnyObject {
    func validationIsPasswordSuccessful(password: String)
    var textCompare: String? { get }
}

class ValidatePassword: BaseView {
  
    @IBOutlet weak var passwordTitle: UILabel!
    @IBOutlet weak var inputTextField: RTLTextField!
    @IBOutlet private weak var inputWarning: UILabel!
    @IBOutlet weak var inputPasswordView: UIView!
    @IBOutlet weak var hintWarningLabel: UILabel!
    
    @IBOutlet private weak var requiredLabel: UILabel!
    
    @IBOutlet private weak var charactersImage: UIImageView!
    @IBOutlet private weak var charactersWarning: UILabel!
    
    @IBOutlet private weak var uppercaseImage: UIImageView!
    @IBOutlet private weak var uppercaseWarning: UILabel!
    
    @IBOutlet private weak var lowercaseImage: UIImageView!
    @IBOutlet private weak var lowercaseWarning: UILabel!
    
    @IBOutlet private weak var atLeastNumberImage: UIImageView!
    @IBOutlet private weak var atLeastNumberWarning: UILabel!
    
    @IBOutlet private weak var specialCharacterImage: UIImageView!
    @IBOutlet private weak var specialCharacterWarning: UILabel!
    
    @IBOutlet private weak var twoConsecutiveImage: UIImageView!
    @IBOutlet private weak var twoConsecutiveWarning: UILabel!
    
    @IBOutlet weak var warningStack: UIStackView!
    
    @IBOutlet private weak var firstStrengthView: UIView!
    @IBOutlet private weak var secondStrengthView: UIView!
    @IBOutlet private weak var thirdStrengthView: UIView!
    
    weak var delegate: ValidatePasswordDelegate?
    var validateType: ValidateType = .showWarning
    var strength = ""
    
    var isHiden = false
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
    
    @IBInspectable var title: String? {
        get {
            return passwordTitle.text
        }
        set {
            passwordTitle.text = newValue
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        hintWarningLabel.text = "fragment_signupemailpassword_passwordtip".Localizable()
        [warningStack].forEach({ $0?.isHidden = true })
        inputWarning.text = "commom_field_can_not_empty".Localizable()
        inputWarning.textColor = UIColor.Basic.red
        requiredLabel.text = "forgot_password_musthave".Localizable()
        
        charactersWarning.text = "fragment_signupemailpassword_8to100_characters".Localizable()
        uppercaseWarning.text = "fragment_signupemailpassword_noupperalpha".Localizable()
        lowercaseWarning.text = "fragment_signupemailpassword_noloweralpha".Localizable()
        atLeastNumberWarning.text = "fragment_signupemailpassword_nonumeric".Localizable()
        
        specialCharacterWarning.text = String.init(format: "fragment_signupemailpassword_nospecial".Localizable(),
                                                   "(!#$%&()*+,-./:;<=>?@[]^_`{|}~”)")
        twoConsecutiveWarning.text = "fragment_signupemailpassword_repeatedcharacters".Localizable()
        inputTextField.delegate = self
        
        [firstStrengthView,
         secondStrengthView,
         thirdStrengthView].forEach({ $0?.backgroundColor = UIColor.color_e6e6e6_424242})
    }
    
    func showHintWarning(_ hide: Bool) {
        hintWarningLabel.isHidden = !hide
    }
    
    // MARK: Export view info
    func setupRightToLeft(_ isRTL: Bool) {
        if isRTL {
            inputTextField.setLeftPaddingPoints(10)
        }
    }
    
    func getInputText() -> String {
        return inputTextField.text ?? ""
    }
    
    func getErrorMessage() -> String {
        return inputWarning.text ?? ""
    }
    
    func setInputText(newText: String) {
        inputTextField.text = newText
    }
    
    func hiddenWarningAndStrength(_ isHide: Bool) {
        warningStack.isHidden = isHide
        [firstStrengthView,
         secondStrengthView,
         thirdStrengthView].forEach({ $0?.isHidden = true })
    }
    
    func passwordNotMatch() {
        inputWarning.isHidden = false
        inputPasswordView.borderColor = UIColor(hexString: "#F25D4E")
        inputWarning.text = "fragment_signupemailpassword_passworddoesnotmatch".Localizable()
    }
    
    func passwordisEmpty() {
        inputWarning.isHidden = false
        inputPasswordView.borderColor = UIColor(hexString: "#F25D4E")
        inputWarning.text = "commom_field_can_not_empty".Localizable()
    }
    
    func passwordNotEmpty() {
        inputWarning.isHidden = false
        inputPasswordView.borderColor = UIColor(hexString: "#F25D4E")
        inputWarning.text = "forgot_password_pleaseinput_your_password".Localizable()
    }
    
    func passwordUsedBefore() {
        inputWarning.isHidden = false
        inputPasswordView.borderColor = UIColor(hexString: "#F25D4E")
        inputWarning.text = "forgot_password_pleaseinput_different_former_password".Localizable()
    }
    
    func setupDarkMode() {
        if inputPasswordView.borderColor != UIColor(hexString: "#F25D4E") {
            inputPasswordView.borderColor = UIColor(named: "color_e6e6e6_646464")
        }
    }
    
    func passwordInvalidCharacters() {
        inputWarning.isHidden = false
        inputPasswordView.borderColor = UIColor(hexString: "#F25D4E")
        inputWarning.text = "fragment_signupemailpassword_wrongcharacter".Localizable()
    }
    
    func hidenWarning() {
        inputWarning.isHidden = true
        inputPasswordView.borderColor = UIColor(named: "color_e6e6e6_646464")
    }
    
    func validateInputText() {
        getMissingValidation(text: getInputText())
        showHintWarning(false)
    }
    @IBAction func editingTextField(_ sender: UITextField) {
        hidenWarning()
        getMissingValidation(text: sender.text ?? "")
    }
    @IBAction func didBeginTextField(_ sender: Any) {
        inputWarning.text = ""
        inputPasswordView.borderColor = UIColor.color_4231c8_6f6ff7
    }
    @IBAction func didEndTextField(_ sender: Any) {
        inputPasswordView.borderColor = inputWarning.text.value.isActuallyEmpty ? UIColor.color_e6e6e6_646464 : UIColor.color_f25d4e
    }
}

extension ValidatePassword: UITextFieldDelegate {
    
//    func textField(_ textField: UITextField,
//                   shouldChangeCharactersIn range: NSRange,
//                   replacementString string: String) -> Bool {
//        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
//        hidenWarning()
//        getMissingValidation(text: updatedString ?? "")
//        return true
//    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch validateType {
        case .showWarning:
            showHintWarning(false)
            [warningStack].forEach({ $0?.isHidden = false })
        case .confirm:
            showHintWarning(false)
            [warningStack].forEach({ $0?.isHidden = true })
        }
    }
}

// MARK: - Validate
extension ValidatePassword {
    
    func getMissingValidation(text: String) {
        var pass: Bool = true
        let validPasswordColor = UIColor.color_4231c8_6f6ff7
        let invalidPasswordColor = UIColor(hexString: "#F25D4E")
        let validImage = UIImage(named: "ico_radio_validate")
        let invalidImage = UIImage(named: "ico_radio_invalid")

        // 8 - 100 character
        if (!NSPredicate(format:"SELF MATCHES %@", "^.{8,100}$").evaluate(with: text)) {
            charactersImage.image = invalidImage
            charactersWarning.textColor = invalidPasswordColor
            pass = false
        } else {
            charactersImage.image = validImage
            charactersWarning.textColor = validPasswordColor
        }
        
        // Upcase
        if(!NSPredicate(format:"SELF MATCHES %@", ".*[A-Z]+.*").evaluate(with: text)) {
            uppercaseImage.image = invalidImage
            uppercaseWarning.textColor = invalidPasswordColor
            pass = false
        } else {
            uppercaseImage.image = validImage
            uppercaseWarning.textColor = validPasswordColor
        }
        
        // Lowercase
        if (!NSPredicate(format:"SELF MATCHES %@", ".*[a-z]+.*").evaluate(with: text)) {
            lowercaseImage.image = invalidImage
            lowercaseWarning.textColor = invalidPasswordColor
            pass = false
        } else {
            lowercaseImage.image = validImage
            lowercaseWarning.textColor = validPasswordColor
        }
        
        // Digit
        if (!NSPredicate(format:"SELF MATCHES %@", ".*[0-9]+.*").evaluate(with: text)) {
            atLeastNumberImage.image = invalidImage
            atLeastNumberWarning.textColor = invalidPasswordColor
            pass = false
        } else {
            atLeastNumberImage.image = validImage
            atLeastNumberWarning.textColor = validPasswordColor
        }
        
        // Special character !#$%&'()*+,-./:;<=>?@[]^_`{|}~"
        if (!NSPredicate(format:"SELF MATCHES %@", ".*[\"!#$%&'()*+,-./:;<=>?@\\[\\\\\\]^_`{|}~].*").evaluate(with: text)) {
            specialCharacterImage.image = invalidImage
            specialCharacterWarning.textColor = invalidPasswordColor
            pass = false
        } else {
            specialCharacterImage.image = validImage
            specialCharacterWarning.textColor = validPasswordColor
        }
        
        // Two consecutive identical characters.
        let regex = "(.)\\1\\1"
        if text.range(of: regex, options: .regularExpression) != nil {
            twoConsecutiveImage.image = invalidImage
            twoConsecutiveWarning.textColor = invalidPasswordColor
            pass = false
        } else {
            twoConsecutiveImage.image = validImage
            twoConsecutiveWarning.textColor = validPasswordColor
        }
        // Strength Password
        if pass == true {
            [firstStrengthView,
             secondStrengthView].forEach({ $0?.backgroundColor = UIColor(hexString: "#FAA347")})
            thirdStrengthView.backgroundColor = UIColor.color_e6e6e6_424242
            if text.count > 15 {
                [firstStrengthView,
                 secondStrengthView,
                 thirdStrengthView].forEach({ $0?.backgroundColor = UIColor(hexString: "#12C479")})
            }
        } else if text.count == 0 {
            [firstStrengthView,
             secondStrengthView,
             thirdStrengthView].forEach({ $0?.backgroundColor = UIColor.color_e6e6e6_424242})
        } else {
            [secondStrengthView,
             thirdStrengthView].forEach({ $0?.backgroundColor = UIColor.color_e6e6e6_424242})
            firstStrengthView.backgroundColor = UIColor(hexString: "#F25D4E")
        }
        updateBorderStatus(text: text, isValidate: pass)
        if validateType == .confirm {
            let isCorrect = delegate?.textCompare == self.getInputText()
            if !isCorrect {
                self.passwordNotMatch()
            } else {
                inputWarning.text = nil
                inputWarning.isHidden = true
                inputPasswordView.borderColor = UIColor.color_e6e6e6_646464
            }
        }
        delegate?.validationIsPasswordSuccessful(password: text)
    }
    
    func updateBorderStatus(text: String, isValidate: Bool) {
        guard !isValidate else {
            inputWarning.text = nil
            inputWarning.isHidden = true
            inputPasswordView.borderColor = UIColor.color_e6e6e6_646464
            return
        }
        
        if text.isEmpty {
            passwordisEmpty()
        } else if text.containsWhitespaceAndNewlines() {
            passwordInvalidCharacters()
        } else {
            inputPasswordView.borderColor = UIColor(hexString: "#F25D4E")
        }
    }
    
}
