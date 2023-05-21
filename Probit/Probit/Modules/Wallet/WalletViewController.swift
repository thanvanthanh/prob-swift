
import UIKit

final class WalletViewController: BaseViewController {
    
    struct Constant {
        static let estimatedValueHiddenText = "***"
    }
    
    // MARK: - IBOutlet
    @IBOutlet private weak var balanceView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var switchView: SwitchView!
    @IBOutlet private weak var balanceSwitch: SwitchView!
    @IBOutlet private weak var estimateValue: CustomSecureTextField!
    @IBOutlet private weak var estimateValueText: UILabel!
    @IBOutlet private weak var estimateValueUsingText: UILabel!
    
    // MARK: - Properties
    var presenter: ViewToPresenterWalletProtocol!
    private var items: [WalletCurrency] = []
    private var hideEmptyBalances = true {
        didSet {
            presenter.filterEmptyBalance(isHide: hideEmptyBalances)
        }
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.fetchData()
        if AppConstant.isClearWaletData {
            tableView.isHidden = true
            estimateValue.text = "--"
            AppConstant.isClearWaletData = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.viewWillDisappear()
    }
    
    override func connectionReconnected() {
        presenter?.reConnect()
    }
    
    override func setupRightToLeft(_ isRTL: Bool) {
        super.setupRightToLeft(isRTL)
        [estimateValueText, estimateValueUsingText].forEach {
            $0?.textAlignment = isRTL ? .right : .left
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter.disconnect()
    }
    
    internal override func setupUI() {
        super.setupUI()
        switchView.setIsOn(UserDefaults.standard.bool(forKey: "is_show_balance"))
        switchView.type = .eye
        switchView.delegate = self
        switchView.imageWidth = 35
        switchView.imageMode = .center
        balanceSwitch.type = .check
        balanceSwitch.delegate = self
        balanceSwitch.setIsOn(true)
        
        estimateValue.secureText = Constant.estimatedValueHiddenText
        estimateValue.isUserInteractionEnabled = false
        estimateValue.isSecure = !switchView.isOn
        
        addRightBarItem(imageName: "ico_search", imageTouch: "", title: "")
        setupTableView()
    }
    
    override func setupDarkMode() {
        super.setupDarkMode()
        if !self.items.isEmpty {
            self.tableView.reloadData()
        }
    }
    
    deinit {
        presenter.disconnect()
    }
    
    override func localizedString() {
        setupNavigationBar(title: "navigationbar_wallet".Localizable(),
                           titleLeftItem: nil)
        balanceSwitch.setTitle("fragment_wallet_zerofilter".Localizable())
        estimateValueText.text = String.init(format: "fragment_wallet_totalamount_title".Localizable(), "USDT")
        estimateValueUsingText.text = String.init(format: "fragment_wallet_totalamount_hint".Localizable(), "Tether", "USDT")
    }
    
    override func tappedRightBarButton(sender: UIButton) {
        presenter.openSearchCurrencyScreen()
    }
    
    private func setupTableView() {
        tableView.register(cellType: WalletCurrencyPlatformCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    func sortCryptoInWallet() {
        let max = items.count
        if max < 2 {
            return
        }
        for item in items {
            if item.id == "USDT" {
                item.usdtValue = item.total
            } else if let usdtRate = item.usdtRate {
                item.usdtValue = usdtRate * item.total
            } else {
                item.usdtValue = -1
            }
        }
        let itemSorted = items.sorted(by: {$0.usdtValue > $1.usdtValue})
        items = itemSorted
        sortDataForAlphabetically()
    }

    func sortDataForAlphabetically() {
        let max = items.count
        for i in 0..<(max - 1) {
            for j in i..<(max - 1) {
                if items[i].usdtValue == items[j].usdtValue {
                    if items[i].id?.lowercased() ?? "" > items[j].id?.lowercased() ?? "" {
                        let temp = items[i]
                        items[i] = items[j]
                        items[j] = temp
                    }
                }
            }
        }
        for index in 0..<max where items[index].id == "PROB" {
            let itemProb = items[index]
            items.remove(at: index)
            items.insert(itemProb, at: 0)
        }
    }
    
    func removeCryptoTotalValueSmall() {
        var newItems = [WalletCurrency]()
        for i in 0..<items.count {
            let item = items[i]
            if item.id == "BTC" || item.id == "PROB" || item.id == "ETH" || item.id == "USDT" {
                newItems.append(item)
            } else if item.total > 0.00000001 {
                newItems.append(item)
            }
        }
        items = newItems
    }
    
}

// MARK: - PresenterToView
extension WalletViewController: PresenterToViewWalletProtocol {
    
    var isAttached: Bool {
        return self.isViewLoaded && self.view.window != nil
    }
    
    func bindData(_ items: [WalletCurrency]) {
        tableView.isHidden = false
        for item in items {
            if item.id == "PROB" && item.usdtRate == nil {
                print("failed to load price of PROB")
                return
            }
        }
        if hideEmptyBalances {
            let result = items.filter { $0.total != 0 || baseCurrency.contains($0.id?.uppercased() ?? "")}
            removeCryptoTotalValueSmall()
            self.items = result
        } else {
            self.items = items
        }
        var estimatedValue: Double = 0
        items.forEach { item in
            guard let id = item.id else { return }
            estimatedValue += (id.lowercased().elementsEqual(esimatedValueRefer.lowercased()) ?  item.total : (item.usdtRate ?? 0) * item.total)
        }
        estimateValue.setText(estimatedValue.fractionDigits(min: 2, max: 2))
        sortCryptoInWallet()
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension WalletViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(withType: WalletCurrencyPlatformCell.self,
                                               for: indexPath) as? WalletCurrencyPlatformCell else {
            return UITableViewCell()
        }
        cell.setupCell(object: items[indexPath.row], hideBalances: !switchView.isOn)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currency = items[indexPath.row]
        if let stakeEvent = currency.stakeEvent {
            let stakeCurrency = self.presenter?.stakeCurrencies.first { data in
                currency.id == data.currencyId
            }
            StakeDetailsRouter(parentTypeVC: .WALLET).showScreen(stakeEvent: stakeEvent,
                                                                 stakeCurrency: stakeCurrency,
                                                                 walletCurrency: currency)
        } else {
            CryptoTransfersRouter().showScreen(openAlone: true, data: currency)
        }
    }
}

// MARK: - SwichViewDelegate
extension WalletViewController: SwitchViewDelegate {
    func onStateChanged(sender: SwitchView) {
        if sender == switchView {
            estimateValue.isSecure = !sender.isOn
            tableView.reloadData()
        } else if sender == balanceSwitch {
            hideEmptyBalances = sender.isOn
        }
    }
}
