//
//  EventAirdropsTableViewCell.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 26/12/2565 BE.
//

import UIKit

class EventAirdropsTableViewCell: BaseTableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageBanner: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func setupCell(object: Any, indexPath: IndexPath? = nil) {
        guard let data = object as? EventAirdropModel else { return  }
        imageBanner.setImage(data.locale?.localized?.imgURL ?? "")
        titleLabel.text = data.locale?.localized?.title
        let startDate =  data.startTime?.toDate()?.stringFromDateWithSemantic(timeFormat: "", gmtFormat: "") ?? ""
        let endDate = data.endTime?.toDate()?.stringFromDateWithSemantic(timeFormat: "") ?? ""
        dateLabel.text = AppConstant.isLanguageRightToLeft ? "\(endDate) ~ \(startDate)" : "\(startDate) ~ \(endDate)"
    }
}
