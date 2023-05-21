//
//  CarouselSectionViewCell.swift
//  Probit
//
//  Created by Nguyen Quang on 29/09/2022.
//

import UIKit

class CarouselSectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var stateButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bannerImage.layer.cornerRadius = 4
        bannerImage.clipsToBounds = true
        stateButton.setTitleColor(UIColor.Basic.blue, for: .normal)
        stateButton.titleLabel?.font = .font(style: .medium, size: 14)
    }
    
    func setupCell(model: CarouselModel) {
        nameLabel.text = model.title
        timeLabel.text = model.description
        bannerImage.image = UIImage(named: "img_announcement")
        stateButton.setTitle(model.rate, for: .normal)
    }

}
