
import Foundation

class CryptoTransfersInteractor: PresenterToInteractorCryptoTransfersProtocol {
    var currency: WalletCurrency?
    // MARK: Properties
    var presenter: InteractorToPresenterCryptoTransfersProtocol?
    var profileInfo: ProfileInfo?
    var currencies: [WalletCurrency]?
    var getCurrencyWithPlatform: GetCurrencyWithPlatformAction = GetCurrencyWithPlatformAction(dataSource: GatewayApiProductService())
    
    init(_ currency: WalletCurrency?) {
        self.currency = currency
    }

    func getCoinStatus() {
        let group = DispatchGroup()
        
        group.enter()
        BuyCryptoAPI.shared.listCrypto { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let data):
                self.presenter?.updateBuyCryptoModel(buyCryptoModel: data)
            case .failure:
                break
            }
            group.leave()
        }
        
        
        group.enter()
        HomeAPI.shared.getProfileInfo(completionHandler: { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let res):
                self.profileInfo = res
            case .failure(_):
                break
            }
            group.leave()
        })
        
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
                
            case .failure(_):
                break
            }
            group.leave()
        }
        group.enter()
        getBalance {
            group.leave()
        }
        group.notify(queue: .main) { [weak self] in
            guard let `self` = self else { return }
            self.presenter?.updateCoinStatus()
        }
    }
    
    func getBalance(completed: @escaping() -> Void) {
        StakeAPI.shared.getBalance{ [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let balancyData):
                balancyData.data.forEach { balance in
                    if balance.currencyID == self.currency?.id {
                        self.currency?.mapping(balance)
                    }
                }
            case .failure(_):
                break
            }
            completed()
        }
    }
}
