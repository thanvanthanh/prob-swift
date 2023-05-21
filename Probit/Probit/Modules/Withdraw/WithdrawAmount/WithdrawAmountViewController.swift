
import UIKit

class WithdrawAmountViewController: BaseViewController {
    
    @IBOutlet weak var limitLabel: UILabel!
    @IBOutlet weak var receivedAmountValueLabel: UILabel!
    @IBOutlet weak var receivedAmountTitleLabel: UILabel!
    @IBOutlet weak var networkFeeTitleLabel: UILabel!
    @IBOutlet weak var networkFeeTypeLabel: UILabel!
    @IBOutlet weak var networkFeeValueLabel: UILabel!
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var withdrawAmountLabel: UILabel!
    @IBOutlet weak var availableValueLabel: UILabel!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var availableBalanceLabel: UILabel!
    @IBOutlet weak var chainTypeLabel: UILabel!
    @IBOutlet weak var networkFeeView: UIView!
    @IBOutlet weak var withdrawAmountTextField: StyleTextField!
    @IBOutlet weak var chainTypeCollectionView: UICollectionView!
    @IBOutlet weak var nextButton: StyleButton!
    @IBOutlet weak var usdValueLabel: UILabel!
    @IBOutlet weak var percentButton: HighlightButon!
    @IBOutlet weak var cautionsView: CautionsView!
    @IBOutlet weak var feeArrowImageView: UIImageView!
    @IBOutlet weak var networkFeeButton: UIButton!
    @IBOutlet weak var amountView2: UIView!
    @IBOutlet weak var myCollectionViewHeight: NSLayoutConstraint!
    // MARK: - Properties
    var presenter: ViewToPresenterWithdrawAmountProtocol?
    let itemSize = CGSize(width: 76, height: 38)
    private var collectionViewDelegate: BaseCollectionViewDataSource<DateTypeRateCollectionViewCell>?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        presenter?.getConfiguration()
    }
    
    // MARK: - Setup UI
    override func setupUI() {
        super.setupUI()
        hideKeyboardWhenTappedAround(isCancelTouchInView: false)
        nextButton.setEnable(isEnable: nextButton.isEnabled)
        setupChainType()
        setupCautions()
        let title = String(format: "activity_withdrawal_title".Localizable(),presenter?.currency?.id ?? "")
        let icon = String(format: CurrencyIconType.crypto.url, presenter?.currency?.id ?? "")
        setupNavigationBar(title: title,
                           icon: icon,
                           titleLeftItem: "common_previous".Localizable())
        percentButton.backgroundColor = .color_f5f5f5_282828
//        percentButton.addLongPressGhostButton()
        percentButton.applyGhostStyle()
        
        withdrawAmountTextField.delegateFC = self
        withdrawAmountTextField.isCustomColor = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = chainTypeCollectionView.collectionViewLayout.collectionViewContentSize.height
        myCollectionViewHeight.constant = height
        self.view.layoutIfNeeded()
    }
    
    override func setupRightToLeft(_ isRTL: Bool) {
        super.setupRightToLeft(isRTL)
        [availableValueLabel, receivedAmountTitleLabel].forEach { $0.textAlignment = isRTL ? .left : .right }
        withdrawAmountTextField.textAlignment = isRTL ? .left : .right
    }
    
    override func localizedString() {
        super.localizedString()
        chainTypeLabel.text = "common_blockchaintype".Localizable()
        coinLabel.text = presenter?.currency?.id
        withdrawAmountLabel.text = "fragment_withdrawal_withdrawalamount".Localizable()
        receivedAmountTitleLabel.text = "fragment_withdrawal_receiveamount".Localizable()
        chainTypeLabel.text = "activity_currencytransferhistorydetails_table_blockchaintype".Localizable()
        availableBalanceLabel.text = "activity_walletdetails_availablebalance".Localizable()
        networkFeeTitleLabel.text = "common_networkfee".Localizable()
        nextButton.setTitle("common_next".Localizable(), for: .normal)
        let limitValue = presenter?.interactor?.withdrawalLimit?.available?.currencyFormatting() ?? "5,000"
        let limitCurrencyId = presenter?.interactor?.withdrawalLimit?.currency ?? "USDT"
        limitLabel.text = String.init(format: "fragment_withdrawal_amount_24hrlimit_hint".Localizable(),
                                      "\(limitValue) \(limitCurrencyId)")
        percentButton.setTitle("100%", for: .normal)
    }
    
    override func setupDarkMode() {
        super.setupDarkMode()
        if amountView.borderColor != UIColor.color_f25d4e {
            amountView.borderColor = UIColor.color_e6e6e6_646464
        }
        networkFeeView.borderColor = UIColor.color_e6e6e6_646464
        chainTypeCollectionView.reloadData()
    }
    
    func setupCautions() {
        let platform = presenter?.interactor?.currency?.currency?.platform?.first(where: {$0.id == presenter?.interactor?.platformSelected?.id})
        let platformFee: WithdrawalFee? = presenter?.interactor?.networkFeeSelected
        let fee = platformFee?.currencyID == presenter?.interactor?.currency?.id ? (platformFee?.amount ?? "").toDouble() : 0
        cautionsView.setupCautionsView(currencyId: presenter?.currency?.id ?? "",
                                       platform: platform, feeWithdraw: fee.asString())
    }
    
    // MARK: - Setup Data
    func setupData(amountString: String = "") {
        let platformFee: WithdrawalFee? = presenter?.interactor?.networkFeeSelected
        let isEmptyValue = amountString.isEmpty
        let amount = platformFee?.amount ?? ""
        let id = platformFee?.currencyID ?? ""
        networkFeeValueLabel.text = AppConstant.isLanguageRightToLeft ? "\(id) \(amount)" : "\(amount) \(id)"
        networkFeeTypeLabel.text = id
        let available = presenter?.currency?.available ?? 0
        let currencyId = presenter?.currency?.id ?? ""
        let withdrawLimit = (presenter?.interactor?.withdrawalLimit?.available ?? "").toDouble()
        let fee = platformFee?.currencyID == presenter?.interactor?.currency?.id ? (platformFee?.amount ?? "").toDouble() : 0
        let currentValueString = amountString.replaceComaByDot()
        let currentValue = currentValueString.toDouble()
        let isAvailableAmount = available >= currentValue
        let fixRate = presenter?.currency?.fixedRate ?? 1
        let receivedValue = currentValue - fee
        let receivedUSDEStr = isLanguageRightToLeft ? "≈ USDT %@" : "≈ %@ USDT"
        let receivedUSD = (receivedValue * fixRate) > 0 ? String(format: receivedUSDEStr, String(format: "%.2f", (receivedValue * fixRate))) : "-"
        let decimaNumber = [(platformFee?.amount ?? "").getDecimalCount(), currentValueString.getDecimalCount()].max() ?? 0
        let receivedValueString = receivedValue > 0 ? String.init(format: "%0.\(decimaNumber)f", receivedValue) : "-"
        let minWithdraw = (presenter?.interactor?.platformSelected?.minWithdrawalAmount ?? "").toDouble()
        receivedAmountValueLabel.text = AppConstant.isLanguageRightToLeft ? "\(currencyId) \(receivedValueString)" : "\(receivedValueString) \(currencyId)"
        
        let minAmount = minWithdraw + fee
        self.setupCautions()
        usdValueLabel.text = receivedUSD
        usdValueLabel.isHidden = currencyId == "USDT"
        availableValueLabel.text = AppConstant.isLanguageRightToLeft ? "\(currencyId) \(available.fractionDigits(min: 0,max: 8, roundingMode: .ceiling))" : "\(available.fractionDigits(min: 0,max: 8, roundingMode: .ceiling)) \(currencyId)"
        
        var error = ""
        
        if !isAvailableAmount {
            error = "fragment_withdrawal_amount_withdrawalamount_notenoughbalance_hintlabel".Localizable()
        } else if (fee > currentValue) || (minAmount > currentValue) {
            error = "fragment_withdrawal_amount_withdrawalamount_minimumnotreached_hintlabel".Localizable()
        } else if receivedValue == 0 {
            error = String(format: "fragment_withdrawal_amount_withdrawalamount_receiveamountzero_hintlabel".Localizable(), currencyId)
        } else if (receivedValue * fixRate) > withdrawLimit {
            error = "fragment_withdrawalv2_withdrawalamount_exceed".Localizable()
        }
        
        let isError = (!error.isEmpty && !isEmptyValue)
        errorMessageLabel.isHidden = !isError
        errorMessageLabel.text = error
        nextButton.setEnable(isEnable: (!isEmptyValue && error.isEmpty))
        amountView.borderColor = isError ? UIColor.color_f25d4e : UIColor.color_e6e6e6_646464
        amountView2.backgroundColor = isError ? UIColor.color_f25d4e : UIColor.color_e6e6e6_646464
    }
    
    // MARK: - Setup Collection view
    func setupChainType() {
        // Setup UICollectionView
        collectionViewDelegate = BaseCollectionViewDataSource(hasPull: false,
                                                              hasLoadMore: false,
                                                              collectionView: chainTypeCollectionView)

        let layout = LeftAlignedFlowLayout()
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        chainTypeCollectionView.collectionViewLayout = layout
        collectionViewDelegate?.setupCell = setupCollectionCell(indexPath:dataItem:cell:)
        collectionViewDelegate?.didSelectItem = didSelectedCell(_:_:_:)
        collectionViewDelegate?.layoutSize = layoutSize(_:_:_:)
        collectionViewDelegate?.dataArray = []
    }
    
    private func setupCollectionCell(indexPath: IndexPath,
                                     dataItem: Any,
                                     cell: UICollectionViewCell) {
        let platfromSelected = presenter?.interactor?.platformSelected
        if let cell = cell as? DateTypeRateCollectionViewCell,
           let platForm = dataItem as? Platform {
            
            let title = platForm.displayName?.name?.localized ?? ""
            cell.billData(title: "\(title)",
                          isSelected: platfromSelected?.id == platForm.id,
                          textColor: UIColor.color_c8c8c8_7b7b7b,
                          borderColor: UIColor.color_c8c8c8_7b7b7b)
        }
    }
    
    private func didSelectedCell(_  indexPath: IndexPath,
                                 _ data: Any,
                                 _ cell: UICollectionViewCell) {
        guard let data = data as? Platform else { return }
        presenter?.interactor?.platformSelected = data
        presenter?.interactor?.networkFeeSelected = data.withdrawalFee?.first
        print("Min_withdraw", data.minWithdrawalAmount ?? "")
        chainTypeCollectionView.reloadData()
        presenter?.getConfiguration()
    }
    
    func layoutSize(_ collectionView: UICollectionView,
                    _ layout : UICollectionViewLayout,
                    _ indexPath: IndexPath) -> CGSize {
        let platform = presenter?.interactor?.currency?.currency?.platform?
            .filter({$0.withdrawalSuspended == false}) ?? []

        if  let title = platform.at(indexPath.item)?.displayName?.name?.localized {
            let widthSize = title.getSizeText(font: .font(style: .medium, size: 14)).width
            return CGSize(width: widthSize + 22.0,
                          height: itemSize.height)
        }
        return itemSize
    }
    
    func fullfillBalance() {
        let platformFee = presenter?.interactor?.networkFeeSelected
        let fee = platformFee?.currencyID == presenter?.interactor?.currency?.id ? (platformFee?.amount ?? "").toDouble() : 0
        let availableAmount = presenter?.currency?.available ?? 0
        let fullFill = (availableAmount - fee).forTrailingZero(min: 0,max: 8)
        withdrawAmountTextField.text = availableAmount == 0 ? "0" : "\(fullFill)"
        setupData(amountString: "\(availableAmount)")
    }
    
    // MARK: - Actions
    @IBAction func fullfillBalance(_ sender: UIButton) {
        percentButton.isSelected = true
        fullfillBalance()
    }
    
    @IBAction func goToInputAddress(_ sender: Any) {
        var withdrawRequest = WithdrawRequest()
        var amount = withdrawAmountTextField.text?.replaceComaByDot() ?? ""
        if amount.hasPrefix(".") {
            amount = "0" + amount
        }
        
        withdrawRequest.updateWithdrawModel(currency_id: presenter?.currency?.id,
                                            fee_currency_id: presenter?.currency?.platform.first?.withdrawalFee?.first?.currencyID,
                                            amount: amount,
                                            currency: presenter?.currency,
                                            selectedPlatform: presenter?.interactor?.platformSelected,
                                            networkFee: presenter?.interactor?.networkFeeSelected,
                                            config: cautionsView.withdrawConfig,
                                            dictionary: cautionsView.dictionary)
        presenter?.gotoAddressView(withdrawRequest: withdrawRequest)
    }
    
    @IBAction func changeNetworkFee(_ sender: UIButton) {
        guard let currentNetworkFee = presenter?.interactor?.networkFeeSelected,
              let networkFeeArray = presenter?.interactor?.platformSelected?.withdrawalFee else { return }
        sender.isSelected = !sender.isSelected
        updateNetworkFeeStatus()
        NetworkFeeView().detectNetworkFee(networkFeeList: networkFeeArray, currentNetworkFee: currentNetworkFee, isShow: sender.isSelected, dismiss: { [weak self] newNetworkFee in
            guard let `self` = self else { return }
            self.presenter?.interactor?.networkFeeSelected = newNetworkFee
            self.networkFeeButton.isSelected = false
            self.updateNetworkFeeStatus()
        })
    }
    
    @IBAction func editingChanged(_ sender: UITextField) {
    }
    
    func updateNetworkFeeStatus() {
        let arrowImageName = networkFeeButton.isSelected ? "ico_down" : "ico_up"
        feeArrowImageView.image = UIImage.init(named: arrowImageName)
        
        let amountString = withdrawAmountTextField.text ?? ""
        setupData(amountString: amountString)
    }
}

extension WithdrawAmountViewController: PresenterToViewWithdrawAmountProtocol {
    func showContract(withdrawConfig: ConfigWithdrawal?, dictionary: [String : String]?, platform: Platform?) {
        cautionsView.showContract(withdrawConfig: withdrawConfig, dictionary: dictionary)
        let platform = presenter?.interactor?.currency?.currency?.platform?.filter({$0.withdrawalSuspended == false}) ?? []
        collectionViewDelegate?.dataArray = platform
        
        var amountString = withdrawAmountTextField.text ?? ""
        if percentButton.isSelected {
            fullfillBalance()
            amountString = "\(presenter?.currency?.available ?? 0)"
        }
        setupData(amountString: amountString)
    }
    
    func addressInvalid() {
        
    }
}

extension WithdrawAmountViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        percentButton.isSelected = false
        let currentText = textField.text ?? ""
        let platformPrecision = presenter?.interactor?.platformSelected?.precision ?? 8
        guard let textRange = Range(range, in: currentText)else {
            return true
        }
        let decimalCount    = currentText.getDecimalCount()
        let newText = currentText.replacingCharacters(in: textRange, with: string).replaceComaByDot()
        if string.isEmpty {
            setupData(amountString: newText)
            return true
        }
        
        if (currentText.isEmpty && string == ",") || (currentText.contains(".") && string == ",") {
            return invalidInputValue()
        }
        
        if string == "," {
            withdrawAmountTextField.text = newText
            return invalidInputValue()
        }
        
        if Double(newText) == 0, string == "0", !newText.contains("."), !currentText.isEmpty {
            return invalidInputValue()
        }
        
        if let dotIndex = currentText.firstIndex(of: "."),
           (decimalCount >= min(8, platformPrecision)) && (range.location > currentText.distance(from: currentText.startIndex, to: dotIndex)) {
            
            return invalidInputValue()
        }
        setupData(amountString: newText)
        return true
    }
    
    
    func invalidInputValue() -> Bool {
        setupData(amountString: withdrawAmountTextField.text ?? "")
        return false
    }
}

extension WithdrawAmountViewController: StyleTextFieldProtocol {
    func focusTextField() {
        amountView.borderColor = withdrawAmountTextField.strokeFocusColor
        amountView2.backgroundColor = withdrawAmountTextField.strokeFocusColor
    }
    
    func unFocusTextField() {
        let isError = !errorMessageLabel.isHidden
        amountView.borderColor = isError ? UIColor.color_f25d4e : UIColor.color_e6e6e6_646464
        amountView2.backgroundColor = isError ? UIColor.color_f25d4e : UIColor.color_e6e6e6_646464
    }
}
 
