//
//  ExchangeViewController.swift
//  Probit
//
//  Created by Nguyen Quang on 25/08/2022.
//  
//

import UIKit

class ExchangeViewController: BaseViewController {
    @IBOutlet weak var tradingPairSortView: SortView!
    @IBOutlet weak var priceSortView: SortView!
    @IBOutlet weak var changeSortView: SortView!
    @IBOutlet weak var menuBarView: MenuBarView!
    @IBOutlet weak var volSortView: SortView!
    @IBOutlet weak var pageViewController: PageViewController!
    private var currentIndexPath: IndexPath?
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        menuBarView.setupMenu(delegate: self)
        setupNavigation()
        pageViewController.delegate = self
        pageViewController.isHidden = true
        pageViewController.initPageView(listData: presenter?.listExchange ?? [], index: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let exchanges = presenter?.exchanges, exchanges.count > 0 else { return }
        presenter?.subscribeSocket()
        if let currentIndexPath = currentIndexPath, currentIndexPath.row < menus.count {
            presenter?.selectedExchange(index: currentIndexPath)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
        for menuBar in pageViewController.listData {
            let vc = menuBar.controller
            (vc as? ExchangePageViewViewController)?.tableView.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter?.disconnectSocket()
    }
    
    override func localizedString() {
        tradingPairSortView.setTitle("filter_rowtitle_traidingpair".Localizable())
        priceSortView.setTitle("marketlist_price".Localizable())
        changeSortView.setTitle("marketlist_changerate".Localizable())
        volSortView.setTitle("marketlist_volume".Localizable())
    }
    
    override func setupUI() {
        super.setupUI()
        let tapSortVol = UITapGestureRecognizer(target: self, action: #selector(sortVolAction))
        volSortView.addGestureRecognizer(tapSortVol)
        
        let tapSort24hr = UITapGestureRecognizer(target: self, action: #selector(sort24HrAction))
        changeSortView.addGestureRecognizer(tapSort24hr)
        
        let tapSortPrice = UITapGestureRecognizer(target: self, action: #selector(sortPriceAction))
        priceSortView.addGestureRecognizer(tapSortPrice)
        
        let tapTradingPair = UITapGestureRecognizer(target: self, action: #selector(sortTradingPairAction))
        tradingPairSortView.addGestureRecognizer(tapTradingPair)
    }
    
    func setupNavigation() {
        setupNavigationBar(title: "navigationbar_market".Localizable(),
                                titleLeftItem: nil)
        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "ico_search")?.withRenderingMode(.alwaysOriginal),
                                                      style: .plain, target: self,
                                                      action: #selector(searchAction))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func searchAction() {
        presenter?.navigateToSearchExchange()
    }
    
    func resetSortView() {
        [tradingPairSortView, priceSortView, changeSortView, volSortView].forEach {
            $0?.resetView()
        }
    }
    
    @objc
    func sortVolAction() {
        presenter?.sortVolumeData()
    }
    
    @objc
    func sort24HrAction() {
        presenter?.sortChange24HrData()
    }
    
    @objc
    func sortPriceAction() {
        presenter?.sortPriceData()
    }
    
    @objc
    func sortTradingPairAction() {
        presenter?.sortTradingPairData()
    }
    // MARK: - Properties
    var presenter: ViewToPresenterExchangeProtocol?
}

extension ExchangeViewController: PresenterToViewExchangeProtocol{
    // TODO: Implement View Output Methods
    func reloadData() {
        menuBarView.reloadView()
    }
    
    func getDataSuccess() {
        pageViewController.isHidden = false
        menuBarView.reloadView()
        reloadContent()
    }
    
    private func reloadUsdtContent() {
        let exchanges = presenter?.usdtExchanges ?? []
        presenter?.usdtContent?.reloadData(data: exchanges)
    }
    
    private func reloadBtcContent() {
        let exchanges = presenter?.btcExchanges ?? []
        presenter?.btcContent?.reloadData(data: exchanges)
    }
    
    private func reloadEthContent() {
        let exchanges = presenter?.ethExchanges ?? []
        presenter?.ethContent?.reloadData(data: exchanges)
    }
    
    private func reloadDefiContent() {
        let exchanges = presenter?.defiExchanges ?? []
        presenter?.defiContent?.reloadData(data: exchanges)
    }
    
    private func reloadFavoriteContent() {
        let exchanges = presenter?.favoriteExchanges ?? []
        presenter?.favoriteContent?.reloadData(data: exchanges)
    }
    
    private func reloadContent() {
        reloadBtcContent()
        reloadEthContent()
        reloadUsdtContent()
        reloadDefiContent()
        reloadFavoriteContent()
        
        resetSortView()
        switch presenter?.sortType {
        case .pair:
            presenter?.sortCompare == .down ? tradingPairSortView.sortDown() : tradingPairSortView.sortUp()
        case .price:
            presenter?.sortCompare == .down ? priceSortView.sortDown() : priceSortView.sortUp()
        case .vol:
            presenter?.sortCompare == .down ? volSortView.sortDown() : volSortView.sortUp()
        case .change:
            presenter?.sortCompare == .down ? changeSortView.sortDown() : changeSortView.sortUp()
        case .none:
            break
        }

    }
}

extension ExchangeViewController: PageViewProvider {
    func changeSelectedViewLeftConstraint(_ offset: CGFloat) {
        menuBarView.changeSelectedViewLeftConstraint(offset)
    }
    
    func changePageNumber(_ page: Int) {
        changeSelectedMenuBar(page)
    }
    
    func changeSelectedMenuBar(_ page: Int) {
        let indexPath = IndexPath(row: page, section: 0)
        presenter?.selectedExchange(index: indexPath)
        menuBarView.scrollToItem(indexPath: indexPath)

    }
}

extension ExchangeViewController: MenuBarViewDelegate {
    func didSelectMenuItem(indexPath: IndexPath) {
        currentIndexPath = indexPath
        presenter?.selectedExchange(index: indexPath)
        pageViewController.moveSelectedView(index: indexPath.row)
    }
    
    var menus: [MenuBar] {
        get {
            presenter?.interactor?.listExchange ?? []
        }
        set {
            presenter?.interactor?.listExchange = newValue
        }
    }
    
    var defaultLeftConstraint: Int {
       return 1
    }
}
