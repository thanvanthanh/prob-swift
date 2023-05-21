//
//  HighlightButon.swift
//  Probit
//
//  Created by Nguyen Quang on 12/01/2023.
//

import Foundation

class HighlightButon: UIButton {
    var highlightDuration: TimeInterval = 0.1
    var bgColor: UIColor = .color_eceaf9_150e4f
    var textColor: UIColor = .color_eceaf9_150e4f
    var strokeColor: UIColor = .clear

    var highlightType: HighlightType = .homeLauncher {
        didSet {
            configButton()
        }
    }

    override var isHighlighted: Bool {
        didSet {
            if oldValue == false && isHighlighted {
                highlight()
            } else if oldValue == true && !isHighlighted {
                unHighlight()
            }
        }
    }
    
    private func configButton() {
        unHighlight()
    }
    
    func highlight() {
        self.backgroundColor = highlightType.backgroundColor
        self.setTitleColor(highlightType.textColor, for: .normal)
        self.setImageTintColor(highlightType.colorImage)
        self.layer.borderColor = highlightType.borderColor.cgColor

    }
    
    func unHighlight() {
        self.backgroundColor = bgColor
        self.setTitleColor(textColor, for: .normal)
        if highlightType == .outlineButton2 {
            self.setImageTintColor(highlightType.textColor)
        } else {
            self.setImageTintColorDefault()
        }
        self.layer.borderColor = strokeColor.cgColor
        
    }
    
    func disabled() {
        self.backgroundColor = bgColor
        self.setTitleColor(textColor, for: .normal)
        self.setImageTintColorDefault()
        self.layer.borderColor = strokeColor.cgColor
    }
}

extension HighlightButon {
    
    func applyOutlineButton2Style() {
        self.strokeColor = .color_e6e6e6_7b7b7b
        self.bgColor = .color_fafafa_000000_15
        self.textColor = .color_b6b6b6_7b7b7b
        self.borderWidth = 1
        self.cornerRadius = 2
        self.highlightType = .outlineButton2
    }
    
    func applyBehaviorExchangeStyle() {
        self.strokeColor = .clear
        self.bgColor = .color_fafafa_181818
        self.textColor = .color_424242_c8c8c8
        self.borderWidth = 1
        self.cornerRadius = 2
        self.highlightType = .behaviorExchange
    }
    
    func applyOutlineButton1Style() {
        self.bgColor = .clear
        self.strokeColor = UIColor.color_4231c8_6f6ff7
        self.textColor = UIColor.color_4231c8_6f6ff7
        self.borderWidth = 1
        self.cornerRadius = 2
        self.highlightType = .outlineButton1
    }
    
    func applySolidButtonStyle() {
        self.strokeColor = .clear
        self.bgColor = .color_fafafa_000000_15
        self.textColor = .color_b6b6b6_7b7b7b
        self.highlightType = .outlineButton2
    }
    
    func applyLightButtonStyle() {
        self.strokeColor = .clear
        self.bgColor = .color_eceaf9_1c1972
        self.textColor = .color_4231c8_6f6ff7
        self.highlightType = .lightButton
    }
    
    func applyGhostStyle() {
        self.strokeColor = .clear
        self.bgColor = .color_f5f5f5_282828
        self.textColor = .color_b6b6b6_7b7b7b
        self.highlightType = .ghostButton
    }
    
    func disabledLightButtonStyle() {
        self.backgroundColor = .color_eaeaea_424242
        self.setTitleColor(.color_b6b6b6_646464, for: .normal)
        self.layer.borderColor = UIColor.clear.cgColor
        self.setImageTintColorDefault()
    }
}
