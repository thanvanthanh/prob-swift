
import Foundation

struct WithdrawRequest {
    var currency_id: String = ""
    var fee_currency_id: String = ""
    var address: String = ""
    var destination_tag: String = ""
    var amount: String = ""
    var currency: WalletCurrency?
    var selectedPlatform: Platform?
    var tfa_session_id: String = ""
    var networkFee: WithdrawalFee?
    var withdrawalConfig: ConfigWithdrawal?
    var dictionary: [String: String]?
    
    mutating func updateWithdrawModel(currency_id: String? = nil,
                                      fee_currency_id: String? = nil,
                                      address: String? = nil,
                                      destination_tag: String? = nil,
                                      amount: String? = nil,
                                      currency: WalletCurrency? = nil,
                                      selectedPlatform: Platform? = nil,
                                      networkFee: WithdrawalFee? = nil,
                                      config: ConfigWithdrawal? = nil,
                                      dictionary: [String: String]? = nil) {
        if let currencyId = currency_id {
            self.currency_id = currencyId
        }
        if let feeCurrencyId = fee_currency_id {
            self.fee_currency_id = feeCurrencyId
        }
        if let destinationAddress = address {
            self.address = destinationAddress
        }
        if let destinationTag = destination_tag {
            self.destination_tag = destinationTag
        }
        if let withdrawAmount = amount {
            self.amount = withdrawAmount
        }
        if let withdrawCurrency = currency {
            self.currency = withdrawCurrency
        }
        if let withdrawSelectedPlatform = selectedPlatform {
            self.selectedPlatform = withdrawSelectedPlatform
        }
        if let withdrawFee = networkFee {
            self.networkFee = withdrawFee
        }
        if let withdrawConfig = config {
            self.withdrawalConfig = withdrawConfig
        }
        if let dic = dictionary {
            self.dictionary = dic
        }
    }
}
