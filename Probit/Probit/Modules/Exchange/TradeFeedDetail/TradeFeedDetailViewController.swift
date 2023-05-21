//
//  TradeFeedDetailViewController.swift
//  Probit
//
//  Created by Nguyen Quang on 21/10/2022.
//  
//

import UIKit
import SnapKit

class TradeFeedDetailViewController: BaseViewController {
    @IBOutlet weak var infoView: ExchangeInfo!
    @IBOutlet weak var orderBookListView: OrderBookListView!
    
    @IBOutlet weak var buyTabView: UIButton!
    @IBOutlet weak var sellTabView: UIButton!
    @IBOutlet weak var selectedTabView: UIView!
    @IBOutlet weak var spacingBottom: NSLayoutConstraint!
    @IBOutlet weak var leftConstraintSelectedView: NSLayoutConstraint!
    
    @IBOutlet weak var heightOpenOrder: NSLayoutConstraint!
    @IBOutlet weak var limitButton: UIButton!
    @IBOutlet weak var marketButton: UIButton!
    
    @IBOutlet weak var priceContent: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceTextField: RTLTextField!
    @IBOutlet weak var downPriceButton: UIButton!
    @IBOutlet weak var upPriceButton: UIButton!
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountTextField: StyleTextField!
    
    @IBOutlet weak var amountStack: UIStackView!
    @IBOutlet weak var coverTotalStackView: UIView!
    @IBOutlet weak var totalStackView: UIStackView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalTextField: StyleTextField!
    @IBOutlet weak var amountStackView: UIStackView!
    
    @IBOutlet weak var mainTotalStackView: UIStackView!
    @IBOutlet weak var buyButton: HighlightButon!
    @IBOutlet weak var sellButton: HighlightButon!
    
    @IBOutlet weak var avaiableBalanceLabel: UILabel!
    @IBOutlet weak var avaiableBalanceValueLabel: UILabel!
    @IBOutlet weak var openOrdersLabel: UILabel!
    // MARK: - Properties
    var presenter: ViewToPresenterTradeFeedDetailProtocol?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        [priceTextField, amountTextField, totalTextField].forEach {
            $0?.delegate = self
            $0?.keyboardType = .decimalPad
        }
        priceTextField.delegateRTL = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateFavoriteImage()
        presenter?.viewDidLoad()
        addObserverKeyBoard()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        orderBookListView.screenParent = .detail
        orderBookListView.loadData(data: presenter?.orderBooks ?? [])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter?.disconnect()
    }
    
    override func setupUI() {
        super.setupUI()
        setupNavigation()
        buildAmountStackView()
        orderBookListView.delegate = self
        
        let tickerColor = AppConstant.tickerColor
        buyButton.textColor = .white
        buyButton.bgColor = tickerColor.buyColor
        buyButton.highlightType = .buy
        buyButton.titleLabel?.font = .font(style: .medium, size: 16)
        
        sellButton.textColor = .white
        sellButton.bgColor = tickerColor.sellColor
        sellButton.highlightType = .sell
        sellButton.titleLabel?.font = .font(style: .medium, size: 16)
        
        guard let ticker = presenter?.exchange,
              let id = ticker.id else { return }
        updateExchangeData(ticker: ticker)
        addFavoriteBarItem(currentCoinId: id, hiddenChart: false)
        
        presenter?.limitPrice = ticker.quoteRate
        priceTextField.text = presenter?.limitPrice?.replacingOccurrences(of: "-", with: "")
    }
    
    private func setupNavigation() {
        let id = presenter?.exchange?.baseCurrencyId ?? ""
        let subTitle = "\(id)/\(presenter?.exchange?.quoteCurrencyId ?? "")"
        setupNavigationBar(title: presenter?.exchange?.displayName ?? "",
                           subtitle: subTitle,
                           icon: CurrencyIconType.crypto.url.format(id),
                           titleLeftItem: "navigationbar_market".Localizable())
        buildTabOrderSide()
        buildReportTrade()
        presenter?.subTitle = subTitle
        
        styleTextField(textField: priceTextField, placeholder: "orderform_price".Localizable())
        totalTextField.setLeftPaddingPoints(16)
        styleTextField(textField: totalTextField, placeholder: "orderform_total".Localizable())
        amountTextField.setLeftPaddingPoints(16)
        styleTextField(textField: amountTextField, placeholder: "orderform_amount".Localizable())
    }
    
    // MARK: - ACTION
    @IBAction func selectedBuyTabAction(_ sender: Any) {
        presenter?.orderSide = .BUY
        presenter?.changeTabOrderSide()
        
        buildTabOrderSide()
        buildReportTrade()
        buildAmountStackView()
    }
    
    @IBAction func selectedSellTabAction(_ sender: Any) {
        presenter?.orderSide = .SELL
        presenter?.changeTabOrderSide()
        
        buildTabOrderSide()
        buildReportTrade()
        buildAmountStackView()
    }
    
    @IBAction func limitAction(_ sender: Any) {
        presenter?.reportTrade = .limit
        presenter?.changePriceValue(isEditing: false)
        buildAmountStackView()

        buildTabOrderSide()
        buildReportTrade()
    }
    
    @IBAction func marketAction(_ sender: Any) {
        presenter?.reportTrade = .market
        presenter?.changePriceValue(isEditing: false)
        buildAmountStackView()
        
        buildTabOrderSide()
        buildReportTrade()
    }
    
    @IBAction func downPriceAction(_ sender: Any) {
        guard let currentPrice = presenter?.limitPrice?.asDouble(),
              let priceIncrement = presenter?.exchange?.priceIncrement else { return }
        let decimal = Decimal(string: priceIncrement)?.significantFractionalDecimalDigits ?? 1
        if currentPrice > priceIncrement.asDouble() {
            presenter?.limitPrice = (currentPrice - priceIncrement.asDouble()).roundToDecimal(max: decimal)
        } else {
            presenter?.limitPrice = 0.roundToDecimal(max: decimal)
        }
        priceTextField.text = presenter?.limitPrice?.asDouble().roundToDecimal(max: decimal)
        presenter?.changePriceValue(isEditing: false)
    }
    
    @IBAction func upPriceAction(_ sender: Any) {
        guard let currentPrice = presenter?.limitPrice?.asDouble(),
              let priceIncrement = presenter?.exchange?.priceIncrement else { return }
        let decimal = Decimal(string: priceIncrement)?.significantFractionalDecimalDigits ?? 1
        presenter?.limitPrice = (currentPrice + priceIncrement.asDouble()).roundToDecimal(max: decimal)
        priceTextField.text = presenter?.limitPrice ?? ""
        presenter?.changePriceValue(isEditing: false)
    }
    
    @IBAction func buyAction(_ sender: Any) {
        let messError = getErrorValidateInput(orderSide: .BUY)
        guard messError == "" else {
            let message = "\("activity_order_invalidinput".Localizable())\n\(messError)"
            showFloatsMessage(title: nil, message: message, type: .error)
            return
        }

        showPopUpConfirm(orderSide: .BUY)
    }
    
    @IBAction func sellButton(_ sender: Any) {
        let messError = getErrorValidateInput(orderSide: .SELL)
        guard messError == "" else {
            let message = "\("activity_order_invalidinput".Localizable())\n\(messError)"
            showFloatsMessage(title: nil, message: message, type: .error)
            return
        }
        showPopUpConfirm(orderSide: .SELL)
    }
    
    @IBAction func openOrdersAction(_ sender: Any) {
        let id = presenter?.exchange?.baseCurrencyId ?? ""
        let pair = "\(id)-\(presenter?.exchange?.quoteCurrencyId ?? "")"
        presenter?.showOpenOrders(pair: pair)
    }
    
    func getPricePopup() -> String? {
        guard let reportTrade = presenter?.reportTrade, reportTrade == .limit else {
            return nil
        }
        return presenter?.limitPrice
    }
    
    @IBAction func editingPriceAction(_ sender: UITextField) {
        guard let reportTrade = presenter?.reportTrade, reportTrade == .limit else { return }
        presenter?.limitPrice = priceTextField.text
        presenter?.changePriceValue(isEditing: true)
    }
    
    @IBAction func editingAmountAction(_ sender: UITextField) {
        presenter?.currentAmount = amountTextField.text
        presenter?.changeAmountValue()
    }
    
    @IBAction func editingTotalAction(_ sender: UITextField) {
        presenter?.currentTotal = totalTextField.text
        presenter?.changeTotalValue()
    }
    
    // MARK: - Build UI
    private func setupTotalTitle() {
        let quoteCurrencyId = presenter?.exchange?.quoteCurrencyId
        let baseCurrencyId = presenter?.exchange?.baseCurrencyId
        let total =  "orderform_total".Localizable() + " (\(quoteCurrencyId.value))"
        let amount = "orderform_amount".Localizable() + " (\(baseCurrencyId.value))"
        let orderSide = presenter?.orderSide ?? .BUY
        
        guard let reportTrade = presenter?.reportTrade else { return }
        if reportTrade == .limit {
            amountLabel.text = amount
            amountTextField.placeholder = "orderform_amount".Localizable()
            totalLabel.text = total
            totalTextField.placeholder =  "orderform_total".Localizable()
        } else {
            totalLabel.text = orderSide == .BUY ? total : amount
            totalTextField.placeholder = orderSide == .BUY ? "orderform_total".Localizable() : "orderform_amount".Localizable()
        }
    }
    
    private func buildAmountStackView() {
        let orderSide = presenter?.orderSide ?? .BUY
        let reportTrade = presenter?.reportTrade ?? .limit
        
        if orderSide == .BUY {
            mainTotalStackView.isHidden = false
            coverTotalStackView.isHidden = reportTrade == .limit
            amountStack.isHidden = reportTrade != .limit
        } else {
            amountStack.isHidden = false
            mainTotalStackView.isHidden = reportTrade != .limit
            coverTotalStackView.isHidden = true
        }
        
        totalStackView.removeFullyAllArrangedSubviews()
        AmountTotal.allCases.forEach { element in
            let buttonItem = buildAmountStackItem(item: element)
            totalStackView.addArrangedSubview(buttonItem)
        }
        amountStackView.removeFullyAllArrangedSubviews()
        AmountTotal.allCases.forEach { element in
            let buttonItem = buildAmountStackItem(item: element)
            amountStackView.addArrangedSubview(buttonItem)
        }
    }
    
    private func buildAmountStackItem(item: AmountTotal) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        let buttonItem: HighlightButon = {
            let button = HighlightButon()
            button.applyBehaviorExchangeStyle()
            button.setTitle("\(item.rawValue)%", for: .normal)
            button.titleLabel?.font = .font(style: .medium, size: 10)
            return button
        }()
        let spacingView = UIView()
        view.addSubview(buttonItem)
        view.addSubview(spacingView)
        buttonItem.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        spacingView.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.top.bottom.right.equalToSuperview()
        }
        spacingView.backgroundColor = item != .percent100 ? UIColor.Basic.spacingBottom : .clear
        buttonItem.did(.touchUpInside) { [weak self] _, _ in
            guard let `self` = self else { return }
            self.presenter?.changePercentAmount(percent: item)
        }
        return view
    }
    
    private func buildTabOrderSide() {
        let tickerColor = AppConstant.tickerColor
        buyButton.backgroundColor = tickerColor.buyColor
        sellButton.backgroundColor = tickerColor.sellColor
        let orderSide = presenter?.orderSide ?? .BUY
        guard orderSide == .BUY else {
            sellTabView.setTitleColor(tickerColor.sellColor, for: .normal)
            buyTabView.setTitleColor(UIColor.init(hexString: "#B6B6B6"), for: .normal)
            selectedTabView.backgroundColor = tickerColor.sellColor
            let mainWidth = UIScreen.main.bounds.width / 2 - 32
            leftConstraintSelectedView.constant = mainWidth / 2
            buyButton.isHidden = true
            sellButton.isHidden = false
            return
        }
        buyTabView.setTitleColor(tickerColor.buyColor, for: .normal)
        sellTabView.setTitleColor(UIColor.init(hexString: "#B6B6B6"), for: .normal)
        selectedTabView.backgroundColor = tickerColor.buyColor
        leftConstraintSelectedView.constant = 0
        buyButton.isHidden = false
        sellButton.isHidden = true
    }
    
    private func buildReportTrade(type: TradeFeedChange? = nil) {
        let orderSide = presenter?.orderSide ?? .BUY
        let reportTrade = presenter?.reportTrade ?? .limit
        if orderSide == .BUY {
            upPriceButton.isHidden = reportTrade != .limit
            downPriceButton.isHidden = reportTrade != .limit
            priceTextField.isEnabled = reportTrade == .limit
            
            priceContent.backgroundColor = reportTrade == .limit ? .clear : .color_f5f5f5_2a2a2a

            let nameImageLimit = reportTrade == .limit ? "ico_radio_check" : "ico_radio_uncheck"
            let nameImageMarket = reportTrade == .market ? "ico_radio_check" : "ico_radio_uncheck"
            limitButton.setImage(UIImage(named: nameImageLimit), for: .normal)
            marketButton.setImage(UIImage(named: nameImageMarket), for: .normal)
        } else {
            upPriceButton.isHidden = reportTrade != .limit
            downPriceButton.isHidden = reportTrade != .limit
            
            priceTextField.isEnabled = reportTrade == .limit
            
            priceContent.backgroundColor = reportTrade == .limit ? .clear : .color_f5f5f5_2a2a2a
            let nameImageLimit = reportTrade == .limit ? "ico_radio_check" : "ico_radio_uncheck"
            let nameImageMarket = reportTrade == .market ? "ico_radio_check" : "ico_radio_uncheck"
            limitButton.setImage(UIImage(named: nameImageLimit), for: .normal)
            marketButton.setImage(UIImage(named: nameImageMarket), for: .normal)
        }
        switch type {
        case .price:
            updateTotalInput()
            updateAmountInput()
        case .amount:
            updatePriceInput()
            updateTotalInput()
        case .total:
            updatePriceInput()
            updateAmountInput()
        default:
            updatePriceInput()
            updateTotalInput()
            updateAmountInput()
        }
    }
    
    private func updatePriceInput() {
        let reportTrade = presenter?.reportTrade ?? .limit
        priceTextField.text = reportTrade == .limit ? presenter?.limitPrice : "orderform_market".Localizable()
    }
    
    private func updateAmountInput() {
        amountTextField.text = presenter?.currentAmount
    }
    
    private func updateTotalInput() {
        totalTextField.text = presenter?.currentTotal
    }
    
    public func getAmount() -> String {
        amountTextField.text ?? ""
    }
    
    public func getPrice() -> String {
        guard let reportTrade = presenter?.reportTrade, reportTrade == .limit else {
            return presenter?.marketPrice ?? ""
        }
        return priceTextField.text ?? ""
    }
    
    public func getTotal() -> String {
        totalTextField.text ?? ""
    }
    
    private func styleTextField(textField: UITextField, placeholder: String) {
        textField.placeholder = placeholder
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 4
    }
    
    // MARK: - Override
    override func updateLayoutWhenKeyboardChanged(height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.spacingBottom.constant = height
            self.heightOpenOrder.constant = height > 0 ? 0 : 55.0
            self.view.layoutIfNeeded()
        }
    }
    
    override func tappedChartBarButton(sender: UIButton) {
        guard let exchange = presenter?.exchange else { return }
        TradingZoomViewRouter(exchange: exchange).showScreen()
    }
    
    override func setupRightToLeft(_ isRTL: Bool) {
        super.setupRightToLeft(isRTL)
        [limitButton, marketButton].forEach { $0?.contentHorizontalAlignment = isRTL ? .right : .left }
    }
    
    override func localizedString() {
        super.localizedString()
        buyTabView.setTitle("common_buy".Localizable(), for: .normal)
        sellTabView.setTitle("sell_noformat".Localizable(), for: .normal)
        limitButton.setTitle("  \("orderform_limit".Localizable())", for: .normal)
        marketButton.setTitle("  \("orderform_market".Localizable())", for: .normal)
        avaiableBalanceLabel.text = "activity_walletdetails_availablebalance".Localizable()
        if let quoteCurrencyId = presenter?.exchange?.quoteCurrencyId {
            priceLabel.text = "orderform_price".Localizable() + " (\(quoteCurrencyId))"
            totalLabel.text =  "orderform_total".Localizable() + " (\(quoteCurrencyId))"
        }
        if let baseCurrencyId = presenter?.exchange?.baseCurrencyId {
            amountLabel.text = "orderform_amount".Localizable() + " (\(baseCurrencyId))"
            buyButton.setTitle("orderform_BUY".Localizable().format(baseCurrencyId), for: .normal)
            sellButton.setTitle("orderform_SELL".Localizable().format(baseCurrencyId), for: .normal)
        }
        openOrdersLabel.text = "report_openorders".Localizable()
    }
}

extension TradeFeedDetailViewController: PresenterToViewTradeFeedDetailProtocol{
    func updateUsdtRate(usdtRate: String) {
        infoView.updateUsdtRate(rate: usdtRate)
        orderBookListView.updateUsdtRate(usdtRate: usdtRate)
    }
    
    func hideMarket(isHidden: Bool) {
        marketButton.isHidden = isHidden
    }
    
    func newOfferComplete() {
        amountTextField.text = ""
        totalTextField.text = ""
        presenter?.currentAmount = getAmount()
        presenter?.changePriceValue(isEditing: false)
    }
    
    func buySellAction() {
        print("buy sell sucsess")
    }
    
    // TODO: Implement View Output Methods
    func updateOrderBookData(data: MarketData) {
        orderBookListView.handleOnListenerMarket(data)
    }
    
    func updateCurrentPrice(model: RecentTrade?) {
        orderBookListView.updateCurrentPrice(model: model)
    }
    
    func updateExchangeData(ticker: ExchangeTicker) {
        guard ticker.id == presenter?.exchange?.id else { return }
        infoView.updateExchangeData(ticker: ticker)
    }
    
    func updateAvailablebalance(total: String) {
        avaiableBalanceValueLabel.text = total
    }
    
    func bindingBalanceData(type: TradeFeedChange?) {
        buildReportTrade(type: type)
    }
}

extension TradeFeedDetailViewController: OrderBookListViewProtocol {
    func didSelectRowAt(price: String, orderBook: OrderBook?) {
        presenter?.limitPrice = price
        presenter?.marketPrice = price

        let reportTrade = presenter?.reportTrade ?? .limit
        guard reportTrade == .limit else {
            let totalMarket = orderBook?.totalMarket?.asDouble().forTrailingZero()
            presenter?.currentTotal = totalMarket
            presenter?.changeTotalValue()
            updateTotalInput()
            return
        }
        let curentAmount = orderBook?.total?.asDouble().forTrailingZero()
        presenter?.currentAmount = curentAmount
        presenter?.changePriceValue(isEditing: false)
    }
}

extension TradeFeedDetailViewController: RTLTextFieldDelegate {
    func didChangeIsSecureTextEntry(isSecureTextEntry: Bool) { }
    
    func focusTextField() {
        let reportTrade = presenter?.reportTrade ?? .limit
        guard reportTrade == .limit else { return }
        priceContent.layer.borderColor = UIColor.color_4231c8_6f6ff7.cgColor
    }
    
    func unFocusTextField() {
        let reportTrade = presenter?.reportTrade ?? .limit
        guard reportTrade == .limit else { return }
        priceContent.layer.borderColor = UIColor.color_e6e6e6_646464.cgColor
    }
}
