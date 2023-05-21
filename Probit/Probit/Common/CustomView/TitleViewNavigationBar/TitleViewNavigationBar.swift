//
//  TitleViewNavigationBar.swift
//  Probit
//
//  Created by Thân Văn Thanh on 19/09/2022.
//

import UIKit

class TitleViewNavigationBar: BaseView {

    @IBOutlet weak var titleStackView: UIStackView!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    var title: String?
    var icon: String?
    var subTitle: String?
    
    func setupTitleView(title: String, subTitle: String?, icon: String?) {
        self.icon = icon
        self.title = title
        self.subTitle = subTitle
        
        titleLabel.text = title
        subTitleLabel.text = subTitle
        subTitleLabel.isHidden = subTitle == nil
        setBackgroundColor(color: .clear)
        if let icon = icon {
            avatarView.isHidden = false
            titleStackView.alignment = .leading
            guard let url = URL(string: icon) else {
                return
            }
            titleLabel.textAlignment = .left
            subTitleLabel.textAlignment = .left
            avatarView.sd_setImage(with: url, placeholderImage: UIImage(named: "ico_currency_default"))
        } else {
            titleLabel.textAlignment = .center
            subTitleLabel.textAlignment = .center
            titleStackView.alignment = .center
            avatarView.isHidden = true
            
        }
        
    }
}
