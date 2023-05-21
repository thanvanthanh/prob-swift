
import UIKit

class WithdrawDetailViewController: BaseViewController {
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var confirmationsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var coinDescriptionLabel: UILabel!
    @IBOutlet weak var blockchainTypeLabel: UILabel!
    @IBOutlet weak var blockchainValueLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountValueLabel: UILabel!
    @IBOutlet weak var withdrawLabel: UILabel!
    @IBOutlet weak var withdrawFeeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressValueLabel: UILabel!
    @IBOutlet weak var destinationTagView: UIView!
    @IBOutlet weak var destinationTagLabel: UILabel!
    @IBOutlet weak var destinaltionValueLabel: UILabel!
    @IBOutlet weak var TXIDLabel: UILabel!
    @IBOutlet weak var TXIDValueLabel: UILabel!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    @IBOutlet weak var checkExplorerButton: UIButton!
    @IBOutlet weak var copyTXIDButton: HighlightButon!
    @IBOutlet weak var cancelWarningView: UIView!
    @IBOutlet weak var actionView: UIView!

    // MARK: - Properties
    var presenter: ViewToPresenterWithdrawDetailProtocol?
    var circleView: CircleProgressView?

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.presenter?.viewWillDisappear()
    }

    override func setupUI() {
        super.setupUI()
        setupNavigationBar(title: String.init(format: "Withdrawal_detail_title".Localizable(), presenter?.interactor?.transactionHistory.currency_id ?? ""),
                           titleLeftItem: "common_previous".Localizable())
        presenter?.setupTransaction()
        destinationTagView.isHidden = true
        self.addCircleview()
//        checkExplorerButton.applyLightButtonStyle()
    }
    
    override func localizedString() {
        blockchainTypeLabel.text = "activity_currencytransferhistorydetails_table_blockchaintype".Localizable()
        amountLabel.text = "activity_withdrawal_textindicator1".Localizable()
        withdrawLabel.text = "common_withdrawalfee".Localizable()
        addressLabel.text = "activity_currencytransferhistorydetails_table_address".Localizable()
        destinationTagLabel.text = "subaddress_destination_tag".Localizable()
        TXIDLabel.text = "activity_currencytransferhistorydetails_table_txid".Localizable()
        checkExplorerButton.setTitle("activity_currencytransferhistorydetails_openexplorer".Localizable(), for: .normal)
        copyTXIDButton.setTitle("activity_currencytransferhistorydetails_copytxid".Localizable(), for: .normal)
    }
    
    override func setupDarkMode() {
        super.setupDarkMode()
        copyTXIDButton.borderColor = UIColor.color_4231c8_6f6ff7
    }
    
    
    private func addCircleview() {
        self.circleView = CircleProgressView(frame: progressView.bounds, lineWidth: 4, rounded: false)
        circleView?.trackColor = UIColor.color_d2d2d2_424242
        circleView?.progressColor = UIColor.color_12c479
        if let _circleView = circleView {
            self.progressView.addSubview(_circleView)
        }
    }

    func setupProgress(progress: Float) {
        circleView?.progress = progress
    }
    
    @IBAction func copyTXID(_ sender: UIButton) {
        guard let transactionId = presenter?.interactor?.transactionHistory.id else { return }
        UIPasteboard.general.string = transactionId
        showSuccess(message: "copy_to_clipboard_toast".Localizable())
    }
    
    @IBAction func checkExplorer(_ sender: UIButton) {
        let shouldOpenWebView = presenter?.shouldOpenWebBrowser() ?? false
        if shouldOpenWebView {
            showPopupHelper("dialog_notice".Localizable(),
                            message: "dialog_navigateaway_content".Localizable(),
                            acceptTitle: "dialog_go".Localizable(),
                            cancleTitle: "dialog_cancel".Localizable(),
                            acceptAction: { [weak self] in
                guard let `self` = self, let hash = self.TXIDValueLabel.text else { return }
                self.presenter?.openTxidWebBrowser(txid: hash)
            }, cancelAction: nil)
        }
    }
}

extension WithdrawDetailViewController: PresenterToViewWithdrawDetailProtocol{
    func setupTransaction(transaction: TransactionHistory) {
        let transactionTime         = transaction.date?.stringFromDateWithSemantic() ?? ""
        let confirmingTransaction   = transaction.confirmations ?? 0
        let currency                = presenter?.interactor?.currency
        let platform                = currency?.platform.first(where: { $0.id == transaction.platform_id })
        let minConfirmationCount    = platform?.minConfirmationCount ?? 22
        let confirmations = String(format: "activity_currencytransferhistorydetails_confirmationcount".Localizable(),
                                   "\(confirmingTransaction)",
                                   "\(minConfirmationCount)")
        let percent: Float =  transaction.status == .done || transaction.status == .confirmed ? 1 : Float(confirmingTransaction)/Float(minConfirmationCount)
        let amountString   = "\(transaction.amount ?? "") \(transaction.currency_id ?? "")"
        let amountAttributed = NSMutableAttributedString.init(string: amountString)
        let feeString   = "\(transaction.fee ?? "") \(transaction.currency_id ?? "")"
        let feeAttributed = NSMutableAttributedString.init(string: feeString)

        if transaction.status == TransactionStatus.canceled {
            amountAttributed.strikethrough(subString: amountString)
            feeAttributed.strikethrough(subString: feeString)
        }

        timeLabel.text              = transactionTime
        addressValueLabel.text      = transaction.address
        TXIDValueLabel.text         = transaction.hash
        destinaltionValueLabel.text = transaction.destination_tag
        coinLabel.text              = transaction.currency_id
        coinDescriptionLabel.text   = "(\(currency?.displayName ?? ""))"
        actionView.isHidden         = transaction.hash == nil
        blockchainValueLabel.text   = platform?.displayName?.name?.localized
        confirmationsLabel.text     = confirmations
        cancelWarningView.isHidden  = transaction.status != TransactionStatus.canceled
        lastUpdateLabel.text        = String(format: "fragment_walletdetailsv2_coin_lastupdated".Localizable(), transactionTime)
        percentLabel.text           = String(format: "%.0f%@", percent*100,"%")
        percentLabel.textColor      = percent == 1 ? UIColor.color_12c479 : UIColor.color_7b7b7b
        statusLabel.text            = transaction.exportStatus(isDetail: true).0
        confirmationsLabel.isHidden = transaction.status == .canceled || transaction.status == .done
        amountValueLabel.attributedText = amountAttributed
        withdrawFeeLabel.attributedText = feeAttributed
//        destinationTagView.isHidden = transaction.destination_tag == nil
        if transaction.destination_tag != nil && transaction.destination_tag != "" {
            destinationTagView.isHidden = false
        }
        setupProgress(progress: percent)
    }
}
