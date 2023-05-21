//
//  CustomSecureTextField.swift
//  Probit
//
//  Created by Bradley Hoang on 25/11/2022.
//

import UIKit

class CustomSecureTextField: RTLTextField {
    
    // MARK: - Private Variable
    private var currentText: String?
    
    // MARK: - Public Variable
    var secureText: String = ""
    var isSecure: Bool = false {
        didSet {
            updateText()
        }
    }
    
    func setText(_ text: String?) {
        currentText = text
        updateText()
    }
    
    func updateText() {
        text = isSecure ? secureText : currentText
    }
}
