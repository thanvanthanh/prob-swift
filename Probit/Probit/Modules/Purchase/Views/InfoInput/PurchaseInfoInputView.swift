//
//  PurchaseInfoInputView.swift
//  Probit
//
//  Created by Bradley Hoang on 28/09/2022.
//

import UIKit

protocol PurchaseInfoInputViewDelegate: AnyObject {
    func validateSuccess(_ isSucces: Bool)
    func goToDeposit()
    var purchaseRequest: PurchaseRequest? { get set}
    
}

final class PurchaseInfoInputView: BaseView {
    
    struct Constants {
        static let amountTextFieldLeftPadding: CGFloat = 10
        static let amountTextFieldRightPadding: CGFloat = 57
        static let cellHeight: CGFloat = 32
    }
    
    // MARK: - IBOutlet
    @IBOutlet private weak var conversionRateLabel: UILabel!
    @IBOutlet weak var amountTextField: StyleTextField!
    @IBOutlet private weak var currencyUnitLabel: UILabel!
    @IBOutlet private weak var amountInputErrorLabel: UILabel!
    @IBOutlet private weak var withLabel: UILabel!
    @IBOutlet private weak var approximatelyUsdtLabel: UILabel!
    @IBOutlet private weak var balanceErrorLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var depositContainerView: UIStackView!
    @IBOutlet private weak var depositLabel: UILabel!
    @IBOutlet private weak var valueConversionLabel: UILabel!
    
    var validate: Bool = false
    
    var delegate: PurchaseInfoInputViewDelegate?
    var purchaseConversionRate: PurchaseConversionRate? {
        didSet {
            guard let probRate = self.purchaseConversionRate?.rate?.usdt?.prob,
                  let toCurrencyId = self.delegate?.purchaseRequest?.toCurrencyId,
                  let selectedCurrency = self.selectedCurrency else { return }
            let value = AppConstant.isLanguageRightToLeft ? "(\(selectedCurrency) \(probRate) ≈ \(toCurrencyId) 1)" : "(1 \(toCurrencyId) ≈ \(probRate) \(selectedCurrency))"
            valueConversionLabel.text = " \(value)"
            self.validateTotal()
        }
    }
    
    // MARK: - Private Variable
    private var collectionViewDelegate: BaseCollectionViewDataSource<PurchaseInfoInputCell>?
    private var selectedCurrency: String? {
        didSet {
            guard let selectedCurrency = self.selectedCurrency else { return }
            delegate?.purchaseRequest?.fromCurrencyId = selectedCurrency
        }
    }
    
    // MARK: - Public Variable
    var coinConversionConfig: CoinConversionConfigModel? {
        didSet {
            selectedCurrency = coinConversionConfig?.quote.first
            collectionViewDelegate?.dataArray = coinConversionConfig?.quote ?? []
        }
    }
    
    var nextLevelPoint: Double? {
        didSet {
            print("nextLevelPoint", nextLevelPoint ?? 0.0)
            amountTextField.text = "\(nextLevelPoint ?? 0)"
            validateTotal(with: nextLevelPoint)
            currencyUnitLabel.textColor = UIColor.color_282828_fafafa
            approximatelyUsdtLabel.textColor = UIColor.color_282828_fafafa
            showDepositContainerView(true)
        }
    }
    
    var userBalances: [UserBalance] = []
    
    // MARK: - Lifecycle
    override func setupUI() {
        setBackgroundColor(color: .clear)
        amountTextField.textColor = UIColor.color_282828_fafafa

        if AppConstant.isLanguageRightToLeft {
            amountTextField.textAlignment = .left
            amountTextField.setLeftPaddingPoints(Constants.amountTextFieldRightPadding)
            amountTextField.setRightPaddingPoints(Constants.amountTextFieldLeftPadding)
        } else {
            amountTextField.textAlignment = .right
            amountTextField.setLeftPaddingPoints(Constants.amountTextFieldLeftPadding)
            amountTextField.setRightPaddingPoints(Constants.amountTextFieldRightPadding)
        }
        
        amountTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        amountTextField.delegate = self
        setupCollectionView()
        depositLabel.addTapGesture { [weak self] in
            self?.delegate?.goToDeposit()
        }
    }
    
    func setupDarkMode() {
        amountTextField.borderColor = UIColor.color_e6e6e6_646464
    }
    
    override func localizedString() {
        currencyUnitLabel.text = "PROB"
        withLabel.text = "activity_buy_prob_with_title".Localizable()
        approximatelyUsdtLabel.text = ""
        approximatelyUsdtLabel.textColor = currencyUnitLabel.textColor
        conversionRateLabel.text = "activity_buy_prob_buy_title".Localizable()
        depositLabel.text = String(format: "activity_buy_prob_deposithint".Localizable(), selectedCurrency ?? "USDT")
    }
    
    func updateView() {
    }
    
    var toQuantity: String? {
        return amountTextField.text?.replaceComaByDot()
    }
    
    func resetView() {
        amountTextField.text = ""
        if let selectedCurrency = self.selectedCurrency {
            approximatelyUsdtLabel.text = AppConstant.isLanguageRightToLeft ? "≈ \(selectedCurrency) \(0.fractionDigits())" : "≈ \(0.fractionDigits()) \(selectedCurrency)"
        }
    }
    
    func validateTotal(with price: Double? = nil) {
        var priceValue = price
        if amountTextField.text != "" && price == nil {
            priceValue = amountTextField.text?.asDouble()
        }
        let validateBalance = self.validateBalance(with: priceValue)
        let validateTextField = self.validateTextField(with: priceValue)
        self.validate = validateBalance && validateTextField
        delegate?.validateSuccess(self.validate)
    }
}

// MARK: - Private
private extension PurchaseInfoInputView {
    func setupCollectionView() {
        collectionViewDelegate = BaseCollectionViewDataSource(hasPull: false,
                                                              hasLoadMore: false,
                                                              collectionView: collectionView)
        collectionViewDelegate?.setupCell = setupCell(indexPath:dataItem:cell:)
        collectionView.delegate = self
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        validateTotal(with: text.replaceComaByDot().asDouble())
        currencyUnitLabel.textColor = (text.isEmpty) ? UIColor.color_c8c8c8_646464 : UIColor.color_282828_fafafa
        approximatelyUsdtLabel.textColor = currencyUnitLabel.textColor
        showDepositContainerView(!text.isEmpty)
    }
    
    func showDepositContainerView(_ isShow: Bool) {
        depositContainerView.isHidden = !isShow
    }
    
    func validateTextField(with price: Double?) -> Bool {
        guard let config = coinConversionConfig,
              let price = price else {
            approximatelyUsdtLabel.text = ""
            approximatelyUsdtLabel.textColor = currencyUnitLabel.textColor
            return AppConstant.isLogin ? false : true
        }
        let isUnderMinPrice = price < config.minBaseAmount
        let isOverMaxPrice = price > config.maxBaseAmount
        let isValid = !isUnderMinPrice && !isOverMaxPrice
        
        amountTextField.borderColor = isValid ? UIColor.color_e6e6e6_646464 : UIColor(hexString: "F25D4E")
        if isUnderMinPrice {
            amountInputErrorLabel.text = String(format: "activity_buy_prob_minamounterror".Localizable(),
                                                config.minBaseAmount.fractionDigits(min: 0,max: 0,roundingMode: .down), "PROB")
        } else if isOverMaxPrice {
            amountInputErrorLabel.text = String(format: "activity_buy_prob_maxamounterror".Localizable(),
                                                config.maxBaseAmount.fractionDigits(min: 0,max: 0,roundingMode: .down), "PROB")
        }
        amountInputErrorLabel.isHidden = isValid
        return AppConstant.isLogin ? isValid : true
    }
    
    func validateBalance(with price: Double?) ->  Bool {
        guard let price = price,
              let selectedCurrency = selectedCurrency,
              let probRate = self.purchaseConversionRate?.rate?.usdt?.prob else {
            balanceErrorLabel.isHidden = true
            return AppConstant.isLogin ? false : true
        }
        let totalUsdt = (price * probRate.asDouble())
        let withValue = totalUsdt.roundToEightDecimal().fractionDigits()
        approximatelyUsdtLabel.text = AppConstant.isLanguageRightToLeft ? "≈ \(selectedCurrency) \(withValue)" : "≈ \(withValue) \(selectedCurrency)"
        approximatelyUsdtLabel.textColor = currencyUnitLabel.textColor

        let userBalance = userBalances.first(where: { $0.currencyID == selectedCurrency })
        let availableBalance = userBalance?.available.asDouble() ?? 0
        
        let isValidAvailable = totalUsdt <= availableBalance
        balanceErrorLabel.isHidden = isValidAvailable
        let insufficient = "fragment_withdrawal_amount_withdrawalamount_notenoughbalance_hintlabel".Localizable()
        let availableString = availableBalance == 0 ? "0" : "\(availableBalance.fractionDigits())"
        balanceErrorLabel.text = "\(insufficient) \(selectedCurrency): \(availableString)"
        return AppConstant.isLogin ? isValidAvailable : true

    }
}

extension PurchaseInfoInputView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string),
              let precision = coinConversionConfig?.precision  else {
            return true
        }
        if updatedString == "" {
            return true
        }
        
        let numberOfDecimalDigits: Int
        if string == "," {
            if updatedString.contains(find: ".") {
                return false
            }  else {
                textField.text = updatedString.replaceComaByDot()
                return false
            }
        }
        
        if let dotIndex = updatedString.firstIndex(of: ".") {
            numberOfDecimalDigits = updatedString.distance(from: dotIndex, to: updatedString.endIndex) - 1
        } else {
            numberOfDecimalDigits = 0
        }
        
        return updatedString.isNumber && numberOfDecimalDigits <= Int(precision)
        
    }
}

// MARK: - UICollectionViewDataSource
private extension PurchaseInfoInputView {
    func setupCell(indexPath: IndexPath,
                   dataItem: Any,
                   cell: UICollectionViewCell) {
        if let cell = cell as? PurchaseInfoInputCell,
           let currency = dataItem as? String {
            cell.setupCell(object: "\(dataItem)", isSelected: currency == selectedCurrency)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PurchaseInfoInputView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCurrency = coinConversionConfig?.quote[indexPath.item]
        depositLabel.text = String(format: "activity_buy_prob_deposithint".Localizable(), selectedCurrency ?? "USDT")
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "SFPro-Light", size: 14)!
        let currency = coinConversionConfig?.quote[indexPath.item] ?? ""
        label.text = "\(currency)"
        label.sizeToFit()
        let labelWidth = currency == selectedCurrency ? label.frame.width + PurchaseInfoInputCell.Configuration.totalOffset : label.frame.width + PurchaseInfoInputCell.Configuration.horizontalPadding * 2
        
        return CGSize(width: labelWidth,
                      height: Constants.cellHeight)
    }
}
