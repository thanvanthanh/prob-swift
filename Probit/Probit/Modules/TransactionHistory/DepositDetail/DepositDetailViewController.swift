//
//  DepositDetailViewController.swift
//  Probit
//
//  Created by Dang Nguyen on 28/10/2022.
//  
//

import UIKit

class DepositDetailViewController: BaseViewController {
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var statutsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var coinConvertLabel: UILabel!
    @IBOutlet weak var blockchainTypeLabel: UILabel!
    @IBOutlet weak var blockchainLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountValueLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressValueLabel: UILabel!
    @IBOutlet weak var destinationTagLabel: UILabel!
    @IBOutlet weak var destinationTagView: UIView!
    @IBOutlet weak var detinationTagValueLabel: UILabel!
    @IBOutlet weak var TXIDLabel: UILabel!
    @IBOutlet weak var TXIDValueLabel: UILabel!
    @IBOutlet weak var showInExplorerButton: HighlightButon!
    @IBOutlet weak var updatedTimeLabel: UILabel!
    @IBOutlet weak var copyTXIDButton: UIButton!
    
    var circleView: CircleProgressView?
    
    // MARK: - Properties
    var presenter: ViewToPresenterDepositDetailProtocol?
    
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
        setupNavigationBar(title: String.init(format: "deposit_detail_title".Localizable(), presenter?.interactor?.transactionHistory.currency_id ?? ""),
                           titleLeftItem: "common_previous".Localizable())
        self.addCircleview()
        showInExplorerButton.applyLightButtonStyle()
        presenter?.setupTransaction()
        presenter?.getExplorerCoreDeposit()
    }
    
    override func localizedString() {
        blockchainTypeLabel.text = "activity_currencytransferhistorydetails_table_blockchaintype".Localizable()
        if presenter?.shouldOpenWebBrowser() ?? false {
            blockchainTypeLabel.text = "buycrypto_confirmpayment_payinfo_serviceprovider_title".Localizable()
        }
        amountLabel.text = "activity_withdrawal_textindicator1".Localizable()
        addressLabel.text = "activity_currencytransferhistorydetails_table_address".Localizable()
        destinationTagLabel.text = "subaddress_destination_tag".Localizable()
        TXIDLabel.text = "activity_currencytransferhistorydetails_table_txid".Localizable()
        showInExplorerButton.setTitle("activity_currencytransferhistorydetails_openexplorer".Localizable(), for: .normal)
        copyTXIDButton.setTitle("activity_currencytransferhistorydetails_copytxid".Localizable(), for: .normal)
    }
    
    private func addCircleview() {
        self.circleView = CircleProgressView(frame: progressView.bounds, lineWidth: 4, rounded: false)
        circleView?.trackColor = UIColor.color_d2d2d2_424242
        circleView?.progressColor = UIColor.color_12c479
        if let _circleView = circleView {
            self.progressView.addSubview(_circleView)
        }
    }
    
    override func setupDarkMode() {
        super.setupDarkMode()
        showInExplorerButton.borderColor = UIColor.color_4231c8_6f6ff7
    }
    
    func setupProgress(progress: Float) {
        circleView?.progress = progress
    }
    
    @IBAction func showInExplorer(_ sender: UIButton) {
        let shouldOpenWebView = presenter?.shouldOpenWebBrowser() ?? false
        if shouldOpenWebView {
            showPopupHelper("dialog_notice".Localizable(),
                            message: "dialog_navigateaway_content".Localizable(),
                            acceptTitle: "dialog_go".Localizable(),
                            cancleTitle: "dialog_cancel".Localizable(),
                            acceptAction: { [weak self] in
                guard let `self` = self else { return }
                self.presenter?.openTxidWebBrowser()
            }, cancelAction: nil)
        }
    }
    
    @IBAction func copyTXID(_ sender: UIButton) {
        guard let transactionId = presenter?.interactor?.transactionHistory.id else { return }
        UIPasteboard.general.string = transactionId
        showSuccess(message: "copy_to_clipboard_toast".Localizable())
    }
}

extension DepositDetailViewController: PresenterToViewDepositDetailProtocol{
    
    func setupTransaction(transaction: TransactionHistory) {
        let transactionTime         = transaction.date?.stringFromDateWithSemantic() ?? ""
        let confirmingTransaction   = Float(transaction.confirmations ?? 0)
        let currency                = presenter?.interactor?.currency
        let platform                = currency?.platform.first(where: { $0.id == transaction.platform_id })
        let minConfirmationCount    = platform?.minConfirmationCount ?? 22
        let percent: Float =  transaction.status == .done || transaction.status == .confirmed ? 1 : confirmingTransaction/Float(minConfirmationCount)
        let amountString   = "\(transaction.amount ?? "") \(transaction.currency_id ?? "")"
        let amountAttributed = NSMutableAttributedString.init(string: amountString)
        if transaction.status == TransactionStatus.canceled {
            amountAttributed.strikethrough(subString: transaction.amount ?? "")
        }
        
        timeLabel.text              = transactionTime
        updatedTimeLabel.text       = transactionTime
        addressValueLabel.text      = transaction.address
        detinationTagValueLabel.text = transaction.destination_tag
        TXIDValueLabel.text         = transaction.hash
        coinLabel.text              = currency?.id
        coinConvertLabel.text       = "(\(currency?.displayName ?? ""))"
        percentLabel.text           = String(format: "%.0f%@", percent * 100,"%")
        percentLabel.textColor      = percent == 1 ? UIColor.color_12c479 : UIColor.color_7b7b7b
        statutsLabel.text           = transaction.exportStatus().0
        blockchainLabel.text        = platform?.displayName?.name?.localized
        amountValueLabel.attributedText = amountAttributed
        setupProgress(progress: percent)
        if presenter?.shouldOpenWebBrowser() ?? false {
            showInExplorerButton.isHidden = false
        }
        if transaction.destination_tag != nil && transaction.destination_tag != "" {
            destinationTagView.isHidden = false
        }
        addressValueLabel.addTapGesture { [weak self] in
            guard let `self` = self else { return }
            self.openAddressWebBrowser()
        }
        TXIDValueLabel.addTapGesture { [weak self] in
            guard let `self` = self else { return }
            self.openTxidWebBrowser()
        }
    }
    
    private func openTxidWebBrowser() {
        showPopupHelper("dialog_notice".Localizable(),
                        message: "dialog_navigateaway_content".Localizable(),
                        acceptTitle: "dialog_go".Localizable(),
                        cancleTitle: "dialog_cancel".Localizable(),
                        acceptAction: { [weak self] in
            guard let `self` = self else { return }
            self.presenter?.openTxidWebBrowser()
        }, cancelAction: nil)
    }
    
    private func openAddressWebBrowser() {
        showPopupHelper("dialog_notice".Localizable(),
                        message: "dialog_navigateaway_content".Localizable(),
                        acceptTitle: "dialog_go".Localizable(),
                        cancleTitle: "dialog_cancel".Localizable(),
                        acceptAction: { [weak self] in
            guard let `self` = self else { return }
            self.presenter?.openAddressWebBrowser()
        }, cancelAction: nil)
    }
}
