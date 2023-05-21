//
//  InputPinTextField.swift
//  Probit
//
//  Created by Thân Văn Thanh on 12/10/2022.
//

import UIKit

enum InputPinType {
    case login
    case enable
    case disable
    case change
}

@IBDesignable class InputPinTextField: BaseView {
    
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    
    var password = ""
    
    var textFieldType: InputPinType = .enable {
        didSet {
            self.loadUI()
        }
    }
    
    @IBInspectable override var isUserInteractionEnabled: Bool {
        get {
            return inputTextField.isUserInteractionEnabled
        }
        set {
            inputTextField.isUserInteractionEnabled = newValue
        }
    }
    
    @IBInspectable override var borderColor: UIColor? {
        get {
            return inputTextField.borderColor
        }
        set {
            inputTextField.borderColor = newValue
        }
    }
    
    @IBInspectable var placeholder: String? {
        get {
            return inputTextField.placeholder
        }
        set {
            inputTextField.placeholder = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        inputTextField.isSecureTextEntry = true
        inputTextField.textAlignment = .center
        inputTextField.keyboardType = .numberPad
        inputTextField.borderWidth = 1
        inputTextField.borderColor = UIColor.color_e6e6e6_646464
        inputTextField.cornerRadius = 2
        inputTextField.textColor = .color_282828_fafafa
        loadUI()
    }
    
    func loadUI() {
        switch textFieldType {
        case .login:
            inputTextField.placeholder = "dialog_hint_input_emailcode".Localizable()
        case .enable:
            inputTextField.placeholder = "activity_lockscreen_v2_displayarea_title_inputpin".Localizable()
        case .disable:
            inputTextField.placeholder = "activity_lockscreen_v2_displayarea_title_inputpin".Localizable()
        case .change:
            inputTextField.placeholder = "activity_lockscreen_v2_displayarea_title_inputpin".Localizable()
        }
    }
    
    func getInputText() -> String {
        return inputTextField.text?.asTrimmed ?? ""
    }
    
    func inputTextValid() -> Bool {
        return errorMessage.text?.isEmpty ?? false
    }
    
    func validateInputText() {
        let inputText = self.inputTextField.text?.asTrimmed ?? ""
        var errorMessage = ""
        
        if inputText.count < 4 {
            errorMessage = "activity_lockscreen_toolesstalker".Localizable()
        } else if inputText.count > 16 {
            errorMessage = "activity_lockscreen_toomuchtalker".Localizable()
        }
        
        setupTextField(error: errorMessage)
    }
    
    func removeText() {
        inputTextField.text?.removeAll()
    }
    
    @IBAction func didEndEditingTextField(_ sender: Any) {
        validateInputText()
    }
    
    // MARK: Setup TextField
    func setupTextField(error: String = "") {
        errorMessage.text = error
        errorMessage.isHidden = error.isEmpty
        updateBorderStatus()
    }
    
    func updateBorderStatus() {
        let defaultColor = UIColor.color_4231c8_6f6ff7
        let isFocus = inputTextField.isEditing
        let errorMessage = errorMessage.text ?? ""
        var borderColor = errorMessage.isEmpty ? defaultColor : UIColor.Basic.red
        borderColor = (!isFocus && errorMessage.isEmpty) ? defaultColor : borderColor
        inputTextField.layer.borderColor = borderColor.cgColor
    }
    
    func followTheme() {
        if inputTextField.layer.borderColor != UIColor.Basic.red.cgColor {
            inputTextField.layer.borderColor = UIColor.color_4231c8_6f6ff7.cgColor
        }
    }
}
