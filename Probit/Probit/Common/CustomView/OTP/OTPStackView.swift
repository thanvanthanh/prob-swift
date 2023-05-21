//
//  SingleDigitField.swift
//  Probit
//
//  Created by Thân Văn Thanh on 06/09/2022.
//

import Foundation
import UIKit

protocol OTPDelegate: AnyObject {
    //always triggers when the OTP field is valid
    func didChangeValidity(isValid: Bool)
    func validationIsSuccessful()
    func finishedFillingOTP()
}


class OTPStackView: UIStackView {
    
    //Customise the OTPField here
    let numberOfFields = 6
    var textFieldsCollection: [OTPTextField] = []
    weak var delegate: OTPDelegate?
    var showsWarningColor = false
    
    var remainingStrStack: [String] = []
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupStackView()
        addOTPFields()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
        addOTPFields()
    }
    
    //Customisation and setting stackView
    private final func setupStackView() {
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = .center
        self.distribution = .fillEqually
        self.spacing = 10
    }
    
    //Adding each OTPfield to stack view
    private final func addOTPFields () {
        for index in 0..<numberOfFields{
            let field = OTPTextField()
            setupTextField(field)
            textFieldsCollection.append(field)
            //Adding a marker to previous field
            index != 0 ? (field.previousTextField = textFieldsCollection[index-1]) : (field.previousTextField = nil)
            //Adding a marker to next field for the field at index-1
            index != 0 ? (textFieldsCollection[index-1].nextTextField = field) : ()
        }
    }
    
    func selectedFirstResponder() {
        textFieldsCollection[0].becomeFirstResponder()
    }
    
    //Customisation and setting OTPTextFields
    private final func setupTextField(_ textField: OTPTextField){
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.addArrangedSubview(textField)
        textField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        textField.heightAnchor.constraint(equalTo: textField.widthAnchor, multiplier: 56/44).isActive = true
        textField.tintColor = .clear
        textField.textAlignment = .center
        textField.adjustsFontSizeToFitWidth = false
        textField.layer.cornerRadius = 2
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.color_e6e6e6_424242.cgColor
        textField.keyboardType = .numberPad
        textField.autocorrectionType = .yes
        textField.placeholder = "-"
        textField.placeHolderColor = UIColor.init(hexString: "7B7B7B")
        textField.textContentType = .oneTimeCode
        textField.textColor = UIColor.init(hexString: "7B7B7B")
    }
    
    //checks if all the OTPfields are filled
    private final func checkForValidity() {
        for fields in textFieldsCollection{
            if (fields.text?.trimmingCharacters(in: CharacterSet.whitespaces) == ""){
                delegate?.didChangeValidity(isValid: false)
                return
            }
        }
        delegate?.didChangeValidity(isValid: true)
    }
    
    //gives the OTP text
    final func getOTP() -> String {
        var OTP = ""
        for textField in textFieldsCollection{
            OTP += textField.text ?? ""
        }
        return OTP
    }

    //set isWarningColor true for using it as a warning color
    final func setAllFieldColor(isWarningColor: Bool = false, color: UIColor){
        for textField in textFieldsCollection{
            textField.layer.borderColor = color.cgColor
        }
        showsWarningColor = isWarningColor
    }
    
    //autofill textfield starting from first
    private final func autoFillTextField(with string: String) {
        remainingStrStack = string.reversed().compactMap{String($0)}
        for textField in textFieldsCollection {
            if let charToAdd = remainingStrStack.popLast() {
                textField.text = String(charToAdd)
            } else {
                break
            }
        }
        checkForValidity()
        remainingStrStack = []
    }
}

//MARK: - TextField Handling
extension OTPStackView: UITextFieldDelegate {
    //switches between OTPTextfields
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range:NSRange,
                   replacementString string: String) -> Bool {
        guard let textField = textField as? OTPTextField else {
            return true
        }
        
        if !string.isNumber && !string.isEmpty {
            return false
        }
        
        delegate?.validationIsSuccessful()
        if string.count > 1 {
            textField.resignFirstResponder()
            autoFillTextField(with: string)
            return false
        } else {
            if (range.length == 0) {
                textField.text? = string
                if textField.nextTextField == nil {
                    textField.resignFirstResponder()
                } else {
                    textField.nextTextField?.becomeFirstResponder()
                }
            }
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if self.getOTP().count == 6 {
            delegate?.finishedFillingOTP()
        }
    }
}
