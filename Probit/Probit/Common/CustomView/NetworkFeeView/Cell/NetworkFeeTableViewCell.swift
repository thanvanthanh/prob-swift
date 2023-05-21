//
//  NetworkFeeTableViewCell.swift
//  Probit
//
//  Created by Dang Nguyen on 06/12/2022.
//

import UIKit

class NetworkFeeTableViewCell: BaseTableViewCell {

    @IBOutlet weak var feeValueLabel: UILabel!
    @IBOutlet weak var selectedImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func setupCell(object: Any) {
        guard let networkFeeArray = object as? [WithdrawalFee],
              let networkFee = networkFeeArray.first,
              let currentNetworkFee = networkFeeArray.last else { return }
        let selectedImageName = currentNetworkFee.currencyID == networkFee.currencyID ? "ico_kyc_radio_check" : "ico_radio_uncheck"
        let tintColor = currentNetworkFee.currencyID == networkFee.currencyID ? "color_4231c8_6f6ff7" : "color_646464"
        selectedImageView.image = UIImage.init(named: selectedImageName)
        selectedImageView.tintColor = UIColor.init(named: tintColor)
        feeValueLabel.text = "\(networkFee.amount ?? "0") \(networkFee.currencyID ?? "")"
    }
}
