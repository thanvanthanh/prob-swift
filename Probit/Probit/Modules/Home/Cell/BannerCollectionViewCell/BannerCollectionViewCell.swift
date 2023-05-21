//
//  BannerCollectionViewCell.swift
//  Probit
//
//  Created by Nguyen Quang on 24/08/2022.
//

import UIKit
import SDWebImage

class BannerCollectionViewCell: BaseCollectionViewCell {
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var ieoContentView: UIStackView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ieoContentView.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bannerImage.image = nil
        titleLabel.text = nil
        contentLabel.text = nil
    }

    override func setupCell(object: Any) {
        guard let model = object as? HomeBannerModel else {
            return
        }
        ieoContentView.isHidden = model.type == .normal
        titleLabel.text = model.landingName
        contentLabel.text = model.landingTagline
        if let urlString = model.urlLink, let url = URL(string: urlString) {
            bannerImage.sd_setImage(with: url)
        }
        if let urlString = model.landingIcon, let url = URL(string: urlString) {
            logoImage.sd_setImage(with: url)
        }
    }
}
