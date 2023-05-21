
import UIKit

class WithdrawReviewViewController: BaseViewController {
    // MARK: - Properties
    var presenter: ViewToPresenterWithdrawReviewProtocol?

    @IBOutlet weak var receivedUSDLabel: UILabel!
    @IBOutlet weak var receivedValueLabel: UILabel!
    @IBOutlet weak var receivedTitleLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var networkFeeTitleLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var tagTitleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressTitleLabel: UILabel!
    @IBOutlet weak var chainTypeLabel: UILabel!
    @IBOutlet weak var chainTitleLabel: UILabel!
    @IBOutlet weak var withdrawButton: UIButton!
    @IBOutlet weak var stepview: WithdrawStepView!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
    }
    
    override func setupUI() {
        super.setupUI()
        setupNavigationBar(title: presenter?.withdrawRequest?.currency?.displayName ?? "",
                           titleLeftItem: "common_previous".Localizable())
    }
    
    func setupData() {
        let platformFee: WithdrawalFee? = presenter?.withdrawRequest?.networkFee
        let fee = platformFee?.currencyID == presenter?.withdrawRequest?.currency?.id ? (platformFee?.amount ?? "").toDouble() : 0
        let networkId = presenter?.withdrawRequest?.selectedPlatform?.currencyID ??  ""
        let amount = (presenter?.withdrawRequest?.amount ?? "").toDouble() - fee
        let fixRate = presenter?.withdrawRequest?.currency?.fixedRate ?? 0
        let receivedUSD = amount * fixRate
        let currency = presenter?.withdrawRequest?.currency?.id ?? ""
        let decimalNumber = [(platformFee?.amount ?? "").getDecimalCount(), (presenter?.withdrawRequest?.amount ?? "").getDecimalCount()].max() ?? 0

        chainTypeLabel.text = presenter?.withdrawRequest?.selectedPlatform?.displayName?.name?.localized ?? ""
        addressLabel.text = presenter?.withdrawRequest?.address
        tagLabel.text = presenter?.withdrawRequest?.destination_tag
        feeLabel.text = "\(fee) \(networkId)"
        let textReceived = isLanguageRightToLeft ? "\(currency) %.\(decimalNumber)f" : "%.\(decimalNumber)f \(currency)"
        receivedValueLabel.text = String(format: textReceived, amount)
        let textReceiUSD = isLanguageRightToLeft ? "≈USDT %.2f" : "≈%.2f USDT"
        receivedUSDLabel.text = String(format: textReceiUSD, receivedUSD)
        receivedUSDLabel.isHidden = currency == "USDT"

        let withdrawTitle = String(format: "activity_withdrawal_title".Localizable(),currency)
        withdrawButton.setTitle(withdrawTitle, for: .normal)
    }
    
    override func localizedString() {
        chainTitleLabel.text = "common_blockchaintype".Localizable()
        tagTitleLabel.text = "subaddress_destination_tag".Localizable()
        networkFeeTitleLabel.text = "common_networkfee".Localizable()
        addressTitleLabel.text = "fragment_withdrawal_withdrawaladdress".Localizable()
        receivedTitleLabel.text = "fragment_withdrawal_receiveamount".Localizable()
    }
    
    // MARK: - Actions
    @IBAction func withdraw(_ sender: UIButton) {
        presenter?.excuteWithdraw()
    }
}

extension WithdrawReviewViewController: PresenterToViewWithdrawReviewProtocol{
    // TODO: Implement View Output Methods
}
