//
//  ThirdPartyTableViewCell.swift
//  Probit
//
//  Created by Thân Văn Thanh on 08/12/2022.
//

import UIKit

class ThirdPartyTableViewCell: BaseTableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }
    
    override func setupCell(object: Any) {
        guard let model = object as? ThirdParty else { return }
        titleLabel.text = model.title
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
