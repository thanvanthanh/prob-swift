//
//  HomeViewController.swift
//  Probit
//
//  Created by Nguyen Quang on 23/08/2022.
//  
//

import UIKit

class HomeViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    private let bannerSection = HomeBannerSection()
    private let announcementSection = AnnouncementSection()
    private var carouselSection: CarouselSection?
    private var tickerSection: TickerSection?
    private var launcherSection = LauncherSection()
    private let newCoinSection = NewCoinSection()
    private let marketActionSection = MarketActionSection()

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.viewDidLoad()
        presenter?.navigateToAppLock()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.viewWillDisappear()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    override func setupUI() {
        super.setupUI()
        setupTable()
    }

    func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0,
                                                         width: UIScreen.main.bounds.width,
                                                         height: CGFloat.leastNormalMagnitude))
        if #available(iOS 15.0, *) { tableView.sectionHeaderTopPadding = 0.0 }
        tableView.register(cellType: HomeTableViewCell.self)
    }
    
    override func setupDarkMode() {
        super.setupDarkMode()
        guard let section = presenter?.homeSectionData.firstIndex(where: {$0.section == .ticker}),
              let header = tableView(tableView, viewForHeaderInSection: section) as? TickerSection else { return }
        
        header.setupDarkMode()
    }
    
    override func tappedRightBarButton(sender: UIButton) {
        presenter?.navigateToLogin()
    }
    // MARK: - Properties
    var presenter: ViewToPresenterHomeProtocol?
    
    override func connectionDisconnected() {
        super.connectionDisconnected()
        showFloatsMessage(title: nil, message: "refresh_content1".Localizable(), type: .error)
    }
    
    override func connectionReconnected() {
        super.connectionReconnected()
        presenter?.networkRecconnected()
    }
}

extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        presenter?.homeSectionData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        guard presenter?.homeSectionData[section].section == .newcoin  else {
            return 0
        }
        return presenter?.newCoins.count ?? 0
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(HomeTableViewCell.self)
        if let dataItem = presenter?.newCoins[indexPath.row] {
            cell.setupCell(object: dataItem)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dataItem = presenter?.newCoins[indexPath.row] else { return }
        presenter?.selectNewCoin(dataItem)
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        switch presenter?.homeSectionData[section].section {
        case .banner:
            bannerSection.delegate = self
            return bannerSection
        case .announcement:
            announcementSection.delegate = self
            return announcementSection
        case .carousel:
            carouselSection?.delegate = self
            return carouselSection
        case .ticker:
            return tickerSection
        case .newcoin:
            return newCoinSection
        case .marketlistButton:
            marketActionSection.delegate = self
            return marketActionSection
        case .launcher:
            launcherSection.delegate = self
            return launcherSection
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView,
                   heightForFooterInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
}

extension HomeViewController: PresenterToViewHomeProtocol {
    
    func setupNavigationBar() {
        addLogoTitle(background: .init(hexString: "FAFAFA"))
        let isSignedIn = (AppConstant.accessToken != nil)
        if !isSignedIn {
            addRightBarItem(imageName: "",
                            imageTouch: "",
                            title: "common_login".Localizable())
        } else {
            removeRightBarButton()
        }
    }
    
    func getHomeConfigComplete(exchangeRate: ExchangeRate?, marketData: MarketData?) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.reloadBannerSection()
            self.reloadAnnouncementSection()
            self.reloadCarouselSection()
            self.reloadTickerSection(exchangeRate: exchangeRate, marketData: marketData)
            self.tableView.reloadData()
        }
      
    }
    
    func bindData(indexPaths: [Int], exchangeRate: ExchangeRate?, marketData: MarketData?) {
        let newCoins = presenter?.newCoins ?? []
        reloadTickerSection(exchangeRate: exchangeRate, marketData: marketData)
        guard let section = presenter?.homeSectionData.firstIndex(where: { $0.section == .newcoin }),
              tableView.numberOfRows(inSection: section) > 0 else {
            tableView.reloadData()
            return
        }
        indexPaths.forEach {
            if let cell = tableView.cellForRow(at: IndexPath(row: $0, section: section)) as? HomeTableViewCell,
                $0 < newCoins.count {
                cell.updatePrice(usdtRate: newCoins[$0].usdtRate)
            }
        }
    }
}

extension HomeViewController: HomeSectionProtocol {
    func selectNewCoin(with model: NewCoins) {
        presenter?.selectNewCoin(model)
    }
    
    func navigateToBuyCrypto() {
        presenter?.navigateToBuyCrypto()
    }
    
    func navigateToMore() {
        presenter?.navigateToMore()
    }
    
    func navigateToEvent(link: String, title: String) {
        presenter?.navigateToWebView(link: link, title: title)
    }
    
    func navigateToExchange() {
        presenter?.navigateToExchange(from: self)
    }
    
    func navigateToExchangeDetail(with market: Market?) {
//        presenter?.navigateToExchangeDetail(with: market)
        presenter?.navigateToExchangeDetail(with: "")
    }
    
    func navigateToExchangeDetail(exchangeId: String?) {
        guard let exchangeId = exchangeId else { return }
//        presenter?.navigateToExchangeDetail(with: market)
        presenter?.navigateToExchangeDetail(with: exchangeId)
    }
    
    func reloadBannerSection() {
        let banners = presenter?.listBanner ?? []
        bannerSection.loadContentBanner(data: banners)
    }
    
    func reloadAnnouncementSection() {
        let annoucements = presenter?.annoucements ?? []
        announcementSection.loadContentBanner(annoucements: annoucements)
    }
    
    func reloadCarouselSection() {
        let carousels = presenter?.carousels ?? []
        guard let carouselSection = carouselSection else {
            let content = presenter?.homeSectionData.first(where: { $0.section == .carousel })?.content ?? []
            self.carouselSection = .init(content: content)
            self.carouselSection?.loadContentCarousel(data: carousels)
            return
        }
        carouselSection.loadContentCarousel(data: carousels)
    }
    
    func reloadTickerSection(exchangeRate: ExchangeRate? = nil, marketData: MarketData? = nil) {
        let markets = presenter?.makets ?? []
        let content = presenter?.homeSectionData.first(where: { $0.section == .ticker })?.content ?? []
        guard let tickerSection = tickerSection else {
            self.tickerSection = .init(content: content, markets: markets, delegate: self)
            return
        }
        tickerSection.reloadSection(exchangeRate: exchangeRate, marketData: marketData,
                                    content: content, markets: markets, delegate: self)
    }
}

extension HomeViewController: MarketActionSectionDelegate {
    func goToExchage() {
        ExchangeRouter().changeSelectedTabbar()
    }
}
