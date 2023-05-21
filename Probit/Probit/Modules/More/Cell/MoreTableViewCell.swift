//
//  MoreTableViewCell.swift
//  Probit
//
//  Created by Nguyen Quang on 21/09/2022.
//

import UIKit

class MoreTableViewCell: BaseTableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = UIColor.color_fafafa_181818
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func setupCell(object: Any) {
        guard let model = object as? MoreItem else { return }
        nameLabel.text = model.title
        iconView.image = model.icon
    }
}
