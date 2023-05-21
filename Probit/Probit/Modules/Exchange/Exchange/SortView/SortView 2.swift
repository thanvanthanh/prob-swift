//
//  SortView.swift
//  Probit
//
//  Created by Nguyen Quang on 26/08/2022.
//

import UIKit

class SortView: BaseView {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconUp: UIImageView!
    @IBOutlet weak var iconDown: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.cornerRadius = 3
        nameLabel.textColor = UIColor.Basic.grayText7
        containerView.backgroundColor = .init(hexString: "ECECEC")
        
        resetView()
        iconUp.image = UIImage(named: "ico_exchange_up")?.withRenderingMode(.alwaysTemplate)
        iconDown.image = UIImage(named: "ico_exchange_down")?.withRenderingMode(.alwaysTemplate)
    }
    
    func setTitle(_ title: String)  {
        nameLabel.text = title
    }

    func resetView() {
        iconUp.tintColor = UIColor.init(hexString: "B6B6B6")
        iconDown.tintColor = UIColor.init(hexString: "B6B6B6")
    }
    
    func sortUp() {
        iconUp.tintColor = UIColor.init(hexString: "424242")
        iconDown.tintColor = UIColor.init(hexString: "B6B6B6")
    }
    
    func sortDown() {
        iconUp.tintColor = UIColor.init(hexString: "B6B6B6")
        iconDown.tintColor = UIColor.init(hexString: "424242")
    }
}
