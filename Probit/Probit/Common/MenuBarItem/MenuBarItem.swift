//
//  MenuBarItem.swift
//  Probit
//
//  Created by Nguyen Quang on 25/08/2022.
//

import UIKit

class MenuBarItem: BaseCollectionViewCell {

    @IBOutlet weak var containerLabel: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favoritesIcon: UIImageView!
    @IBOutlet weak var spacingBottomView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setupCell(object: Any) {
        guard let model = object as? MenuBar else { return }
        containerLabel.isHidden = model.name == nil
        favoritesIcon.isHidden = model.name != nil

        nameLabel.text = model.name
        favoritesIcon.image = model.isSelected ? UIImage(named: "ico_favorite") : UIImage(named: "ico_not_favorite")
        nameLabel.textColor = model.isSelected ? UIColor.color_4231c8_6f6ff7 : UIColor.color_b6b6b6_7b7b7b
    }
}
    
