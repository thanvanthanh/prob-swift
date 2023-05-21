//
//  ERButton.swift
//  Earable
//
//  Created by Sotatek on 09/06/2022.
//  Copyright © 2022 Earable. All rights reserved.
//

import UIKit

enum StyleBtn {
    case style_1
    case style_2
    
    var borderWidth: CGFloat {
        switch self {
        case .style_1:
            return 0.0
        case .style_2:
            return 1.0
        }
    }
    
    var borderColorDisable: UIColor {
        switch self {
        case .style_1:
            return .clear
        case .style_2:
            return UIColor(hexString: "#B6B6B6")
        }
    }
    
    var borderColorEnable: UIColor {
        switch self {
        case .style_1:
            return .clear
        case .style_2:
            return UIColor.color_4231c8_6f6ff7
        }
    }
    
    var textColorEnable: UIColor {
        switch self {
        case .style_1:
            return  UIColor.color_fafafa
        case .style_2:
            return UIColor.color_4231c8_6f6ff7
        }
    }
    
    var textColorDisable: UIColor {
        switch self {
        case .style_1:
            return UIColor.color_fafafa_7b7b7b
        case .style_2:
            return UIColor.color_b6b6b6_424242
        }
    }
    
    var textColorHightLight: UIColor {
        switch self {
        case .style_1:
            return .color_d9d6f4_6f6ff7
        case .style_2:
            return .color_4231c8_6f6ff7
        }
    }
    
    var backGroundColorEnable: UIColor {
        switch self {
        case .style_1:
            return .color_4231c8_6f6ff7
        case .style_2:
            return .clear
        }
    }
    
    var backGroundColorDisable: UIColor {
        switch self {
        case .style_1:
            return UIColor.color_b6b6b6_424242
        case .style_2:
            return .clear
        }
    }
    
    var backGroundColorHightLight: UIColor {
        switch self {
        case .style_1:
            return .color_30258b_3a31ba
        case .style_2:
            return .color_eceaf9_150e4f
        }
    }
    
}

class StyleButton: UIButton {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 48)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configButton()
    }
    
    var style: StyleBtn = .style_1 {
        didSet {
            configButton()
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.25, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: { [weak self] in
                guard let self = self else { return }
                if self.isHighlighted {
                    self.setTitleColor(self.style.textColorHightLight, for: .normal)
                    self.titleLabel?.textColor = self.style.textColorHightLight
                    self.backgroundColor = self.style.backGroundColorHightLight
                } else {
                    self.setTitleColor(self.style.textColorEnable, for: .normal)
                    self.titleLabel?.textColor = self.style.textColorEnable
                    self.backgroundColor = self.style.backGroundColorEnable
                }
            }, completion: nil)
        }
    }
    
    private func configButton() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 2
        self.borderWidth = style.borderWidth
        if self.isEnabled {
            self.setTitleColor(style.textColorEnable, for: .normal)
            self.titleLabel?.textColor = style.textColorEnable
            self.backgroundColor = style.backGroundColorEnable
            self.borderColor = self.style.borderColorEnable
            
        } else {
            self.backgroundColor = style.backGroundColorDisable
            self.setTitleColor(style.textColorDisable, for: .disabled)
            self.titleLabel?.textColor = style.textColorDisable
            self.borderColor = self.style.borderColorDisable
        }
    }
    
    func setEnable(isEnable: Bool) {
        self.isEnabled = isEnable
        self.configButton()
    }
}
