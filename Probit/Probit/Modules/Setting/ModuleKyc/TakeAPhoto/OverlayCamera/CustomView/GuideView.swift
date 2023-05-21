//
//  GuideView.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 21/11/2565 BE.
//

import UIKit

class GuideView: BaseView {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var btnNext: StyleButton!
    @IBOutlet weak var imgBanner: UIImageView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        messageLabel.textAlignment = AppConstant.isLanguageRightToLeft ? .right : .left
    }
    
    func showGuideVC(title: String,
                     message: String,
                     image: UIImage?,
                     titleButton: String,
                     onNextAction: @escaping Action) {
        addToWindow()
        setBackgroundColor(color: .clear)
        titleLabel.text = title
        messageLabel.text = message
        imgBanner.image = image
        btnNext.setTitle(titleButton, for: .normal)
        btnNext.did(.touchUpInside) { _, _ in
            onNextAction()
        }
        backView.addTapGesture{
            self.removeToWindow()
        }
    }
    
    func removeToWindow() {
        self.removeFromSuperview()
    }
    
}


