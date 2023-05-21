//
//  ExchangeDetailViewController.swift
//  Probit
//
//  Created by Nguyen Quang on 13/10/2022.
//  
//

import UIKit

class ExchangeDetailViewController: BaseViewController {
    @IBOutlet weak var infoView: ExchangeInfo!
    @IBOutlet weak var buyButton: HighlightButon!
    @IBOutlet weak var menuBarView: MenuBarView!
    @IBOutlet weak var sellButton: HighlightButon!
    @IBOutlet weak var pageViewController: PageViewController!
    
    var orderSideCurrent: OrderSide?
    // MARK: - Properties
    var presenter: ViewToPresenterExchangeDetailProtocol?

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateFavoriteImage()
        presenter?.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter?.disconnect()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isPortrait {
            self.presenter?.reloadTradingView()
        }
    }
    
    override func setupUI() {
        setupNavigation()
        menuBarView.setupMenu(delegate: self)
        pageViewController.initPageView(listData: presenter?.menus ?? [])
        pageViewController.delegate = self
        
        let tickerColor = AppConstant.tickerColor
        buyButton.textColor = .white
        buyButton.bgColor = tickerColor.buyColor
        buyButton.highlightType = .buy
        buyButton.titleLabel?.font = .font(style: .medium, size: 16)
        
        sellButton.textColor = .white
        sellButton.bgColor = tickerColor.sellColor
        sellButton.highlightType = .sell
        sellButton.titleLabel?.font = .font(style: .medium, size: 16)

        guard let ticker = presenter?.exchange,
              let id = ticker.id else { return }
        updateExchangeData(ticker: ticker)
        addFavoriteBarItem(currentCoinId: id)
    }
    
    override func localizedString() {
        buyButton.setTitle("common_buy".Localizable(), for: .normal)
        sellButton.setTitle("sell_noformat".Localizable(), for: .normal)
    }
    
    @IBAction func buyAction(_ sender: Any) {
        orderSideCurrent = .BUY
        presenter?.checkValidBuySell()
    }
    
    @IBAction func sellAction(_ sender: Any) {
        orderSideCurrent = .SELL
        presenter?.checkValidBuySell()
    }
    
    private func showPopupLoginNeed() {
        showPopupHelper("dialog_login_needed_title".Localizable(),
                        message: "dialog_login_needed_content".Localizable(),
                        warning: nil,
                        acceptTitle: "login_btn_login".Localizable(),
                        cancleTitle: "dialog_cancel".Localizable(),
                        acceptAction: { [weak self] in
            self?.presenter?.navigationLogin()
        }, cancelAction: nil)
    }
    
    private func showUpKycLevel(hightLevel: Int) {
        showPopupHelper("dialog_notice".Localizable(),
                        message: "activity_marketdetails_kycnotenoughtotrade".Localizable().format(hightLevel),
                        warning: nil,
                        acceptTitle: "dialog_serviceagreement_confirmbutton".Localizable(),
                        cancleTitle: nil,
                        acceptAction: { [weak self] in
            self?.presenter?.navigationKycLevel()
        }, cancelAction: nil)
    }
    
    private func showUpMembershipLevel(hightLevel: Int) {
        showPopupHelper("dialog_notice".Localizable(),
                        message: "activity_marketdetails_membershiplevelnotenoughtotrade_nostake".Localizable().format(hightLevel),
                        warning: nil,
                        acceptTitle: "dialog_serviceagreement_confirmbutton".Localizable(),
                        cancleTitle: "dialog_cancel".Localizable(),
                        acceptAction: { [weak self] in
            self?.presenter?.navigationStaking()
        }, cancelAction: nil)
    }
    
    private func showUpAccountSuspened() {
        showPopupHelper("dialog_notice".Localizable(),
                        message: "Account suspend",
                        warning: nil,
                        acceptTitle: "dialog_serviceagreement_confirmbutton".Localizable(),
                        cancleTitle: nil,
                        acceptAction: { [weak self] in
            self?.dismiss {
                
            }
        }, cancelAction: nil)
    }
    
    
    private func setupNavigation() {
        let id = presenter?.exchange?.baseCurrencyId ?? ""
        let subTitle = "\(id)/\(presenter?.exchange?.quoteCurrencyId ?? "")"

        setupNavigationBar(title: presenter?.exchange?.displayName ?? "",
                           subtitle: subTitle,
                           icon: String(format: CurrencyIconType.crypto.url, id),
                           titleLeftItem: "common_previous".Localizable())
    }
    
    override func tappedRightBarButton(sender: UIButton) {

    }
}

extension ExchangeDetailViewController: PresenterToViewExchangeDetailProtocol {

    func reloadData() {
        menuBarView.reloadView()
    }
    
    func updateExchangeData(ticker: ExchangeTicker) {
        guard ticker.id == presenter?.exchange?.id else { return }
        infoView.updateExchangeData(ticker: ticker)
        self.presenter?.updateTradingView(ticker.quoteRate.doubleValue()?.fractionDigits(min: 2, roundingMode: .down))
        setupNavigation()
    }
    
    func updateUsdtRate(usdtRate: String) {
        infoView.updateUsdtRate(rate: usdtRate)
    }
    
    func requestLoginWhenBuySell() {
        showPopupLoginNeed()
    }
    
    func requestKycLevelWhenBuySell(hightLevel: Int) {
        showUpKycLevel(hightLevel: hightLevel)
    }
    
    func requestMembershipLevelWhenBuySell(hightLevel: Int) {
        showUpMembershipLevel(hightLevel: hightLevel)
    }
    
    func showNotiAccountSuspend() {
        showUpAccountSuspened()
    }
    
    func buySellValid() {
        if let orderSideCurrent = orderSideCurrent {
            presenter?.navigationToTradeFeedDetail(orderSide: orderSideCurrent)
        }
    }
}

extension ExchangeDetailViewController: MenuBarViewDelegate {
    func didSelectMenuItem(indexPath: IndexPath) {
        presenter?.didSelectMenuItem(index: indexPath)
        pageViewController.moveSelectedView(index: indexPath.row)
    }
    
    var menus: [MenuBar] {
        get {
            presenter?.interactor?.menus ?? []
        }
        set {
            presenter?.interactor?.menus = newValue
        }
    }
    
    var defaultLeftConstraint: Int {
       return 0
    }
}

extension ExchangeDetailViewController: PageViewProvider {
    func changeSelectedViewLeftConstraint(_ offset: CGFloat) {
        menuBarView.changeSelectedViewLeftConstraint(offset)
    }
    
    func changePageNumber(_ page: Int) {
        changeSelectedMenuBar(page)
    }
    
    func changeSelectedMenuBar(_ page: Int) {
        let indexPath = IndexPath(row: page, section: 0)
        presenter?.didSelectMenuItem(index: indexPath)
        menuBarView.scrollToItem(indexPath: indexPath)
    }
}
