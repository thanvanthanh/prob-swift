//
//  UIViewExtension.swift
//
// Created by Thanh Than Van on 09/08/2022.

import UIKit

class CommonAlertVC: BaseViewController {

    @IBOutlet weak var cameraContent: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var warningDescription: UILabel!
    
    @IBOutlet weak var cancelButton: StyleButton!
    @IBOutlet weak var activeButton: StyleButton!
    @IBOutlet weak var btnClose: UIButton!
    
    private var activeAction: Action?
    private var cancelAction: Action?
    private var touchToDissmiss: Bool = true
    
    private var isCamera: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @objc func dismissPopup(gesture: UITapGestureRecognizer) {
        guard touchToDissmiss else { return }
        self.dismiss(animated: true)
    }

    override func setupDarkMode() {
        super.setupDarkMode()
        changedTheme()
    }
    
    // MARK: - IBAction Methods
    @discardableResult
    func load() -> CommonAlertVC {
        self.loadView()
        changedTheme()
        self.activeButton.did(.touchUpInside) { [weak self] _, _ in
            guard let `self` = self else { return }
            self.dismiss(animated: false, completion: self.activeAction)
        }
        
        self.cancelButton.did(.touchUpInside) { [weak self] _, _ in
            guard let `self` = self else { return }
            self.dismiss(animated: false, completion: self.cancelAction)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(dismissPopup(gesture:)))
        tapGesture.cancelsTouchesInView = true

        backView.addGestureRecognizer(tapGesture)
        return self
    }
    @IBAction func doClose(_ sender: Any) {
        self.cancelAction?()
        self.dismiss(animated: true, completion: nil)
    }
    
    func changedTheme() {
        cancelButton.style = .style_2
    }
    
    @discardableResult
    func setTitle(_ title: String?) -> CommonAlertVC {
        self.titleLabel.text = title
        self.titleLabel.isHidden = (title?.isEmpty ?? true)
        return self
    }
    
    @discardableResult
    func setMessage(_ message: String?, color: UIColor? = nil) -> CommonAlertVC {
        messageLabel.textAlignment = AppConstant.isLanguageRightToLeft ? .right : .left
        messageLabel.isHidden = (message?.isEmpty ?? true)
        if let msgColor = color {
            messageLabel.textColor = msgColor
        }
        messageLabel.text = message
        if AppConstant.localeId == "my-MM" {
            messageLabel.addInterlineSpacing(spacingValue: 8)
        } else {

        }
        return self
    }
    
    @discardableResult
    func setWarning(_ message: String?, color: UIColor? = nil) -> CommonAlertVC {
        self.warningDescription.text = message
        self.warningDescription.isHidden = (message?.isEmpty ?? true)
        if let warningColor = color {
            warningDescription.textColor = warningColor
        }
        return self
    }
    
    @discardableResult
    func setActiveButton(_ title: String?) -> CommonAlertVC {
        self.activeButton.setTitle(title, for: .normal)
        self.activeButton.isHidden = title?.isEmpty ?? true
        return self
    }
    
    @discardableResult
    func setActiveButton(_ action: Action?) -> CommonAlertVC {
        self.activeAction = action
        return self
    }
    
    @discardableResult
    func setCancelButton(_ title: String?) -> CommonAlertVC {
        self.cancelButton.setTitle(title, for: .normal)
        self.cancelButton.isHidden = title?.isEmpty ?? true
        return self
    }
    
    @discardableResult
    func setCancelButton(_ action: Action?) -> CommonAlertVC {
        self.cancelAction = action
        return self
    }
    
    @discardableResult
    func setForCamera(_ isCamera: Bool) -> CommonAlertVC {
        self.isCamera = isCamera
        if isCamera {
            self.cameraContent.isHidden = false
            self.backView.isHidden = true
            self.view.backgroundColor = UIColor(hexString: "#8e8e8e")
        } else {
            self.view.backgroundColor = UIColor(hexString: "#282828").withAlphaComponent(0.5)
            self.cameraContent.isHidden = true
            self.backView.isHidden = false
        }
        return self
    }
    
    @discardableResult
    func setTouchToDismiss(enable: Bool) -> CommonAlertVC {
        self.touchToDissmiss = enable
        return self
    }

}
