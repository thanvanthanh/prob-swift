//
//  ListSupportedTableViewCell.swift
//  Probit
//
//  Created by Thân Văn Thanh on 24/08/2022.
//

import UIKit

class ListSupportedTableViewCell: BaseTableViewCell {

    @IBOutlet private weak var iconsImage: UIImageView!
    @IBOutlet private weak var checkMarkIcon: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var subNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        checkMarkIcon.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setupCell(object: Any) {
        if let model = object as? ListSupported {
            nameLabel.text = model.name
            subNameLabel.text = model.subName
            switch model.type {
            case .fiat:
                LoadImageUrl.shared.fiatCurrency(with: model.name.value,in: iconsImage)
            case .crypto:
                LoadImageUrl.shared.cryptoCurrencyImage(with: model.name.value,
                                                        in: iconsImage)
            case .none: break
            }
            return
        }
        
        if let model = object as? ItemSelectModel {
            nameLabel.text = model.title
            subNameLabel.text = model.subTitle
            LoadImageUrl.shared.cryptoCurrencyImage(with: model.id,
                                                    in: iconsImage)
        }
    }
    
    func showCheckMark( _ isHiden: Bool) {
        checkMarkIcon.isHidden = !isHiden
        backgroundColor = isHiden ? UIColor.color_e6e6e6_282828 : .clear
    }
}
