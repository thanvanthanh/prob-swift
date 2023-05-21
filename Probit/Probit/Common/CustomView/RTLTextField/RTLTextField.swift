//
//  RTLTextField.swift
//  Probit
//
//  Created by Bradley Hoang on 19/12/2022.
//

import UIKit

protocol RTLTextFieldDelegate {
    func didChangeIsSecureTextEntry(isSecureTextEntry: Bool)
    func focusTextField()
    func unFocusTextField()
}


class RTLTextField: UITextField {
    // MARK: - Lifecycle
    var delegateRTL: RTLTextFieldDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.semanticContentAttribute = UISemanticContentAttribute.forceLeftToRight
        setupRightToLeft(AppConstant.isLanguageRightToLeft)
    }
    
    override func didChangeIsSecureTextEntry(isSecureTextEntry: Bool) {
        delegateRTL?.didChangeIsSecureTextEntry(isSecureTextEntry: isSecureTextEntry)
    }
    
    override func becomeFirstResponder() -> Bool {
        let didBecomeFirstResponder = super.becomeFirstResponder()
        if didBecomeFirstResponder {
            delegateRTL?.focusTextField()
        }
        return didBecomeFirstResponder
    }
    
    override func resignFirstResponder() -> Bool {
        let didResignFirstResponder = super.resignFirstResponder()
        if didResignFirstResponder {
            delegateRTL?.unFocusTextField()
        }
        return didResignFirstResponder
    }
}

// MARK: - Private

private extension RTLTextField {
    func setupRightToLeft(_ isRTL: Bool) {
        textAlignment = isRTL ? .right : .left
    }
}
