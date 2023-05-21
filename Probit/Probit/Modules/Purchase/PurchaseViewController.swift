//
//  PurchaseViewController.swift
//  Probit
//
//  Created by Bradley Hoang on 27/09/2022.
//  
//

import UIKit

final class PurchaseViewController: BaseViewController {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var buyButton: StyleButton!
    @IBOutlet private weak var bannerView: PurchaseTopBannerView!
    @IBOutlet private weak var infoInputView: PurchaseInfoInputView!
    @IBOutlet private weak var footerView: PurchaseFooterView!
    @IBOutlet weak var spacingBottom: NSLayoutConstraint!
    @IBOutlet weak var heightBanner: NSLayoutConstraint!
    // MARK: - Properties
    var presenter: ViewToPresenterPurchaseProtocol?
    
    // MARK: - Lifecycle Methods
    override func setupUI() {
        super.setupUI()
        setupNavigationBar(title: "activity_buy_prob_titlebar".Localizable(),
                           titleLeftItem: "common_previous".Localizable())
        buyButton.setEnable(isEnable: !AppConstant.isLogin)
        hideKeyboardWhenTappedAround()
        bannerView.delegate = self
        footerView.delegate = self
        infoInputView.delegate = self
        heightBanner.constant = 0
    }
    
    override func localizedString() {
        if AppConstant.isLogin {
            buyButton.setTitle(String(format: "orderform_BUY".Localizable(),
                                      "(\(0) \("timedelta_seconds".Localizable()))"), for: .normal)
        } else {
            buyButton.setTitle("login_btn_login".Localizable(), for: .normal)
        }
    }
    
    override func loadData() {
        super.loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.interactor?.stopTimer()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        addObserverKeyBoard()
        presenter?.viewDidLoad()
    }
    
    override func updateLayoutWhenKeyboardChanged(height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.spacingBottom.constant = height > 0 ? height : 10
            self.view.layoutIfNeeded()
        }
    }
    
    override func setupDarkMode() {
        super.setupDarkMode()
        footerView.setupDarkMode()
        infoInputView.setupDarkMode()
    }
    
    @IBAction func doBuyAction(_ sender: Any) {
        if AppConstant.isLogin {
            guard let toQuantity = infoInputView.toQuantity,
                  let probRate = presenter?.interactor?.purchaseConversionRate?.rate?.usdt?.prob else { return }
            purchaseRequest?.toQuantity = toQuantity
            purchaseRequest?.stake = footerView.isAcceptStake
            purchaseRequest?.price = probRate
            presenter?.buyCurrency()
        } else {
            PopupHelper.shared.show(viewController: self,
                                    title: "dialog_login_needed_title".Localizable(),
                                    message: "dialog_login_needed_content".Localizable(),
                                    activeTitle: "login_btn_login".Localizable(),
                                    activeAction: {
                LoginRouter(delegate: nil).showScreen()
            }, cancelTitle: "dialog_cancel".Localizable(), cancelAction: nil)
        }
    }
    
    var purchaseRequest: PurchaseRequest? {
        get {
            return presenter?.interactor?.purchaseRequest
        }
        set {
            guard let newValue = newValue else { return }
            presenter?.interactor?.purchaseRequest = newValue
        }
    }
}

// MARK: - PresenterToViewPurchaseProtocol
extension PurchaseViewController: PresenterToViewPurchaseProtocol {
    func showCompleteVC(purchaseModel: PurchaseModel, oldMemberShip: MembershipDetailModel?) {
        if let stake = purchaseModel.stake, stake {
            if let nextLv = oldMemberShip?.nextLevel,
               let toQuantity = purchaseModel.toQuantity?.asDouble(),
               let membershipType = presenter?.interactor?.membership?.membershipType?.title,
               toQuantity >= nextLv.asDouble() {
                PopupHelper().showPurchaseCompleteVC(viewController: self,
                                                     title: String(format: "activity_buy_prob_complete_levelup_title".Localizable(),
                                                                   membershipType),
                                                     image: "ico_purchase_level_up",
                                                     typeScreen: .PURCHASE_STAKE_LEVER_UP,
                                                     onDismiss: { [weak self] in
                    guard let self = self else { return }
                    self.infoInputView.resetView()
                })
            } else {
                PopupHelper().showPurchaseCompleteVC(viewController: self,
                                                     title: "activity_buy_prob_complete_title".Localizable(),
                                                     image: "img_succes",
                                                     typeScreen: .PURCHASE_STAKE,
                                                     onDismiss: { [weak self] in
                    guard let self = self else { return }
                    self.infoInputView.resetView()
                })
            }
            
        } else {
            PopupHelper().showPurchaseCompleteVC(viewController: self,
                                                 title: "buycrypto_done_title".Localizable(),
                                                 image: "img_succes",
                                                 typeScreen: .PURCHASE,
                                                 onDismiss: { [weak self] in
                guard let self = self else { return }
                self.popToRoot()
                WalletRouter().changeSelectedTabbar()
            })
        }
    }
    
    func updateUI() {
        infoInputView.coinConversionConfig = presenter?.coinConversionConfig
        infoInputView.userBalances = presenter?.userBalances ?? []
        infoInputView.purchaseConversionRate = presenter?.interactor?.purchaseConversionRate
        if let membership = presenter?.membership {
            heightBanner.constant = 157
            bannerView.membership = membership
            bannerView.userBalance = presenter?.userBalances.first(where: {$0.currencyID == purchaseRequest?.toCurrencyId})
        } else {
            heightBanner.constant = 0
        }
        footerView.stakeCurrency = presenter?.stakeCurrency
    }
    
    func updateCountdownTime(with time: Int, isBlink: Bool) {
        if AppConstant.isLogin {
            if isBlink {
                buyButton.setTitle(String(format: "orderform_BUY".Localizable(),
                                          "(\(time) \("timedelta_seconds".Localizable()))"), for: .normal)
            } else {
                UIView.performWithoutAnimation {
                    buyButton.setTitle(String(format: "orderform_BUY".Localizable(),
                                              "(\(time) \("timedelta_seconds".Localizable()))"), for: .normal)
                    buyButton.layoutIfNeeded()
                }
            }
        }
    }
}

// MARK: - PurchaseTopBannerViewDelegate
extension PurchaseViewController: PurchaseTopBannerViewDelegate {
    func purchaseTopBannerHintLabelTap(with nextLevel: Double) {
        infoInputView.amountTextField.textColor = UIColor.color_282828_fafafa        
        infoInputView.nextLevelPoint = nextLevel
    }
}

// MARK: - PurchaseFooterViewDelegate
extension PurchaseViewController: PurchaseInfoInputViewDelegate {
    func goToDeposit() {
        if let walletCurrency = presenter?.interactor?.walletCurrency {
            DepositRouter(walletCurrency: walletCurrency).showScreen()
        }
    }
    
    func validateSuccess(_ isSucces: Bool) {
        self.buyButton.setEnable(isEnable: isSucces)
    }
}

// MARK: - PurchaseFooterViewDelegate
extension PurchaseViewController: PurchaseFooterViewDelegate {
    func goToHistory() {
        if AppConstant.isLogin {
            PurchaseHistoryRouter().showScreen()
        } else {
            PopupHelper.shared.show(viewController: self,
                                    title: "dialog_login_needed_title".Localizable(),
                                    message: "dialog_login_needed_content".Localizable(),
                                    activeTitle: "login_btn_login".Localizable(),
                                    activeAction: {
                LoginRouter().showScreen()
            }, cancelTitle: "dialog_cancel".Localizable(), cancelAction: nil)
        }
    }
    
    func purchaseFooterStakeLabelAccept(with duration: String) {
        let message = String(format: "activity_buy_prob_stakecheckbox_dialog_lockupwarning".Localizable(), duration)
        showPopupHelper("dialog_notice".Localizable(),
                        message: message,
                        acceptTitle: "common_confirm".Localizable(),
                        cancleTitle: "dialog_cancel".Localizable(),
                        messageColor: UIColor.color_282828_fafafa) { [weak self] in
            self?.footerView.isAcceptStake = true
        } cancelAction: {}
    }
}
