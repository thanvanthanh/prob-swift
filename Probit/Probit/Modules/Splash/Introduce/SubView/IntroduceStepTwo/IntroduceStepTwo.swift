//
//  IntroduceStepTwo.swift
//  Probit
//
//  Created by Nguyen Quang on 20/09/2022.
//

import UIKit

class IntroduceStepTwo: BaseView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override init() {
        super.init()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        setBackgroundColor(color: .clear)
        titleLabel.textColor = UIColor.Basic.white
        contentLabel.textColor = UIColor.Basic.lightbackground.withAlphaComponent(0.7)
        titleLabel.text = "fragment_bannerviewpager_02_title".Localizable()
        contentLabel.text = "fragment_bannerviewpager_02_content".Localizable()
    }
}
