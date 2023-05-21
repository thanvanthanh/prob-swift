//
//  WithdrawSuccessfulViewController.swift
//  Probit
//
//  Created by Dang Nguyen on 10/11/2022.
//  
//

import UIKit

class WithdrawSuccessfulViewController: BaseViewController {
    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var gotoWalletButton: StyleButton!
    // MARK: - Properties
    var presenter: ViewToPresenterWithdrawSuccessfulProtocol?

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        removeLeftBarButton()
    }
    
    override func localizedString() {
        super.localizedString()
        successLabel.text = "dialog_send_successfully".Localizable()
        gotoWalletButton.setTitle(String.init(format: "common_gotogeneric".Localizable(),
                                              "navigationbar_wallet".Localizable()),
                                  for: .normal)
    }
    
    @IBAction func gotoWallet(_ sender: UIButton) {
        presenter?.gotoWallet()
    }
}

extension WithdrawSuccessfulViewController: PresenterToViewWithdrawSuccessfulProtocol{
    // TODO: Implement View Output Methods
}
