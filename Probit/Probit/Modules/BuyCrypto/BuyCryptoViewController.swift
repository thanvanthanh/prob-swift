//
//  BuyCryptoViewController.swift
//  Probit
//
//  Created by Thân Văn Thanh on 24/08/2022.
//  
//

import UIKit

protocol BuyCryptoDelegate: AnyObject {
    func getSpend(data: ListSupported, type: CryptoType)
}

class BuyCryptoViewController: BaseViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var warningLoadExchangeView: UIView!
    @IBOutlet weak var warningExchangeLabel: UILabel!
    
    @IBOutlet weak var spendView: BuyCryptoTextField!
    @IBOutlet weak var receiveView: BuyCryptoTextField!
    
    @IBOutlet weak var exChangeContainer: UIView!
    @IBOutlet weak var exChangeContentView: UIView!
    @IBOutlet weak var exchangeLabel: UILabel!
    @IBOutlet weak var exchangeButton: UIButton!
    @IBOutlet weak var spinerView: SpinnerView!
    @IBOutlet weak var buyButton: StyleButton!
    @IBOutlet weak var bottomConstraintBuyButton: NSLayoutConstraint!
    
    // MARK: - Properties
    var presenter: ViewToPresenterBuyCryptoProtocol?

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        spendView.name = "USD"
        receiveView.name = presenter?.defaultCrypto ?? "BTC"
        presenter?.changeConvertAction()
        [spendView,receiveView].forEach({
            $0?.inputTextField.delegate = self
            $0?.inputTextField.textColor = .color_424242_fafafa
        })
        scrollView.hideKeyboard()
        receiveView.inputTextField.maxLength = 22
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addObserverKeyBoard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.defaultFiat()
        presenter?.listCrypto()
        presenter?.receive = nil
        [receiveView, spendView].forEach { $0?.setInputText?.removeAll() }
        presenter?.cryptoPrice(fiat: spendView.getTextLabel(),
                               crypto: receiveView.getTextLabel())
        let buttonTitle = AppConstant.isLogin ? "common_buy".Localizable() : "common_login".Localizable()
        buyButton.setTitle(buttonTitle, for: .normal)
        buyButton.setEnable(isEnable: !AppConstant.isLogin)
        setImgageIcons()
    }
    
    override func setupUI() {
        super.setupUI()
        var leftTitle = "navigationbar_home".Localizable()
        let typeScreen = presenter?.screenType ?? .toHome
        switch typeScreen {
        case .toHome:
            leftTitle = "navigationbar_home".Localizable()
        case .toMore:
            leftTitle = "v2icon_home_more".Localizable()
        case .toWalet:
            leftTitle = presenter?.defaultCrypto ?? ""
        case .toStake:
            leftTitle = presenter?.defaultCrypto ?? ""
        }
        setupNavigationBar(title: "v2icon_home_buycrypto".Localizable(),
                           titleLeftItem: leftTitle)
        
        spendView.title = "buycrypto_spend".Localizable()
        spendView.textFieldType = .spend
        receiveView.title = "buycrypto_choosepurchaseamount_receivetextfield_title".Localizable()
        receiveView.textFieldType = .receive
        
        exChangeContainer.isHidden = false
        warningLoadExchangeView.isHidden = true
        exChangeContentView.backgroundColor = UIColor.color_e6e6e6_2a2a2a
        
        buyButton.setEnable(isEnable: !AppConstant.isLogin)
        setupAction()
    }
    
    override func setupRightToLeft(_ isRTL: Bool) {
        super.setupRightToLeft(isRTL)
        spendView.setupRightToLeft(isRTL)
        receiveView.setupRightToLeft(isRTL)
    }

    override func localizedString() {
        warningExchangeLabel.text = "buycrypto_choosepurchaseamount_warning_failtoload".Localizable()
    }
    
    override func setupDarkMode() {
        super.setupDarkMode()
        spendView.updateBorderStatus()
        receiveView.updateBorderStatus()
    }
    
    override func updateLayoutWhenKeyboardChanged(height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.bottomConstraintBuyButton.constant = height > 0 ? (height + 16) : 0
            self.view.layoutIfNeeded()
        }
    }
    
    private func setImgageIcons() {
        [spendView, receiveView].forEach { $0?.setImgageIcons()}
    }
    
    private func setupExchangeView(state: ExchangeLoadingState) {
        switch state {
        case .normal:
            exChangeContainer.isHidden = false
            warningLoadExchangeView.isHidden = true
            
            exchangeLabel.textColor = .color_282828_fafafa
            
            [spendView, receiveView].forEach {
                $0?.alpha = 1
                $0?.isUserInteractionEnabled = true
                $0?.inputTextField.isUserInteractionEnabled = true
                $0?.inputTextField.backgroundColor = .clear

            }
            spinerView.isHidden = true
            exchangeButton.isHidden = false
        case .faill:
            exChangeContainer.isHidden = true
            warningLoadExchangeView.isHidden = false
            
            exchangeLabel.textColor = .color_282828_fafafa
            [spendView, receiveView].forEach {
                $0?.alpha = 1
                $0?.inputTextField.alpha = 0.5
                $0?.isUserInteractionEnabled = true
                $0?.inputTextField.isUserInteractionEnabled = false
                $0?.inputTextField.backgroundColor = UIColor.color_ececec_2a2a2a
            }
            spinerView.isHidden = true
            exchangeButton.isHidden = false
        case .loading:
            exChangeContainer.isHidden = false
            warningLoadExchangeView.isHidden = true
            warningLoadExchangeView.cornerRadius = warningLoadExchangeView.frame.height / 2
            
            exchangeLabel.textColor = .init(hexString: "B6B6B6")
            [spendView, receiveView].forEach {
                $0?.alpha = 0.5
                $0?.isUserInteractionEnabled = false
                $0?.inputTextField.isUserInteractionEnabled = false
                $0?.inputTextField.backgroundColor = UIColor.color_ececec_2a2a2a
                $0?.updateLoadingBorderStatus()
            }
            spinerView.isHidden = false
            exchangeButton.isHidden = true
        }
    }
    
    func setupAction() {
        spendView.didAction { [self] in
            presenter?.navigateToListSupported(delegate: self,
                                               type: .fiat,
                                               isSelectType: spendView.getTextLabel())
        }
        
        receiveView.didAction { [self] in
            presenter?.navigateToListSupported(delegate: self,
                                               type: .crypto,
                                               isSelectType: receiveView.getTextLabel())
        }
    }
    
    @objc
    func loginComplete(notfication: NSNotification) {
        buyButton.setTitle("common_buy".Localizable(), for: .normal)
        buyButton.backgroundColor = UIColor.color_b6b6b6_424242
        buyButton.isUserInteractionEnabled = false
        [spendView, receiveView].forEach { $0?.inputTextField.text?.removeAll() }
    }
    
    @IBAction func changeConvertAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        presenter?.changeConvertAction()
    }
    
    @IBAction func buyAction(_ sender: Any) {
        AppConstant.isLogin ? presenter?.navigateToPaymentMethod() : presenter?.navigateToLogin()
    }
    
    // Convert Exchange Price
    private func convertExchangePrice( _ textField: UITextField, updatedString: String) {
        guard let cryptoPrice = presenter?.interactor?.cryptoPriceData else { return }
        let amount = cryptoPrice.data.fiatAmount
        if textField == spendView.inputTextField {
            let price = updatedString.multiplyPriceToCrypto(amount)
            presenter?.receive = price
            receiveView.setInputText = updatedString.isActuallyEmpty ? "" : price            
            presenter?.paymentParams = PamentChanelParameters(fiat: spendView.getTextLabel(),
                                                              fiatAmount: updatedString,
                                                              crypto: receiveView.getTextLabel(),
                                                              cryptoAmount: price,
                                                              isSpend: true)
        } else if textField == receiveView.inputTextField {
            let price = updatedString.multiplyCryptoToPrice(amount)
            presenter?.receive = price
            spendView.setInputText = updatedString.isActuallyEmpty ? "" : price
            spendView.validateInputText()
            setupBuyButton(isActive: !updatedString.isActuallyEmpty)
            presenter?.paymentParams = PamentChanelParameters(fiat: spendView.getTextLabel(),
                                                              fiatAmount: price,
                                                              crypto: receiveView.getTextLabel(),
                                                              cryptoAmount: updatedString,
                                                              isSpend: false)
        }
    }
    
}

extension BuyCryptoViewController: PresenterToViewBuyCryptoProtocol {
    // TODO: Implement View Output Methods
    func completeListPrice() {
        guard let price = presenter?.cryptoPriceData else { return }
        [spendView, receiveView].forEach { $0?.model = price}
        
        spendView.placeholder = presenter?.getPlaceholder
        exchangeLabel.text = exchangeButton.isSelected ? presenter?.currencyToCrypto : presenter?.cryptoToCurency
        
        setupExchangeView(state: .normal)
    }
    
    func reloadCurrencyData(data: ListSupported, type: CryptoType) {
        switch type {
        case .fiat:
            spendView.name = data.name
        case .crypto:
            receiveView.name = data.name
        }
        if AppConstant.isLogin {
            buyButton.setEnable(isEnable: !receiveView.getInputText().isActuallyEmpty)
        }
    }
    
    func handleShowLoading() {
        setupExchangeView(state: .loading)
        exchangeLabel.text = "common_loading".Localizable()
    }
    
    func loadApiError() {
        setupExchangeView(state: .faill)
    }
   
}

// MARK: - UITextFieldDelegate
extension BuyCryptoViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let oldText = textField.text,
              let r = Range(range, in: oldText),
              let min = presenter?.cryptoPriceData?.data.fiatMinAmount.asDouble(),
              let max = presenter?.cryptoPriceData?.data.fiatMaxAmount.asDouble(),
              let amount = presenter?.cryptoPriceData?.data.fiatAmount else { return true }
        var pass = true
        let newText = oldText.replacingCharacters(in: r, with: string)
        convertExchangePrice(textField, updatedString: newText)

        if textField == spendView.inputTextField {
            pass = !((newText.asDouble() < min) || (newText.asDouble() > max))
        } else if textField == receiveView.inputTextField {
            let price = newText.multiplyCryptoToPrice(amount)
            pass = !((price.asDouble() < min) || (price.asDouble() > max))
        }
        let isValidate = textField.validatePriceInput(string, newText, oldText)
        setupBuyButton(isActive: pass)
        return isValidate
    }
}

extension BuyCryptoViewController: BuyCryptoDelegate {
    func getSpend(data: ListSupported, type: CryptoType) {
        self.presenter?.updateData(data: data, type: type)
    }
}

// MARK: Validate Spend
extension BuyCryptoViewController {
    
    func setupBuyButton(isActive: Bool) {
        // check login
        guard AppConstant.isLogin else {
            buyButton.setEnable(isEnable: true)
            return
        }
        buyButton.isUserInteractionEnabled = isActive
        buyButton.setEnable(isEnable: isActive)
    }
}

enum ExchangeLoadingState {
    case normal
    case faill
    case loading
}
