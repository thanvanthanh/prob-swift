//
//  PeriodCollectionViewCell.swift
//
//  Created by Apple on 4/5/21.
//  Copyright © 2021 eMPI. All rights reserved.
//

import UIKit
class PeriodCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var imgSucces: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func binData(_ rule : Rule,
                 _ isSelected: Bool){
        if let time = rule.cond?.period {
            lbName.text = time.hourToString
        }
        if isSelected {
            viewContent.backgroundColor = UIColor.color_4231c8_6f6ff7
            lbName.textColor = UIColor(hexString: "#FAFAFA")
            imgSucces.isHidden = false
        } else {
            viewContent.backgroundColor = UIColor.color_f5f5f5_2a2a2a
            lbName.textColor = UIColor.color_646464_7b7b7b
            imgSucces.isHidden = true
        }
    }
}
