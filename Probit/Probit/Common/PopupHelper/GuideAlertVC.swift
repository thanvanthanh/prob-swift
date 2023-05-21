//
//  GuideAlertVC.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 09/11/2565 BE.
//

import UIKit

class GuideAlertVC: BaseViewController {
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var btnNext: StyleButton!
    @IBOutlet weak var imgBanner: UIImageView!

    private var activeAction: Action?
    var onDismiss: (() -> Void)?
    
    @objc func dismissPopup(gesture: UITapGestureRecognizer) {
        self.dismissVC(true)
    }
    
    private func dismissVC(_ animated: Bool? = true, completion: (() -> Void)? = nil) {
        onDismiss?()
        self.dismiss(animated: true, completion: completion)
    }

    override func setupDarkMode() {
        super.setupDarkMode()
    }
    
    @discardableResult
    func load() -> GuideAlertVC {
        self.loadView()
        self.btnNext.did(.touchUpInside) { [weak self] _, _ in
            guard let `self` = self else { return }
            self.dismissVC(completion: self.activeAction)
        }

        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(dismissPopup(gesture:)))
        tapGesture.cancelsTouchesInView = true

        backView.addGestureRecognizer(tapGesture)
        return self
    }
    
    @discardableResult
    func setTitle(_ title: String?) -> GuideAlertVC {
        self.titleLabel.text = title
        self.titleLabel.isHidden = (title?.isEmpty ?? true)
        return self
    }
    
    @discardableResult
    func setMessage(_ message: String?) -> GuideAlertVC {
        self.messageLabel.text = message
        self.messageLabel.isHidden = (message?.isEmpty ?? true)
        return self
    }
    
    @discardableResult
    func setNextButton(_ title: String?) -> GuideAlertVC {
        self.btnNext.setTitle(title, for: .normal)
        self.btnNext.isHidden = title?.isEmpty ?? true
        return self
    }
    
    @discardableResult
    func setActiveButton(_ action: Action?) -> GuideAlertVC {
        self.activeAction = action
        return self
    }
    
    @discardableResult
    func setImage(_ image: UIImage?) -> GuideAlertVC {
        imgBanner.image = image
        return self
    }
    
    @discardableResult
    func setOnDismiss(onDismiss: (() -> Void)?) -> GuideAlertVC {
        self.onDismiss = onDismiss
        return self
    }
}
