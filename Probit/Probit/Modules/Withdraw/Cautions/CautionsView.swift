//
//  CautionsView.swift
//  Probit
//
//  Created by Dang Nguyen on 02/11/2022.
//

import UIKit

class CautionsView: BaseView {
    @IBOutlet weak var correctDestinationLabel: UILabel!
    @IBOutlet weak var correctDestinationView: UIView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var FAQView: UIView!
    @IBOutlet weak var FAQLabel: UILabel!
    @IBOutlet weak var showContractView: UIView!
    @IBOutlet weak var showContractLabel: UILabel!
    var platform: Platform?
    var withdrawConfig: ConfigWithdrawal?
    var dictionary: [String : String]?
    
    func setupCautionsView(currencyId: String, platform: Platform?, feeWithdraw: String?) {
        self.platform = platform
        let destination = String.init(format: "activity_deposit_multiplatformnotice".Localizable(), currencyId)
        let protect = "fragment_withdrawal_amount_notice_72hrsuspend_password_reset" .Localizable()
        if let fee = platform?.withdrawalFee?.first(where: {$0.currencyID == currencyId}),
           let amount = fee.amount {
        
            let minimum = amount.asDouble() + (feeWithdraw?.asDouble() ?? 0.0)
            
            FAQLabel.text = String(format: "fragment_withdrawal_amount_notice_minimumamount".Localizable(), minimum.asString(), currencyId)
            FAQView.isHidden = false
        } else {
            FAQView.isHidden = true
        }
        correctDestinationLabel.text = destination
        addressLabel.text = protect
    }
    
    func showContract(withdrawConfig: ConfigWithdrawal?, dictionary: [String : String]?) {
        var isLocalizable = true
        var contract = ""
        self.withdrawConfig = withdrawConfig
        self.dictionary = dictionary
        showContractView.isHidden = withdrawConfig == nil
        if let withdrawal = withdrawConfig {
            withdrawal.notice?.forEach({ notice in
                switch notice.type {
                case .SMART_CONTRACT, .POPUP:
                    contract = "dialog_smart_contract_warning_beforeclick".Localizable()
                    showContractLabel.addTapGesture {
                        ContractAdressView().show(title: String(format: "dialog_smart_contract_warning_title".Localizable(),
                                                                self.platform?.currencyID ?? ""),
                                                  address: notice.data ?? "",
                                                  titleButton: "common_confirm".Localizable(),
                                                  onNextAction: nil)
                    }
                    break
                case .TEXT:
                    if let dic = dictionary,
                        let predefined = notice.text?.predefined,
                        let text = dic[predefined] {
                        isLocalizable = false
                        contract = text
                    }
                default:
                    break
                }
            })
        }
        if isLocalizable {
            contract = "dialog_smart_contract_warning_beforeclick".Localizable()
            showContractLabel.text = contract
            showContractLabel.underline()
        } else {
            showContractLabel.text = contract
            showContractLabel.underline()
        }
        
    }
}
