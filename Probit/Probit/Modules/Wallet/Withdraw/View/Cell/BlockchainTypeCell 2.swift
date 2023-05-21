//
//  BlockchainTypeCell.swift
//  Probit
//
//  Created by NEMO on 18/10/2022.
//

import UIKit

class BlockchainTypeCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(_ with: String, isSelected: Bool) {
        var color = UIColor.clear
        if isSelected {
            color = UIColor(hexString: "#4231C8")
        } else {
            color = UIColor(hexString: "#C8C8C8")
        }
        label.textColor = color
        label.borderColor = color
        label.text = with
    }
    
    @IBOutlet private var label: UILabel!
}
