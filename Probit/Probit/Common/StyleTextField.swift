//
//  StyleITextField.swift
//  Probit
//
//  Created by Nguyen Quang on 06/02/2023.
//

import UIKit

protocol StyleTextFieldProtocol: AnyObject {
    func focusTextField()
    func unFocusTextField()
}

class StyleTextField: UITextField {
    weak var delegateFC: StyleTextFieldProtocol?
    public var isCustomColor: Bool = false
    public var isFocus: Bool = false
    public let strokeColor: UIColor = UIColor.color_e6e6e6_646464
    public let strokeFocusColor: UIColor = UIColor.color_4231c8_6f6ff7

    override func becomeFirstResponder() -> Bool {
        let didBecomeFirstResponder = super.becomeFirstResponder()
        if didBecomeFirstResponder {
            guard isCustomColor else {
                layer.borderWidth = 1
                layer.cornerRadius = 2
                layer.borderColor = strokeFocusColor.cgColor
                return didBecomeFirstResponder
            }
            isFocus = true
            delegateFC?.focusTextField()
        }
        return didBecomeFirstResponder
    }
    
    override func resignFirstResponder() -> Bool {
        let didResignFirstResponder = super.resignFirstResponder()
        if didResignFirstResponder {
            guard isCustomColor else {
                layer.borderWidth = 1
                layer.cornerRadius = 2
                layer.borderColor = strokeColor.cgColor
                return didResignFirstResponder
            }
            isFocus = false
            delegateFC?.unFocusTextField()
        }
        return didResignFirstResponder
    }
}
