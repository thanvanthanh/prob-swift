//
//  TitleViewNavigation.swift
//  Probit
//
//  Created by Thân Văn Thanh on 13/09/2022.
//

import UIKit

class TitleViewNavigation: BaseView {

    @IBOutlet weak var primaryTitle: UILabel!

    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPrimaryTitle(_ title: String) {
        primaryTitle?.text = title
    }
}
