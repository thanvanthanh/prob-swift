//
//  BaseViewController.swift
//  Probit
//
//  Created by Beacon on 10/08/2022.
//

import UIKit
import Alamofire

class BaseViewController: UIViewController {
    private let rightButton = UIButton(type: .custom)
    private var loadingView = UIView()
    private let spinnerView = SpinnerView()
    private var isShowUnderLineColor: Bool = true
    private var timeInBackground: Int = 0
    
    var localTimeZoneAbbreviation: String {
        let timeZone = TimeZone.current.abbreviation() ?? ""
        return String(format: "activity_currencystakehistory_timezonedisplay".Localizable(), timeZone)
    }
    
    let sharedInstance = NetworkReachabilityManager()!
    
    var isConnectedToInternet: Bool {
        return sharedInstance.isReachable
    }
    
    public let isLanguageRightToLeft = AppConstant.isLanguageRightToLeft
    
    private var currentCoinId: String?
    
    private var skip: Int = 0
    
    override func viewDidLoad() {
        setupUI()
        setupRightToLeft(AppConstant.isLanguageRightToLeft)
        localizedString()
        loadData()
        sharedInstance.startListening { [weak self] status in
            guard let self = self else { return }
            if status == .notReachable || status == .unknown{
                self.connectionDisconnected()
                self.skip = 1
            } else {
                if self.skip != 0 {
                    self.connectionReconnected()
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        didLayoutSubviews()
    }
    
    // Localized String in a View Controller
    func localizedString() {
    }
    
    // MARK: - Setup UI
    func setupUI() {
    }
    
    func setupRightToLeft(_ isRTL: Bool) {
        
    }
    
    func didLayoutSubviews() {
    }
    
    func loadData() {
    }
    
    func connectionDisconnected() {
//        SocketService.shared.closeConnection()
        showFloatsMessage(title: nil, message: "refresh_content1".Localizable(), type: .error)
    }
    
    func connectionReconnected() {

    }
    
    // MARK: - Setup dark mode
    func setupDarkMode() {
        setupNavigationBarColor()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // Trait collection has already changed
        setupDarkMode()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        // Trait collection will change. Use this one so you know what the state is changing to.
        setupDarkMode()
    }
    
    // MARK: - Navigation Bar
    func hideNavigationBar(isHide: Bool = true) {
        self.navigationController?.navigationBar.isHidden = isHide
        if !isHide {
            self.navigationController?.navigationBar.isTranslucent = false
        }
    }
    
    func setupNavigationBar(title: String = "",
                            subtitle: String? = nil,
                            icon: String? = nil,
                            titleLeftItem: String?,
                            isShowUnderLineColor: Bool = true) {
        self.isShowUnderLineColor = isShowUnderLineColor
        let titleView = TitleViewNavigationBar()
        titleView.setupTitleView(title: title, subTitle: subtitle, icon: icon)
        self.navigationItem.titleView = titleView
        let vcs = self.getRootTabbarViewController().viewControllers
        var newLeftTitle: String?
        if vcs.count > 1,
           titleLeftItem ==  "common_previous".Localizable() {
            let navViewPrevius = vcs[vcs.count - 2].navigationItem.titleView as? TitleViewNavigationBar
            newLeftTitle = navViewPrevius?.title ?? "navigationbar_home".Localizable()
        } else {
            newLeftTitle = titleLeftItem
        }
        
        if let leftTitle = newLeftTitle {
            addLeftBarItem(imageName: "ico_back", selectedImage: "ico_back", title: leftTitle)
        } else {
            removeLeftBarButton()
        }
        setupNavigationBarColor()
    }
    
    private func setupNavigationBarColor() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        let navColor = UIColor.color_fafafa_181818
        let underLineColor = UIColor.color_e6e6e6_424242
        let navImage = navColor.navBarImage()
        let underLineImage = isShowUnderLineColor ? underLineColor.as1ptImage() : UIColor.clear.as1ptImage()
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundImage = navImage
            appearance.shadowImage = underLineImage
            appearance.titleTextAttributes = [.foregroundColor: UIColor.Basic.mainText]
            navigationItem.standardAppearance = appearance
            navigationItem.scrollEdgeAppearance = appearance
        } else {
            navigationBar.titleTextAttributes = [.foregroundColor: UIColor.Basic.mainText]
            navigationBar.setBackgroundImage(navImage, for: .default)
            navigationBar.shadowImage = underLineImage
        }
    }
    
    func addFavoriteBarItem(currentCoinId: String, hiddenChart: Bool = true) {
        self.currentCoinId = currentCoinId
        rightButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 40)
        rightButton.contentHorizontalAlignment = .right
        updateFavoriteImage()
        let favoriteItem = UIBarButtonItem()
        favoriteItem.customView = rightButton
        
        let chartButton = UIButton(type: .custom)
        chartButton.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        chartButton.contentHorizontalAlignment = .right
        chartButton.setImage(UIImage(named: "ico_candlestick"), for: .normal)
        let chartItem = UIBarButtonItem()
        chartItem.customView = chartButton
        //self.navigationItem.setRightBarButton([rightButton, chartButton], animated: true)
        self.navigationItem.rightBarButtonItems = hiddenChart ? [favoriteItem] : [favoriteItem, chartItem]
        rightButton.addTarget(self,
                              action: #selector(tappedFavoriteButton),
                              for: .touchUpInside)
        chartButton.addTarget(self,
                              action: #selector(tappedChartBarButton),
                              for: .touchUpInside)
    }
    
    func updateFavoriteImage() {
        guard let currentCoinId = self.currentCoinId else { return }
        let isFavorite = AppConstant.listCoinFavorites.first(where: { $0 == currentCoinId }) != nil
        
        let imageNameFavorite = isFavorite ? "ico_favorite_coin" : "ico_not_favorite_coin"
        rightButton.setImage(UIImage.init(named: imageNameFavorite), for: UIControl.State.normal)
    }
    
    @objc func tappedFavoriteButton() {
        guard let currentCoinId = self.currentCoinId else { return }
        var listFavorite = AppConstant.listCoinFavorites
        
        guard let currentIndex = listFavorite.firstIndex(where: { $0 == currentCoinId }) else {
            listFavorite.append(currentCoinId)
            AppConstant.listCoinFavorites = listFavorite
            updateFavoriteImage()
            return
        }
        listFavorite.remove(at: currentIndex)
        AppConstant.listCoinFavorites = listFavorite
        updateFavoriteImage()
    }
    
    @objc func backAction() {
        getRootTabbarViewController().pop()
    }
    
    func addLeftBarItem(imageName: String, selectedImage: String, title: String) {
        let leftButton = UIButton.init(type: UIButton.ButtonType.custom)
        leftButton.isExclusiveTouch = true
        leftButton.isSelected       = false
        leftButton.frame            = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        leftButton.addTarget(self, action: #selector(tappedLeftBarButton(sender:)), for: UIControl.Event.touchUpInside)
        if title.count > 0 {
            leftButton.frame = CGRect.init(x: 0, y: 0, width: 80, height: 40)
            leftButton.setTitle("  \(title.shorted(to: 8))", for: UIControl.State.normal)
            leftButton.setTitleColor(UIColor.color_4231c8_6f6ff7, for: .normal)
            leftButton.titleLabel?.font = .systemFont(ofSize: 17)
        }
        if imageName.count > 0 {
            leftButton.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
            leftButton.setImage(UIImage(named: imageName)?.imageByLanguage(), for: UIControl.State.normal)
            leftButton.setImage(UIImage(named: selectedImage)?.imageByLanguage(), for: UIControl.State.selected)
            let inset: CGFloat = AppConstant.isLanguageRightToLeft ? -8.0 : 4.0
            leftButton.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: inset, bottom: 0, right: -inset)
        }
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftButton)
    }
    
    func addRightBarItem(imageName: String, imageTouch: String, title : String) {
        let rightButton = UIButton.init(type: UIButton.ButtonType.custom)
        rightButton.isExclusiveTouch = true
        rightButton.isSelected       = false
        rightButton.frame            = CGRect.init(x: 0, y: 0, width: 44, height: 44)
        rightButton.addTarget(self, action: #selector(tappedRightBarButton(sender:)), for: UIControl.Event.touchUpInside)
        if title.count > 0 {
            rightButton.frame = CGRect.init(x: 0, y: 0, width: 44, height: 44)
            rightButton.setTitle(title, for: UIControl.State.normal)
            rightButton.titleLabel?.textAlignment = .right
            rightButton.setTitleColor(UIColor.color_4231c8_6f6ff7, for: .normal)
            rightButton.titleLabel?.font = UIFont.font(style: .medium, size: 17)
        }
        if imageName.count > 0 {
            rightButton.frame = CGRect.init(x: 0, y: 0, width: 44, height: 44)
            rightButton.setImage(UIImage(named: imageName)?.imageByLanguage(), for: UIControl.State.normal)
        }
        if imageTouch.count > 0 {
            rightButton.setImage(UIImage(named: imageTouch)?.imageByLanguage(), for: .selected)
        }
        rightButton.contentHorizontalAlignment = .right
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightButton)
    }
    
    func removeRightBarButton() {
        self.navigationItem.rightBarButtonItem = nil
    }
    
    func removeLeftBarButton() {
        self.isShowUnderLineColor = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init()
    }
    
    func addTitle(title : String) {
        self.title = title
    }
    
    func addLogoTitle(background: UIColor) {
        let titleView = UIButton.init(type: UIButton.ButtonType.custom)
        titleView.frame = CGRect.init(x: 0, y: 0, width: 22, height: 24)
        titleView.setImage(UIImage(named: "ico_logo_small"), for: .normal)
        navigationItem.titleView = titleView
        self.isShowUnderLineColor = false
        setupNavigationBarColor()
    }
    
    // MARK: - NavigationBar Action
    @objc func tappedLeftBarButton(sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tappedRightBarButton(sender : UIButton) {
    }
    
    @objc func tappedChartBarButton(sender : UIButton) {
    }
    
    func addObserverKeyBoard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShowNotification),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHideNotification),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc
    func keyboardWillShowNotification(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame: NSValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let heightSafeArea = UIApplication.shared.mainKeyWindow?.safeAreaInsets.bottom ?? 0.0
        
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        updateLayoutWhenKeyboardChanged(height: keyboardHeight - heightSafeArea + 5)
    }
    
    @objc
    func keyboardWillHideNotification(_ notification: Notification) {
        updateLayoutWhenKeyboardChanged(height: 0)
    }
    
    func updateLayoutWhenKeyboardChanged(height: CGFloat) {
        
    }
    
    func addObserverApplicationState() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidEnterBackground),
                                               name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func applicationDidEnterBackground() {
        print("[APPLICATION1]: EnterBackgroundground" )
        let currenDateTime = Date().timeIntervalSinceReferenceDate
        timeInBackground = Int(currenDateTime)
    }
    
    @objc func applicationWillEnterForeground() {
        print("[APPLICATION1]: EnterForeground" )
        let time = Int(Date().timeIntervalSinceReferenceDate) - timeInBackground
        updateTimeInBackground(time: time)
    }
    
    func updateTimeInBackground(time: Int) {
        
    }

}

extension BaseViewController {
    func showLoading() {
        guard let windown = UIApplication.shared.mainKeyWindow else { return }
        loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        spinnerView.lineWidth(5)
        
        let containerView = UIView()
        containerView.backgroundColor = UIColor.color_f5f5f5_2a2a2a.withAlphaComponent(0.8)
        containerView.layer.cornerRadius = 8
        
        if loadingView.isDescendant(of: view) {
            view.bringSubviewToFront(loadingView)
            return
        }
        windown.addSubview(loadingView)
        loadingView.addSubview(containerView)
        containerView.addSubview(spinnerView)
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        // Set contraints to full view
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: windown.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: windown.bottomAnchor),
            loadingView.rightAnchor.constraint(equalTo: windown.rightAnchor),
            loadingView.leftAnchor.constraint(equalTo: windown.leftAnchor),
            
            containerView.widthAnchor.constraint(equalToConstant: 85),
            containerView.heightAnchor.constraint(equalToConstant: 85),
            containerView.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor),
            
            spinnerView.widthAnchor.constraint(equalToConstant: 50),
            spinnerView.heightAnchor.constraint(equalToConstant: 50),
            spinnerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            spinnerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    func hideLoading() {
        if !Thread.isMainThread {
            DispatchQueue.main.sync {
                self.hideLoading()
            }
            return
        }
        loadingView.removeFromSuperview()
        spinnerView.didMoveToWindow()
    }
    
    var isLoading: Bool {
        return loadingView.superview != nil
    }
    
    @discardableResult
    func popToSpecialViewControlle(specialViewcontrollers: [String]) -> Bool {
        let viewControllers = self.getRootTabbarViewController().viewControllers
        let currentNavigation = viewControllers.last?.navigationController
        if let specificVC = viewControllers.first(where: {specialViewcontrollers.contains($0.className)}) {
            currentNavigation?.popToViewController(specificVC, animated: true)
            return true
        } else {
            return false
        }
    }
    
    func handleLoginFlow() {
        let specificViewcontrollers = [BuyCryptoViewController.className,
                                       PurchaseViewController.className,
                                       StakeCollectionViewController.className,
                                       StakeSearchViewController.className,
                                       ExchangeDetailViewController.className,
                                       TradingCompetitionDetailViewController.className,
                                       SettingViewController.className,
                                       CommonWebViewViewController.className,
                                       StakeViewController.className]
        var viewControllers = self.getRootTabbarViewController().viewControllers
        guard let loginViewController = viewControllers.first(where: { $0.className == LoginViewController.className}) as? LoginViewController else { return }
        switch loginViewController.presenter?.requestType {
        case .wallet:
            self.popToRoot()
            self.setupSelectedIndex(index: 3)
        case .history:
            self.popToRoot()
            self.setupSelectedIndex(index: 2)
        case .referralProgram:
            let removeIndex = (viewControllers.firstIndex(where: { $0.className == MoreViewController.className}) ?? 0) + 1
            if viewControllers.count >= removeIndex {
                viewControllers.removeSubrange(removeIndex..<viewControllers.count)
                UIViewController().getRootTabbarViewController().viewControllers = viewControllers
            }
            ReferralRouter().showScreen()
        default:
            if !popToSpecialViewControlle(specialViewcontrollers: specificViewcontrollers) {
                UIViewController().popToRoot()
            }
        }
    }
}

