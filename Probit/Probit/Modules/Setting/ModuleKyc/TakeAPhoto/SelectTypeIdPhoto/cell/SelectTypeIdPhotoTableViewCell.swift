//
//  SelectTypeIdPhotoTableViewCell.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 09/11/2565 BE.
//

import UIKit

class SelectTypeIdPhotoTableViewCell: BaseTableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet private weak var checkBoxImageView: UIImageView!

    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var iconImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ with: TypeCardId, isSelected: Bool) {
        if isSelected {
            self.viewContent.backgroundColor = UIColor(hexString: "#4231C8").withAlphaComponent(0.05)
            self.viewContent.borderColor = UIColor.color_4231c8_6f6ff7
            self.titleLabel.textColor = UIColor.color_4231c8_6f6ff7
            self.iconImage.image = with.icon?.withTintColor(UIColor.color_4231c8_6f6ff7)
        } else {
            self.viewContent.backgroundColor = .clear
            self.viewContent.borderColor = UIColor.color_e6e6e6_424242
            self.titleLabel.textColor = UIColor.color_646464_fafafa
            self.iconImage.image = with.icon?.withTintColor(UIColor.color_b6b6b6_fafafa)
        }
        self.titleLabel.text = with.title.firstUppercased
        self.acceptStakeAutomatically(isSelected)
    }
    
    func acceptStakeAutomatically(_ isSelected: Bool) {
        if isSelected {
            checkBoxImageView.image = UIImage(named: "ico_kyc_radio_check")
            checkBoxImageView.tintColor = UIColor.color_4231c8_6f6ff7
        } else {
            checkBoxImageView.image = UIImage(named: "ico_kyc_radio_uncheck")
            checkBoxImageView.tintColor = UIColor.color_646464_7b7b7b

        }
    }
    
}
