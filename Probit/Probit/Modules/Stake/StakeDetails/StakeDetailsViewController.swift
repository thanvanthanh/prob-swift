//
//  StakeDetailsViewController.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 23/09/2565 BE.
//  
//

import UIKit

class StakeDetailsViewController: BaseViewController {
    @IBOutlet weak var menuBarView: MenuBarView!
    @IBOutlet weak var pageViewController: PageViewController!
    var socketService: SocketService?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        menuBarView.setupMenu(delegate: self)
        setupPageView()
        setupNavigation()
        setupInitPageView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        setupSoket()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        denitSocket()
    }
        
    // MARK: - Properties
    var presenter: ViewToPresenterStakeDetailsProtocol?
    
    func setupNavigation() {
        if let stakeEvent = presenter?.interactor?.stakeEvent,
           let currencyId = stakeEvent.currencyId,
           let displayName = presenter?.interactor?.walletCurrency?.currency?.displayName?.localized {
            setupNavigationBar(title: currencyId,
                               subtitle: displayName,
                               icon: String(format: CurrencyIconType.crypto.url, currencyId),
                               titleLeftItem: "common_previous".Localizable(),
                               isShowUnderLineColor: false)
        } else {
            setupNavigationBar(title: "v2icon_home_stake".Localizable(),
                               titleLeftItem: "common_previous".Localizable(),
                               isShowUnderLineColor: false)
        }
    }
    
    func setupPageView() {
        pageViewController.delegate = self
    }
    
    func setupInitPageView() {
        if presenter?.interactor?.parentTypeVC == .WALLET {
            pageViewController.initPageView(listData: presenter?.menus ?? [], index: 0)
        } else {
            pageViewController.initPageView(listData: presenter?.menus ?? [], index: 1)
        }
    }
    
    // MARK: - Collection delegate, datasource
    private func setupSoket() {
        self.socketService = SocketService()
        socketService?.connect()
        self.socketService?.set(delegate: self)
    }
    
    private func subcribeSocket() {
        self.socketService?.subcribe(channel: .exchangeRate, filter: ["USDT"])
    }
    
    private func denitSocket() {
        self.socketService?.unsubscribe(channel: .exchangeRate)
        self.socketService?.closeConnection()
    }
    
    private func updateViewExchageRate() {
        presenter?.interactor?.stakingRouteVC.updateViewExchageRate()
        presenter?.cryptoTransfersUpdateViewExchageRate()
    }
}

extension StakeDetailsViewController: SocketServiceDelegate {
    
    func onSocketReciever(text: String) {
        guard let data = text.data(using: .utf8, allowLossyConversion: false) else { return }
        if let exchangeRate = try? JSONDecoder().decode(ExchangeRate.self, from: data) {
            presenter?.interactor?.walletCurrency?.mapping(exchangeRate)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.updateViewExchageRate()
            }
        }
    }
    
    func onSocketConnected() {
        self.subcribeSocket()
    }
    
    func viabilityChanged(_ viability: Bool) {
        if viability {
            self.subcribeSocket()
        }
    }
}

extension StakeDetailsViewController: PageViewProvider {
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

extension StakeDetailsViewController: PresenterToViewStakeDetailsProtocol{
    // TODO: Implement View Output Methods
    func reloadDataTopMenu() {
        menuBarView.reloadView()
    }
}

extension StakeDetailsViewController: MenuBarViewDelegate {
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
        if presenter?.interactor?.parentTypeVC == .WALLET {
            return 0
        } else {
            return 1
        }
    }
}
