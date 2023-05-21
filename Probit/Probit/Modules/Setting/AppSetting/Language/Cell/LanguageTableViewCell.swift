//
//  LanguageTableViewCell.swift
//  Probit
//
//  Created by Thân Văn Thanh on 31/08/2022.
//

import UIKit

class LanguageTableViewCell: BaseTableViewCell {

    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setupCell(object: Any) {
        guard let model = object as? Language,
              let isSelected = model.isSelected else { return }
        languageLabel.text = model.name.firstUppercased
        languageLabel.font = isSelected ? .medium(size: 16) : .primary(size: 16)
        languageLabel.textColor = isSelected ? UIColor.color_424242_fafafa : UIColor.color_b6b6b6_7b7b7b
        checkImage.isHidden = !(isSelected)
        isUserInteractionEnabled = !(isSelected)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
