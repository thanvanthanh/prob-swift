import UIKit

final class WalletCurrencyPlatformCell: BaseTableViewCell {
    
    struct Constant {
        static let totalSecureText = "*********"
        static let usdtValueSecureText = "***"
    }
    
    // MARK: - IBOutlet
    @IBOutlet private weak var icon: UIImageView!
    @IBOutlet private weak var id: UILabel!
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var total: CustomSecureTextField!
    @IBOutlet private weak var usdtValue: CustomSecureTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        total.secureText = Constant.totalSecureText
        usdtValue.secureText = Constant.usdtValueSecureText
    }
    
    override func setupRightToLeft(_ isRTL: Bool) {
        super.setupRightToLeft(isRTL)
        
        [id, name].forEach { $0?.textAlignment = isRTL ? .right : .left }
        [total, usdtValue].forEach { $0?.textAlignment = isRTL ? .left : .right }
    }
    
    func setupCell(object: Any, hideBalances: Bool = false) {
        guard let item = object as? WalletCurrency else {
            return
        }
        
        total.isUserInteractionEnabled = false
        usdtValue.isUserInteractionEnabled = false
        total.isSecure = hideBalances
        usdtValue.isSecure = hideBalances
        id.text = item.id
        name.text = item.displayName
        total.setText(item.total.fractionDigits())
        if item.total < 0.00000001 {
            total.setText("0.00000000")
        }
        if item.usdtValue == -1 {
            usdtValue.setText("-")
        } else {
            let normal = item.id == "USDT" ? "" : item.usdtValue.fractionDigits(max: 2) + " USDT"
            let rtl = item.id == "USDT" ? "" : "USDT " + item.usdtValue.fractionDigits(max: 2)
            let text = AppConstant.isLanguageRightToLeft ? rtl : normal
            usdtValue.setText(text)
        }
        icon.layer.cornerRadius = icon.frame.size.height / 2
        icon.loadCurrencyImage(item)
        [total, usdtValue].forEach { $0?.textAlignment = AppConstant.isLanguageRightToLeft ? .left : .right }
    }
}
