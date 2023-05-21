//
//  IntroduceStepOne.swift
//  Probit
//
//  Created by Nguyen Quang on 20/09/2022.
//

import UIKit

class IntroduceStepOne: BaseView {
    @IBOutlet weak var stackView: UIStackView!
    
    override init() {
        super.init()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        setBackgroundColor(color: .clear)
        buildStackView()

    }
    
    private func buildStackView() {
        stackView.removeFullyAllArrangedSubviews()
        ["introduce_professional_title".Localizable().uppercased(),
         "introduce_digital_title".Localizable().uppercased(),
         "settings_app_currency".Localizable().uppercased(),
         "navigationbar_market".Localizable().uppercased()].forEach { element in
            let stepView = UILabel()
            stepView.text = element
            stepView.textColor = UIColor.Basic.lightbackground
            stepView.font = UIFont.boldSystemFont(ofSize: 14)
            stackView.addArrangedSubview(stepView)
        }
        let spacingView = UIView()
        spacingView.backgroundColor = .clear
        stackView.addArrangedSubview(spacingView)
    }
}

