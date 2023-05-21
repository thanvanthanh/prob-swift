//
//  UISearchBarExtension.swift
//  Probit
//
//  Created by Thân Văn Thanh on 24/08/2022.
//

import UIKit

extension UISearchBar {
    var inputTextField: UITextField? {
        if #available(iOS 13.0, *) {
            return searchTextField
        }
        return subviews[0].subviews.first {
            $0 is UITextField
        } as? UITextField
        
    }
    
    func setTextField(color: UIColor = .clear,
                      borderColor: UIColor) {
        guard let textField = inputTextField else { return }
        textField.subviews.forEach { view in
            if let classFromString = NSClassFromString("_UISearchBarSearchFieldBackgroundView"),
               view.isKind(of: classFromString) {
                view.removeFromSuperview()
            }
        }
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 4
        switch searchBarStyle {
        case .minimal:
            textField.layer.backgroundColor = color.cgColor
            textField.layer.borderColor = borderColor.cgColor
        case .prominent, .default:
            textField.backgroundColor = color
            textField.layer.borderColor = borderColor.cgColor
        @unknown default: break
        }
    }
    
    func setup(placeholder: String) {
        self.sizeToFit()
        self.tintColor = UIColor.color_282828_fafafa
        self.backgroundColor = .clear
        self.searchBarStyle = .minimal
        self.setTextField(color: .clear,
                          borderColor: UIColor.color_4231c8_6f6ff7)
        let placeholderFont = UIFont.font(style: .regular, size: 16) 
        self.searchTextField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                                        attributes: [.font : placeholderFont])
        if let searchTextField = self.value(forKey: "searchField") as? UITextField {
            searchTextField.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                searchTextField.heightAnchor.constraint(equalToConstant: 36),
                searchTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
                searchTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
                searchTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
            ])
            searchTextField.clipsToBounds = true
        }
    }
}
