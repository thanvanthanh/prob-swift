
import Foundation

class TransactionHistoryInteractor: PresenterToInteractorTransactionHistoryProtocol {
    
    // MARK: Properties
    var presenter: InteractorToPresenterTransactionHistoryProtocol?
    var menus: [MenuBar] = []
    var currentPage: Int = 0
    var currency: WalletCurrency = WalletCurrency()
    
    init(currency: WalletCurrency) {
        self.currency = currency
        
        let all = TransactionListRouter().createModule(currency: currency, type: TransactionType.all)
        let deposit = TransactionListRouter().createModule(currency: currency, type: TransactionType.deposit)
        let withdraw = TransactionListRouter().createModule(currency: currency, type: TransactionType.withdrawal)

        menus = [
            MenuBar(name: "activity_currencystakehistory_tab_all".Localizable(),
                    icon: nil,
                    controller: all,
                    isSelected: true),
            MenuBar(name: "activity_walletdetails_deposit".Localizable(),
                    icon: nil,
                    controller: deposit),
            MenuBar(name: "activity_walletdetails_withdrawal".Localizable(),
                    icon: nil,
                    controller: withdraw)
        ]
    }
    
    func getData() {
    }
    
    func didSelectMenuItem(index: IndexPath) {
        menus.enumerated().forEach { (i, _) in
            menus[i].isSelected = false
        }
        menus[index.row].isSelected = true
        currentPage = index.row
        presenter?.changeStateMenuSuccess()
    }
}
