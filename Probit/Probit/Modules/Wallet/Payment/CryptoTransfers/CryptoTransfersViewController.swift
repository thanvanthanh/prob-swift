
import UIKit

class CryptoTransfersViewController: BaseViewController {
    
    // MARK: - Properties
    @IBOutlet private var exchangeCollectionView: UICollectionView!
    @IBOutlet private weak var goTradeContainerView: UIView!
    @IBOutlet weak var totalBalanceTitle: UILabel!
    @IBOutlet weak var totalBalance: UILabel!
    @IBOutlet weak var availableBalanceTitle: UILabel!
    @IBOutlet weak var availableBalance: UILabel!
    @IBOutlet weak var estimatedBalance: UILabel!
    @IBOutlet weak var transactionHistory: StyleButton!
    @IBOutlet weak var buyCrypto: StyleButton!
    @IBOutlet weak var depositButton: StyleButton!
    @IBOutlet weak var withdrawalButton: StyleButton!
    @IBOutlet weak var gotradeTitle: UILabel!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    @IBOutlet weak var collectionView_height: NSLayoutConstraint!
    var presenter: ViewToPresenterCryptoTransfersProtocol?
    var stakeDetailsInteractorDelegate: StakeDetailsInteractorProtocol?
    private var currency: WalletCurrency?
    var openAlone: Bool = false
    private var validMarkets = [Market]()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.fetchData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func setupUI() {
        super.setupUI()
        let nib = UINib(nibName: "ExchangeCell", bundle: .main)
        exchangeCollectionView.register(nib, forCellWithReuseIdentifier: "cell")
        exchangeCollectionView.dataSource = self
        exchangeCollectionView.delegate = self
        exchangeCollectionView.isScrollEnabled = false
        configLayout()
        withdrawalButton.addTarget(self, action: #selector(openWithDraw), for: .touchUpInside)
        transactionHistory.style = .style_2
        buyCrypto.style = .style_2
        withdrawalButton.style = .style_1
        depositButton.style = .style_1
        
        guard let currency = presenter?.interactor?.currency else { return }
        setupNavigationBar(title: currency.id ?? "",
                           subtitle: currency.displayName,
                           icon: String(format: CurrencyIconType.crypto.url,  currency.id ?? ""),
                           titleLeftItem: "navigationbar_wallet".Localizable())
    }
    
    override func setupRightToLeft(_ isRTL: Bool) {
        super.setupRightToLeft(isRTL)
        [totalBalanceTitle, availableBalanceTitle].forEach { $0?.textAlignment = isRTL ? .right : .left }
        [totalBalance, availableBalance, estimatedBalance].forEach { $0?.textAlignment = isRTL ? .left : .right }
    }
    
    override func localizedString() {
        super.localizedString()
        totalBalanceTitle.text = "viewholder_wallet_total_balance".Localizable()
        availableBalanceTitle.text = "activity_walletdetails_availablebalance".Localizable()
        transactionHistory.setTitle("fragment_walletdetailsv2_coin_transactionhistory".Localizable(), for: .normal)
        buyCrypto.setTitle("v2icon_home_buycrypto".Localizable(), for: .normal)
        depositButton.setTitle("activity_walletdetails_deposit".Localizable(), for: .normal)
        withdrawalButton.setTitle("activity_walletdetails_withdrawal".Localizable(), for: .normal)
        gotradeTitle.text = "fragment_walletdetailsv2_coin_gototrade_title".Localizable()
        lastUpdateLabel.text = String(format: "fragment_walletdetailsv2_coin_lastupdated".Localizable(), Date().stringFromDateWithSemantic())
    }
    
    private func configLayout() {
        let layout = LeftAlignedFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 14
        exchangeCollectionView.collectionViewLayout = layout
        exchangeCollectionView.semanticContentAttribute = AppConstant.isLanguageRightToLeft ? .forceRightToLeft : .forceLeftToRight
    }
    
    @IBAction func goToDeposit(_ sender: Any) {
        guard let walletCurrency = stakeDetailsInteractorDelegate?.walletCurrency ?? currency, let id = walletCurrency.id else {
            return
        }
        let isSuspended = walletCurrency.platform.first(where: {$0.depositSuspended == false}) == nil
        var suspendedType = walletCurrency.platform.first(where: {$0.depositSuspended == true})?.suspendedReason ?? .notSupported
        if !isSuspended {
            DepositRouter(walletCurrency: walletCurrency).showScreen()
            return
        }
        suspendedType = suspendedType == .empty ? SuspendedReason.notSupported : suspendedType

        let suspendedReason = "suspendedreason_\(suspendedType.rawValue)".Localizable()
        let reason = "\(walletCurrency.platform.first?.displayName?.name?.localized ?? ""): \(suspendedReason)"
        let message = String.init(format: "dialog_depositwithdrawal_blocked_by_api_content".Localizable(), id, "deposit_nocap".Localizable(), "")
        PopupHelper.shared.show(viewController: self,
                                title: "dialog_notice".Localizable(),
                                message: message,
                                warning: reason,
                                activeTitle: "common_confirm".Localizable(),
                                activeAction: nil,
                                cancelTitle: "dialog_cancel".Localizable(),
                                cancelAction: nil,
                                messageColor: UIColor.color_282828_fafafa,
                                warningColor: UIColor.color_7b7b7b_b6b6b6)
    }
    
    @IBAction func gotoTransactionHistory(_ sender: UIButton) {
        guard let currency = currency else { return }
        TransactionHistoryRouter().showScreen(currency: currency)
    }
    
    @IBAction func gotoBuyCrypto(_ sender: UIButton) {
        BuyCryptoRouter().showScreen(type: .toWalet, defaultCrypto: currency?.id ?? "BTC")
    }
    
    @objc func openWithDraw() {
        guard let walletCurrency = stakeDetailsInteractorDelegate?.walletCurrency ?? currency, let id = walletCurrency.id else {
            return
        }
        var message = String.init(format: "dialog_depositwithdrawal_blocked_by_api_content".Localizable(), id, "withdrawal_nocap".Localizable(), "")
        
        var isSuspended = walletCurrency.platform.first(where: {$0.withdrawalSuspended == false}) == nil
        var suspendedType = walletCurrency.platform.first(where: {$0.withdrawalSuspended == true})?.suspendedReason ?? .notSupported

        suspendedType = suspendedType == .empty ? SuspendedReason.notSupported : suspendedType

        let suspendedReason = "suspendedreason_\(suspendedType.rawValue)".Localizable()
        var reason = "\(walletCurrency.platform.first?.displayName?.name?.localized ?? ""): \(suspendedReason)"
        
        if let suspendWithdraw = presenter?.interactor?.profileInfo?.suspend?.withdrawal {
            isSuspended = true
            let updatedTime = suspendWithdraw.date?.stringFromDateWithSemantic() ?? ""
            let reEnableTime = suspendWithdraw.date?.nextDate(number: 3).stringFromDateWithSemantic() ?? ""
            var specialReason = "withdrawalsuspend_reason_password_reset".Localizable()
            switch suspendWithdraw.reason {
            case WithdrawSuspendReason.otp_disable.rawValue:
                specialReason = "withdrawalsuspend_reason_otp_disable".Localizable()
            case WithdrawSuspendReason.primaryphoneno_removechange.rawValue:
                specialReason = "withdrawalsuspend_reason_primaryphoneno_removechange".Localizable()
            default:
                break
            }
            message = String(format: "dialog_suspend_withdrawal_content".Localizable(),
                             updatedTime,
                             specialReason,
                             "3 days",
                             reEnableTime)
            reason = ""
        }
        
        if !isSuspended {
            WithdrawAmountRouter().showScreen(currency: walletCurrency)
            return
        }
        PopupHelper.shared.show(viewController: self,
                                title: "dialog_notice".Localizable(),
                                message: message,
                                warning: reason,
                                activeTitle: "common_confirm".Localizable(),
                                activeAction: nil,
                                cancelTitle: "dialog_cancel".Localizable(),
                                cancelAction: nil,
                                messageColor: UIColor.color_282828_fafafa,
                                warningColor: UIColor.color_7b7b7b_b6b6b6)
    }
}

extension CryptoTransfersViewController: PresenterToViewCryptoTransfersProtocol{
    func bindData(_ data: WalletCurrency) {
        self.currency = data
        validMarkets = currency?.markets.filter({ market in presenter?.interactor?.currencies?.contains(where: {$0.currency?.id == market.quoteCurrencyID}) ?? true }) ?? [Market]()

        lastUpdateLabel.text = String(format: "fragment_walletdetailsv2_coin_lastupdated".Localizable(), Date().stringFromDateWithSemantic())
        goTradeContainerView.isHidden = validMarkets.isEmpty
        totalBalance.text = currency?.total.fractionDigits()
        self.availableBalance.text = self.currency?.available.fractionDigits()
        
        let usdtRate: Double? = self.currency?.usdtRate
        if let usdtRate = usdtRate {
            let estimatedBalanceStr = isLanguageRightToLeft ? "≈ USDT %@" : "≈ %@ USDT"
            estimatedBalance.text = String(format: estimatedBalanceStr, (usdtRate * (self.currency?.total ?? 0)).fractionDigits(min: 2, max: 2))
        } else {
            estimatedBalance.text = "-"
        }
        if self.currency?.id == "USDT" {
            estimatedBalance.text = ""
        }
        
        let numberOfLine = generateNumberOfLine()
        let pading = numberOfLine > 1 ? numberOfLine * 8 : 0
        collectionView_height.constant = CGFloat(pading) + CGFloat(generateNumberOfLine()) * 32.0
        self.exchangeCollectionView.reloadData()
        let isShowBuyCryptoButton = presenter?.buyCryptoModel?.data?.crypto.first(where: {$0.currencyID == self.currency?.id}) == nil
        self.buyCrypto.isHidden = isShowBuyCryptoButton
        let inset: CGFloat = AppConstant.isLanguageRightToLeft ? -8.0 : 4.0
        self.buyCrypto.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: inset, bottom: 0, right: -inset)
    }
    
    func generateWidthItem(index: Int) -> CGFloat {
        let item = validMarkets[index]
        guard let baseCurrencyID = item.baseCurrencyID, let quoteCurrencyID = item.quoteCurrencyID else { return .zero }
        let text = baseCurrencyID + "/" + quoteCurrencyID
        let string = text.getSizeText(font: UIFont.font(style: .regular, size: 14))
        return string.width + 28
    }
    
    func generateNumberOfLine() -> Int {
        guard !validMarkets.isEmpty else { return 0 }
        var numberOfLine = 1
        var currentWidth = [CGFloat]()

        for index in 0..<validMarkets.count {
            currentWidth.append(generateWidthItem(index: index))
            if currentWidth.reduce(0, +) > (exchangeCollectionView.bounds.width - CGFloat(currentWidth.count - 1) * 28.0) {
                numberOfLine += 1
            }
            
        }
        return numberOfLine
    }
}

extension CryptoTransfersViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let marketCount = validMarkets.count
        return marketCount
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = validMarkets[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ExchangeCell
        cell.configureCell(item)
        cell.round()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.validMarkets[indexPath.row]
        let exchange = ExchangeTicker()
        exchange.mapping(withMarket: item)
        ExchangeDetailRouter().showScreen(exchangeId: item.id)
    }
}

extension CryptoTransfersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: generateWidthItem(index: indexPath.row),
                      height: 32.0)
       
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
