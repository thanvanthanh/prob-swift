//
//  RejectMessageView.swift
//  Probit
//
//  Created by Thân Văn Thanh on 05/10/2022.
//

import UIKit

class RejectMessageView: BaseView {

    @IBOutlet weak var messageTitle: UILabel!
   
    override init() {
        super.init()
    }
    
    func configView(count: String, data: String) {
        messageTitle.text = "\(count). \(data)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
