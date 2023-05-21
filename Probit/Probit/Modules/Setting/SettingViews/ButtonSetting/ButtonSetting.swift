//
//  ButtonSetting.swift
//  Probit
//
//  Created by Thân Văn Thanh on 08/10/2022.
//

import UIKit

class ButtonSetting: StyleButton {
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 56)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configButton()
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configButton()
        setupButton()
    }
    
    private func configButton() {
        self.clipsToBounds = true
    }
    
    func setupButton() {
        let isLogin = AppConstant.isLogin
        let title = isLogin ?  "settings_signout".Localizable() : "login_btn_login".Localizable()
        setTitle(title, for: .normal)
        if !isLogin {
            setImage(nil, for: .normal)
            style = .style_1
        } else {
            style = .style_2
            setImage(UIImage(named: "ico_setting_logout"), for: .normal)
            semanticContentAttribute = AppConstant.isLanguageRightToLeft ? .forceLeftToRight : .forceRightToLeft
            imageEdgeInsets = AppConstant.isLanguageRightToLeft ? UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0) : UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        }
    }
}
