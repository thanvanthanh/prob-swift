//
//  IntroduceStepThree.swift
//  Probit
//
//  Created by Nguyen Quang on 20/09/2022.
//

import UIKit

class IntroduceStepThree: BaseView {
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
        contentLabel.text = "fragment_bannerviewpager_lastpage_content".Localizable()
    }
}
