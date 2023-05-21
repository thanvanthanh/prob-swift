
import UIKit

class TransactionHistoryTableViewCell: BaseTableViewCell {
    @IBOutlet weak var statustView: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var convertUSDTLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var detailStackView: UIStackView!
    @IBOutlet weak var iconNextDetail: UIImageView!
    
    var transaction: TransactionHistory?
    var currency: WalletCurrency?
    var cancelRequestAction: ((String) -> Void)?
    var detailAction: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        detailLabel.text = "tradecompetition_main_starttrading_buttomsheet_warning_seedetail".Localizable()
        detailStackView.addTapGesture() { [weak self] in
            guard let `self` = self else { return }
            self.detailAction?()
        }
        
        statusLabel.addTapGesture(action: {
            guard let transaction = self.transaction,
                  let id = transaction.id,
                  transaction.status == TransactionStatus.requested,
                  let cancelAction = self.cancelRequestAction else { return }
            cancelAction(id)
        })
        valueLabel.textAlignment = AppConstant.isLanguageRightToLeft ? .left : .right
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func setupCell(object: Any) {
        guard let information = object as? [AnyObject],
              let transaction = information.first as? TransactionHistory,
              let currency = information.last as? WalletCurrency else { return }
        self.transaction = transaction
        self.currency = currency
        let isDeposit = transaction.type == TransactionType.deposit.rawValue
        
        let type = isDeposit ? "activity_currencytransferhistory_tab_deposit" : "activity_currencytransferhistory_tab_withdrawal"
        typeLabel.text = type.Localizable()
        valueLabel.text = transaction.amount ?? ""
        timeLabel.text = transaction.time?.toDate()?.stringFromDateWithSemantic()
        /// Detect transaction status
        let status = transaction.status ?? .done
        var statusColor = isDeposit ? UIColor.color_12c479 : UIColor.color_f25d4e
        
        /// Convert to USDT
        let amount = Double(transaction.amount ?? "") ?? 1
        let fixRate = currency.fixedRate ?? 1
        let usdValue    = (amount * fixRate).roundToDecimal(max: 2)
        var receivedUSD = "\(usdValue)".replaceCurrency()
        let receivedUSDStr = AppConstant.isLanguageRightToLeft ? "≈ USDT %@ " : "≈ %@ USDT"
        receivedUSD = (amount * fixRate) > 0 ? String(format: receivedUSDStr, receivedUSD) : "-"
        convertUSDTLabel.text = receivedUSD
        
        let imageDetail = AppConstant.isLanguageRightToLeft ? "ico_pre_detail_arrow" : "ico_next_detail_arrow"
        iconNextDetail.image = UIImage(named: imageDetail)
        
        var confirmingStatus = ""
        var statusString = "transferdistributionhistoryadapter_requested".Localizable()
        let platform = currency.platform.first(where: { $0.id == transaction.platform_id })
        switch status {
            case TransactionStatus.done:
                statusString = "transferdistributionhistoryadapter_done".Localizable()
                statusColor = isDeposit ? UIColor.color_green500 : UIColor.color_orange500
            case TransactionStatus.canceled:
                statusString = "transferdistributionhistoryadapter_cancelled".Localizable()
                statusColor = UIColor.color_gray500
            case .cancelling:
                statusString = "transferdistributionhistoryadapter_cancelled".Localizable()
                statusColor = UIColor.color_gray500
            case .requested:
                statusString = "transferdistributionhistoryadapter_withdrawalcancel".Localizable()
                statusColor = isDeposit ? UIColor.color_green300 : UIColor.color_orange300
                break
            case .pending, .applying, .confirmed, .confirming:
                statusString = "transferdistributionhistoryadapter_processing".Localizable()
                statusColor = isDeposit ? UIColor.color_green300 : UIColor.color_orange300
                break
            case .failed:
                statusString = "transferdistributionhistoryadapter_failed".Localizable()
                statusColor = UIColor.color_gray500
                break
        }
        if statusString == "transferdistributionhistoryadapter_processing".Localizable() {
            confirmingStatus = "(\(transaction.confirmations ?? 0)/\(platform?.minConfirmationCount ?? 22))"
        }
        
        let attributeString = NSMutableAttributedString.init(string: "\(statusString) \(confirmingStatus)")
        attributeString.apply(color: UIColor.color_f25d4e, subString: confirmingStatus)
        if status == .requested {
            attributeString.underLine(subString: statusString)
        }
        statusLabel.attributedText = attributeString
        statustView.backgroundColor = statusColor
    }
}
