//
//  OTPTextField.swift
//  Probit
//
//  Created by Thân Văn Thanh on 06/09/2022.
//

import UIKit

class OTPTextField: UITextField {
    
    weak var previousTextField: OTPTextField?
    weak var nextTextField: OTPTextField?
    
    override public func deleteBackward(){
        if text == "" {
            if let previousTextField = previousTextField {
                previousTextField.text = ""
                previousTextField.becomeFirstResponder()
            }
        } else {
            text = ""
        }
    }
    
    override func caretRect(for position: UITextPosition) -> CGRect { .zero }
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] { [] }
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool { false }
}

