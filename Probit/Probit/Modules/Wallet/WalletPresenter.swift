
import Foundation

class WalletPresenter: ViewToPresenterWalletProtocol {
    
    // MARK: Properties
    var view: PresenterToViewWalletProtocol?
    var interactor: PresenterToInteractorWalletProtocol?
    var router: PresenterToRouterWalletProtocol?
    var socketService: SocketService?
    let group = DispatchGroup()
    var balances: [UserBalance] = []
    var markets: [Market] = []
    var stakeCurrencies: [StakeCurrency] = []
    var stakeEvents: [StakeEventModel] = []
    var fixedRate: [String: String] = [:]
    var getUserBalance: GetUserBalanceAction!
    var getCurrencyWithPlatform: GetCurrencyWithPlatformAction!
    var getMarket: GetMarketAction!
    var getStakeEvent: GetStakeEventAction!
    var getFixedRate: GetFixedRateAction!
    var getWithdrawLimit: GetWithdrawLimitAction!
    var productService = GatewayApiProductService()
    
    var currencies: [WalletCurrency] = [] {
        didSet {
            if let _rate = rate {
                self.currencies.forEach { $0.mapping(_rate) }
            }
            DispatchQueue.main.async {
                guard let isAttached = self.view?.isAttached, isAttached else { return }
                self.view?.bindData(self.currencies)
            }
        }
    }
    
    var rate: ExchangeRate? {
        didSet {
            guard let _rate = rate else { return }
            self.currencies.forEach{ $0.mapping(_rate) }
            DispatchQueue.main.async {
                guard let isAttached = self.view?.isAttached, isAttached else { return }
                self.view?.bindData(self.currencies)
            }
        }
    }
    
    var timer: Timer?
    
    public init() {
        self.getUserBalance = GetUserBalanceAction()
        self.getCurrencyWithPlatform = GetCurrencyWithPlatformAction(dataSource: productService )
        self.getMarket = GetMarketAction(serviceType: "", dataSource: productService)
        self.getStakeEvent = GetStakeEventAction(dataSource: productService)
        self.getFixedRate = GetFixedRateAction(quote: "USDT", dataSource: productService)
    }
    
    func viewDidLoad() {
        socketService = SocketService()
        socketService?.set(delegate: self)
    }
    
    func viewWillAppear() {
        socketService?.connect()
        self.startTimer()
    }
    
    func viewWillDisappear() {
        self.disconnect()
        self.destroyTimer()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(excuteTimer) , userInfo: nil, repeats: true)
    }
    
    private func destroyTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @objc private func excuteTimer() {
        self.getBalance()
    }
    
    func getBalance() {
        getUserBalance.apiCall { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                if response.data.isEmpty {
                    self.currencies.first?.total = self.currencies.first?.total ?? 0 + 100
                    self.currencies.first?.available = self.currencies.first?.total ?? 0 + 100
                }
                
                for item in response.data {
                    if let index = self.currencies.compactMap({ $0.id }).firstIndex(of: item.currencyID) {
                        self.currencies[index].total = item.totalValue
                        self.currencies[index].available = item.availableValue
                    }
                }
            default: break
            }
        }
    }
    
    func fetchData() {
        group.enter()
        getCurrencyWithPlatform.apiCall { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let res):
                var currencies: [WalletCurrency] = []
                res.data.forEach {
                    let currency = WalletCurrency()
                    currency.mapping($0)
                    currencies.append(currency)
                }
                self.currencies = currencies
                
            case .failure(let error):
                self.handerApiError(error: error)
            }
            self.group.leave()
        }
        
        group.enter()
        getUserBalance.apiCall { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let res):
                self.balances = res.data
            case .failure(let error):
                self.handerApiError(error: error)
            }
            self.group.leave()
        }
        
        group.enter()
        getMarket.apiCall { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let res):
                let markets = res.data
                self.markets = markets
            case .failure(let error):
                self.handerApiError(error: error)
            }
            self.group.leave()
        }
        
        group.enter()
        getStakeEvent.apiCall { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let res):
                self.stakeEvents = res.data.map({ entry in
                    return StakeEventModel(entity: entry)
                })
            case .failure(let error):
                self.handerApiError(error: error)
            }
            self.group.leave()
        }
        
        group.enter()
        StakeAPI.shared.getStakeCurrency() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let currencyData):
                self.stakeCurrencies = currencyData.data
            case let .failure(error):
                self.handerApiError(error: error)
            }
            self.group.leave()
        }
        
        group.enter()
        getFixedRate.apiCall { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let fixedRate):
                self.fixedRate = fixedRate.data ?? [:]
            case let .failure(error):
                self.handerApiError(error: error)
            }
            self.group.leave()
        }
        
        group.notify(queue: DispatchQueue.global()) { [weak self] in
            guard let self = self else { return }
            self.mapingCurrencies()
        }
    }
    
    private func mapingCurrencies() {
        self.currencies.forEach { currency in
            guard let id = currency.id else { return }
            
            for balance in self.balances where balance.currencyID == currency.id{
                currency.mapping(balance)
            }
            
            currency.markets = self.markets.filter({
                $0.baseCurrencyID == id
            })
            currency.stakeEvent = self.stakeEvents.first(where: { $0.currencyId == id })
            
            if self.fixedRate.count > 0 {
                currency.fixedRate = self.fixedRate[currency.id ?? ""]?.doubleValue()
            }
        }
        
        self.currencies = self.currencies.sorted(by: { $0.total > $1.total })
    }
    
    func subcribeSocket() {
        socketService?.subcribe(channel: .exchangeRate, filter: ["USDT"])
    }
    
    func filterEmptyBalance(isHide: Bool) {
        view?.bindData(currencies)
    }
    
    func openSearchCurrencyScreen() {
        CryptoInquiryRouter().showScreen(data: currencies)
    }
    
    func disconnect() {
        socketService?.unsubscribe(channel: .exchangeRate)
        socketService?.closeConnection()
    }
    
    func handerApiError(error: ServiceError) {
        view?.showError(error: error)
    }
    
    func reConnect() {
        fetchData()
    }
    
    func clearWaletData() {
        currencies = []
    }
}

extension WalletPresenter: SocketServiceDelegate {
    func onSocketConnected() {
        print("WALLET_CONNECTED")
        self.subcribeSocket()
    }
    
    func onSocketDisconnected(_ reason: String, code: UInt16) {
        print("WALLET_DISCONNECTED")
    }
        
    func onSocketReciever(text: String) {
        guard let data = text.data(using: .utf8, allowLossyConversion: false) else { return }
        
        if let exchangeRate = try? JSONDecoder().decode(ExchangeRate.self, from: data) {
            self.rate = exchangeRate
        }
    }
    
    func viabilityChanged(_ viability: Bool) {
        if viability {
            self.subcribeSocket()
        }
    }
}

extension WalletPresenter: InteractorToPresenterWalletProtocol {
    
}

struct AuthorizationResponse: Codable {
    var type: String
    var result : String
}
