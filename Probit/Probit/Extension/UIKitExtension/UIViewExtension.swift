//
//  UIViewExtension.swift
//  Probit
//
//  Created by Beacon on 10/08/2022.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            if let color = self.layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                self.layer.borderColor = color.cgColor
            } else {
                self.layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable var shadowBlur: CGFloat {
        get {
            return self.layer.shadowRadius * 2.0
        }
        set {
            self.layer.shadowRadius = newValue / 2.0
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            if let color = self.layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                self.layer.shadowColor = color.cgColor
                self.layer.shadowOpacity = 1.0
            } else {
                self.layer.shadowColor = nil
                self.layer.shadowOpacity = 0.0
            }
        }
    }
}

// Gradient View
extension UIView {

    func updateSemanticContent() {
        self.semanticContentAttribute = AppConstant.isLanguageRightToLeft ? .forceRightToLeft : .forceLeftToRight
    }
    
    func applyGradient(colours: [UIColor]) {
        self.applyGradient(colours: colours, locations: nil)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.colors = colours.map { $0.cgColor }
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func removeGradientView() {
        guard let gradient = (self.layer.sublayers?.compactMap { $0 as? CAGradientLayer })?.first else {
            return
        }
        gradient.removeFromSuperlayer()
    }
}

protocol NibLoadable {
    static func getNibName() -> String
    static func getNib() -> UINib
}

extension NibLoadable where Self: UIView {
    static func getNibName() -> String {
        String(describing: self)
    }
    
    static func getNib() -> UINib {
        let mainBundle = Bundle.main
        return UINib(nibName: self.getNibName(), bundle: mainBundle)
    }
}

extension UIView {
    var textFieldsInView: [UITextField] {
        return subviews
            .filter ({ !($0 is UITextField) })
            .reduce (( subviews.compactMap { $0 as? UITextField }), { summ, current in
                return summ + current.textFieldsInView
            })
    }
    
    var selectedTextField: UITextField? {
        return textFieldsInView.filter { $0.isFirstResponder }.first
    }
    
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
    }
    
    fileprivate typealias Action = (() -> Void)?
    
    // Set our computed property type to a closure
    fileprivate var tapGestureRecognizerAction: Action? {
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
        
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
    }
    
    // This is the meat of the sauce, here we create the tap gesture recognizer and
    // store the closure the user passed to us in the associated object we declared above
    public func addTapGesture(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // Every time the user taps on the UIImageView, this function gets called,
    // which triggers the closure we stored
    @objc
    fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = self.tapGestureRecognizerAction {
            action?()
        } else {
            
        }
    }
    
    func addLongPressGesture(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressTapView))
        self.addGestureRecognizer(longGesture)
    }
    
    @objc func longPressTapView(_ sender: UIGestureRecognizer){
        guard let action = self.tapGestureRecognizerAction else {
            return
        }
        if sender.state == .ended {
            self.backgroundColor = UIColor.color_fafafa_181818
            action?()
        }
        else if sender.state == .began {
            self.backgroundColor = UIColor.color_e6e6e6_282828
        }
    }
    
}

extension UIView {
    func makeClearHole(rect: CGRect) {
        self.layer.mask = nil
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.fillColor = UIColor.black.cgColor

        let path = UIBezierPath(rect: self.bounds)
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd

        path.append(UIBezierPath(rect: rect))
        maskLayer.path = path.cgPath

        self.layer.mask = maskLayer
    }
}

extension UIView {
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}

extension UIView {
    func addLongPressGestureOutlineButton02(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressTapViewOutlineButton02))
        self.addGestureRecognizer(longGesture)
    }
    
    @objc func longPressTapViewOutlineButton02(_ sender: UIGestureRecognizer){
        guard let action = self.tapGestureRecognizerAction else {
            return
        }
        if sender.state == .ended {
            self.backgroundColor = UIColor.color_fafafa_181818
            action?()
        }
        else if sender.state == .began {
            self.backgroundColor = UIColor.color_eaeaea_282828
        }
    }
    
    func addLongPressGestureOutlineButton01(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressTapViewOutlineButton01))
        self.addGestureRecognizer(longGesture)
    }
    
    @objc func longPressTapViewOutlineButton01(_ sender: UIGestureRecognizer){
        guard let action = self.tapGestureRecognizerAction else {
            return
        }
        if sender.state == .ended {
            self.backgroundColor = UIColor.color_fafafa_181818
            action?()
        }
        else if sender.state == .began {
            self.backgroundColor = UIColor.color_eceaf9_150e4f
            
        }
    }
    
    func hideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
        self.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
    }
}
