
import UIKit

class ExchangeCell: UICollectionViewCell {
    
    @IBOutlet private weak var containerView: HighlightView!
    @IBOutlet private var exchange: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.backgroundColor = .color_f5f5f5_2a2a2a
        containerView.bgColor = .color_f5f5f5_2a2a2a
        containerView.highlightType = .ghostButton

    }
    
    func configureCell(_ data: Market) {
        guard let baseCurrencyID = data.baseCurrencyID, let quoteCurrencyID = data.quoteCurrencyID else { return }
        exchange.text = baseCurrencyID + "/" + quoteCurrencyID
    }
    
    func configureCell(_ data: String?) {
        exchange.text = data
    }
    
    func round() {
        let radius: CGFloat = contentView.frame.height * 2 / 3
        contentView.layer.cornerRadius = radius
        contentView.layer.masksToBounds = true
        layoutIfNeeded()
    }
    
    func setTextColor(color: UIColor?) {
        exchange.textColor = color
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = contentView.frame.height / 2
        contentView.layer.masksToBounds = true
        layoutIfNeeded()
    }
}
