
import Foundation

class DepositInteractor: PresenterToInteractorDepositProtocol {    
    // MARK: Properties
    var presenter: InteractorToPresenterDepositProtocol?
    var walletCurrency: WalletCurrency
    var depositAddress: DepositAddress? {
        didSet {
            print("Address:", depositAddress?.address ?? "")
        }
    }
    var platformSelected: Platform?
    var idPlatformSelected: String?

    var configWdwarnModel :ConfigWdwarnModel?
    var configDeposit: ConfigDeposit?
    var dictionary: [String: String] = [:]
    var count: Int = 3
    
    init(walletCurrency: WalletCurrency) {
        print("Platform:", walletCurrency.platform.count)
        self.walletCurrency = walletCurrency
        self.platformSelected = walletCurrency.currency?.platform?.filter({$0.depositSuspended != true}).first
        self.idPlatformSelected = self.platformSelected?.id
    }
    
    func getData() {
        self.count = 3
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        getDataDepositAddress {
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        getConfig {
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main, execute: { [weak self] in
            guard let `self` = self else { return }
            self.configDeposit = self.configWdwarnModel?.deposit?
                .first(where: {($0.currencyID == self.platformSelected?.currencyID) && ($0.platformID == self.platformSelected?.id || $0.platformID == "*")})
            self.presenter?.getDataSuccess()
        })
    }
    
    
    
}

private extension DepositInteractor {
    func getDataDepositAddress(completed: @escaping() -> Void) {
        self.count -= 1
        StakeAPI.shared.getAddressDeposit(self.idPlatformSelected ?? "", false) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.depositAddress = response.data.first
                completed()
            case .failure(_):
                if self.count > 0 {
                    self.getDataDepositAddress(completed: completed)
                } else {
                    StakeAPI.shared.getAddressDeposit(self.idPlatformSelected ?? "", nil) { addressRes in
                        switch addressRes {
                        case .success(let data):
                            self.depositAddress = data.data.first
                        case .failure(let error):
                            self.presenter?.handerApiError(error: error)
                        }
                        completed()
                    }
                    
                }
            }
        }
    }
    
    func getConfig(completed: @escaping() -> Void) {
        HomeAPI.shared.getProfileInfo2() { [weak self] result in
           guard let `self` = self else { return }
           switch result {
           case .success(let res):
               self.configWdwarnModel = res
           case .failure(let error):
               self.presenter?.handerApiError(error: error)
           }
           completed()
       }
    }
}
