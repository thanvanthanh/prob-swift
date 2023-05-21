//
//  UIButton.swift
//  Probit
//
//  Created by Thân Văn Thanh on 30/08/2022.
//

import UIKit

extension UIButton {
    func underline() {
        guard let text = self.titleLabel?.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        //NSAttributedStringKey.foregroundColor : UIColor.blue
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        self.setAttributedTitle(attributedString, for: .normal)
    }
    
    @IBInspectable var spacingTitle: CGFloat {
        get {
            return self.titleEdgeInsets.left
        }
        set {
            let spacing = AppConstant.isLanguageRightToLeft ? -newValue : newValue
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: -spacing)
        }
    }
    
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        setBackgroundImage(colorImage, for: state)
    }
}

extension UIButton {
    func setInsets(
        forContentPadding contentPadding: UIEdgeInsets,
        imageTitlePadding: CGFloat
    ) {
        if self.semanticContentAttribute == .forceRightToLeft {
            self.contentEdgeInsets = UIEdgeInsets(
                top: contentPadding.top,
                left: contentPadding.left + imageTitlePadding,
                bottom: contentPadding.bottom,
                right: contentPadding.left
            )
            self.titleEdgeInsets = UIEdgeInsets(
                top: 0,
                left: -imageTitlePadding,
                bottom: 0,
                right: imageTitlePadding
            )
        } else {
            self.contentEdgeInsets = UIEdgeInsets(
                top: contentPadding.top,
                left: contentPadding.left,
                bottom: contentPadding.bottom,
                right: contentPadding.right + imageTitlePadding
            )
            self.titleEdgeInsets = UIEdgeInsets(
                top: 0,
                left: imageTitlePadding,
                bottom: 0,
                right: -imageTitlePadding
            )
        }
    }
}

extension UIButton {
    func setImageTintColor(_ color: UIColor) {
        let tintedImage = self.imageView?.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
        self.setImage(tintedImage, for: .highlighted)
    }
    
    func setImageTintColorDefault() {
        let tintedImage = self.imageView?.image?.withRenderingMode(.alwaysOriginal)
        self.setImage(tintedImage, for: .normal)
    }
    
    func changeTintPressHoldButton(beganColor: UIColor,
                           endColor: UIColor,
                           tintPressColor: UIColor,
                           sender: UIGestureRecognizer) {
        
        if sender.state == .ended {
            self.setTitleColor(endColor, for: .normal)
            self.setImageTintColorDefault()
        }
        else if sender.state == .began {
            self.setTitleColor(beganColor, for: .normal)
            self.setImageTintColor(tintPressColor)
        }
    }

    func changeBackgroundPressHoldButton(beganColor: UIColor,
                                         endColor: UIColor,
                                         sender: UIGestureRecognizer) {
        if sender.state == .ended {
            self.backgroundColor = endColor
        }
        else if sender.state == .began {
            self.backgroundColor = beganColor
        }
    }
    
    func changeTitlePressHoldButton(beganColor: UIColor,
                                    endColor: UIColor,
                                    sender: UIGestureRecognizer) {
        if sender.state == .ended {
            self.setTitleColor(endColor, for: .normal)
        }
        else if sender.state == .began {
            self.setTitleColor(beganColor, for: .normal)
        }
    }
    
    //Become Purple
    func addLongPressBecomePurple() {
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressBecomePurple))
        self.addGestureRecognizer(longGesture)
    }
    
    @objc func longPressBecomePurple(_ sender: UIGestureRecognizer) {
        changeTintPressHoldButton(beganColor: UIColor.color_4231c8_6f6ff7, endColor: UIColor.color_424242_7b7b7b, tintPressColor: UIColor.color_4231c8_6f6ff7, sender: sender)
    }
    
    //Outline Button
    func addLongPressOutlineButton() {
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressOutlineButton))
        self.addGestureRecognizer(longGesture)
    }
    
    @objc func longPressOutlineButton(_ sender: UIGestureRecognizer) {
        changeBackgroundPressHoldButton(beganColor: UIColor.color_eceaf9_150e4f,
                                        endColor: UIColor.color_fafafa_181818,
                                        sender: sender)
    }
    
    //Outline Button 2
    func addLongPressOutlineButton2() {
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressOutlineButton2))
        self.addGestureRecognizer(longGesture)
    }
    
    @objc func longPressOutlineButton2(_ sender: UIGestureRecognizer) {
        changeBackgroundPressHoldButton(beganColor: UIColor.color_eaeaea_282828,
                                        endColor: UIColor.color_fafafa_181818,
                                        sender: sender)
        if sender.state == .ended {
            self.backgroundColor = UIColor.color_fafafa_181818
            self.borderColor = UIColor.color_b6b6b6_7b7b7b
        }
        else if sender.state == .began {
            self.backgroundColor = UIColor.color_eaeaea_282828
            self.borderColor = UIColor.color_7b7b7b_424242
        }
        
    }
    
    //Ghost Button
    func addLongPressGhostButton() {
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGhostButton))
        self.addGestureRecognizer(longGesture)
    }
    
    @objc func longPressGhostButton(_ sender: UIGestureRecognizer) {
        changeBackgroundPressHoldButton(beganColor: UIColor.color_f2f2f2_424242,
                                        endColor: UIColor.color_f5f5f5_282828,
                                        sender: sender)
    }
    
    //Text Button
    func addLongPressTextButtonStyle() {
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressTextButtonStyle))
        self.addGestureRecognizer(longGesture)
    }
    
    @objc func longPressTextButtonStyle(_ sender: UIGestureRecognizer) {
        changeTintPressHoldButton(beganColor: UIColor.color_30258b_8e83de,
                                  endColor: UIColor.color_4231c8_6f6ff7,
                                  tintPressColor: UIColor.color_30258b_8e83de,
                                   sender: sender)
    }
    
    //Light Button
    func addLongPressLightButton() {
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressLightButton))
        self.addGestureRecognizer(longGesture)
    }
    
    @objc func longPressLightButton(_ sender: UIGestureRecognizer) {
        if sender.state == .ended {
            self.backgroundColor = UIColor.color_eceaf9_1c1972
            self.setTitleColor(UIColor.color_4231c8_6f6ff7, for: .normal)
        }
        else if sender.state == .began {
            self.backgroundColor = UIColor.color_4231c8_6f6ff7
            self.setTitleColor(UIColor.color_fafafa, for: .normal)
        }
    }
    
}
