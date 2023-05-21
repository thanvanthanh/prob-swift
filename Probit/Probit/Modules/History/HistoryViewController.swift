//
//  HistoryViewController.swift
//  Probit
//
//  Created by Nguyen Quang on 29/08/2022.
//  
//

import UIKit

class HistoryViewController: BaseViewController {
    @IBOutlet weak var menuBarView: MenuBarView!
    @IBOutlet weak var pageViewController: PageViewController!
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        menuBarView.setupMenu(delegate: self)
        pageViewController.initPageView(listData: presenter?.menus ?? [])
        setupNavigation()
        pageViewController.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDataPageView(page: presenter?.currentPage)
    }
    
    
    func loadDataPageView(page: Int?) {
        guard let currentPage = page,
              let menus = presenter?.menus else { return }
        switch currentPage {
        case 0:
            if let openOrderVC = menus[currentPage].controller as? OpenOrdersViewController {
                openOrderVC.viewPageWillAppear()
            }
            return
        case 1:
            if let openOrderVC = menus[currentPage].controller as? OrderHistoryViewController {
                openOrderVC.viewPageWillAppear()
            }
            return
        case 2:
            if let tradeOrderVC = menus[currentPage].controller as? TradeHistoryViewController {
                tradeOrderVC.viewPageWillAppear()
            }
            return
        default:
            return
        }
    }
    
    func setupNavigation() {
        setupNavigationBar(title: "navigationbar_history".Localizable(),
                           titleLeftItem: nil,
                           isShowUnderLineColor: false)
    }
    
    // MARK: - Properties
    var presenter: ViewToPresenterHistoryProtocol?
}

extension HistoryViewController: PresenterToViewHistoryProtocol{
    // TODO: Implement View Output Methods
    func reloadData() {
        menuBarView.reloadView()
    }
    
    func getDataSuccess() {
       
    }
}

extension HistoryViewController: PageViewProvider {
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

extension HistoryViewController: MenuBarViewDelegate {
    func didSelectMenuItem(indexPath: IndexPath) {
        presenter?.didSelectMenuItem(index: indexPath)
        pageViewController.moveSelectedView(index: indexPath.item)
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
