//
//  HomeTableViewCell.swift
//  Probit
//
//  Created by Nguyen Quang on 24/08/2022.
//

import UIKit

class HomeTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var acronymLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarView.image = nil
        titleLabel.text = nil
        acronymLabel.text = nil
        priceLabel.text = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func setupCell(object: Any) {
        if let model = object as? NewCoins {
            titleLabel.text = model.name
            acronymLabel.text = model.id
            if let urlString = model.urlString, let url = URL(string: urlString) {
                avatarView.sd_setImage(with: url)
            }
            acronymLabel.text = model.id
            priceLabel.text = "\(model.usdtRate ?? "--") USDT"
        }
        if let model = object as? ExchangeTicker {
            acronymLabel.text = model.id
            titleLabel.text = model.displayName
            guard let baseCurrencyID = model.baseCurrencyId,
                  let quoteCurrencyID = model.quoteCurrencyId else {
                return
            }
            LoadImageUrl.shared.cryptoCurrencyImage(with: baseCurrencyID, in: avatarView)
            acronymLabel.text = "\(baseCurrencyID)/\(quoteCurrencyID)"
            priceLabel.text = model.quoteRate.doubleValue()?.fractionDigits(min: 2, max: 10, roundingMode: .ceiling)
        }
    }
    
    func updatePrice(usdtRate: String?, quoteCurrencyID: String? = nil) {
        if quoteCurrencyID == nil {
            priceLabel.text = "\(usdtRate ?? "--") USDT"
        } else {
            priceLabel.text = usdtRate?.doubleValue()?.fractionDigits(min: 2, max: 10, roundingMode: .ceiling)
        }
    }
    
}
