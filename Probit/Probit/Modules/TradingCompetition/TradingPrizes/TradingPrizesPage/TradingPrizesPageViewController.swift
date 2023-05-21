//
//  TradingPrizesPageViewController.swift
//  Probit
//
//  Created by Nguyen Quang on 04/10/2022.
//  
//

import UIKit

class TradingPrizesPageViewController: BaseViewController {
    
    @IBOutlet weak var menuBarView: MenuBarView!
    @IBOutlet weak var pageViewController: PageViewController!

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setupNavigation()
        menuBarView.setupMenu(delegate: self)
        pageViewController.delegate = self
    }
    
    func setupNavigation() {
        setupNavigationBar(title: presenter?.title ?? "", subtitle: nil,
                           titleLeftItem: presenter?.tradingDetail?.name)
    }
    
    // MARK: - Collection delegate, datasource
    private func setupCell(indexPath: IndexPath,
                           dataItem: Any,
                           cell: UICollectionViewCell) {
        if let cell = cell as? MenuBarItem {
            cell.setupCell(object: dataItem)
        }
    }
    
    private func didSelectItem(_ indexPath: IndexPath, _ dataItem: Any, _ cell: UICollectionViewCell) {
        if cell is MenuBarItem {
            presenter?.didSelectMenuItem(index: indexPath)
            pageViewController.moveSelectedView(index: indexPath.row)
        }
    }
    
    // MARK: - Properties
    var presenter: ViewToPresenterTradingPrizesPageProtocol?
    
}

extension TradingPrizesPageViewController: PresenterToViewTradingPrizesPageProtocol{
    func reloadData() {
        menuBarView.reloadView()
    }
    
    func getDataSuccess() {
        let menus = presenter?.menus ?? []
        menuBarView.isHidden = menus.count == 1
        menuBarView.reloadView()
        pageViewController.initPageView(listData: menus, index: menus.count - 1)
    }
}

extension TradingPrizesPageViewController: PageViewProvider {
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

extension TradingPrizesPageViewController: MenuBarViewDelegate {
    func didSelectMenuItem(indexPath: IndexPath) {
        presenter?.didSelectMenuItem(index: indexPath)
        pageViewController.moveSelectedView(index: indexPath.row)
    }
    
    var menus: [MenuBar] {
        get {
            presenter?.menus ?? []
        }
        set {
            presenter?.menus = newValue
        }
    }
    
    var defaultLeftConstraint: Int {
       return 2
    }
}
