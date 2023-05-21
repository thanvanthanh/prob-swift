//
//  BoosterView.swift
//  Probit
//
//  Created by Nguyen Quang on 03/10/2022.
//

import UIKit

class BoosterView: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configButton()
    }
    
    private func configButton() {
        self.semanticContentAttribute = .forceRightToLeft
        self.titleLabel?.font = .font(style: .medium, size: 10)
        self.contentEdgeInsets = .init(top: 3, left: 8, bottom: 3, right: 8)
        self.setTitle("\("tradecompetition_main_info_booster".Localizable()) ", for: .normal)
        unActiveView()
    }
    
    func unActiveView() {
        self.layer.borderWidth = 1
        self.backgroundColor = .clear
        self.tintColor = .init(hexString: "636363")
        self.setTitleColor(.init(hexString: "636363"), for: .normal)
        self.layer.borderColor = UIColor.init(hexString: "636363").cgColor
        self.setImage(UIImage(named: "ico_booster")?.withRenderingMode(.alwaysTemplate), for: .normal)
    }
    
    func activeView() {
        self.layer.borderWidth = 1
        self.backgroundColor = UIColor.Basic.red
        self.setTitleColor(.white, for: .normal)
        self.layer.borderColor = UIColor.clear.cgColor
        self.setTitle("\("tradecompetition_main_info_booster".Localizable()) ", for: .normal)
        self.setImage(UIImage(named: "ico_booster")?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = frame.height / 2
    }
}
