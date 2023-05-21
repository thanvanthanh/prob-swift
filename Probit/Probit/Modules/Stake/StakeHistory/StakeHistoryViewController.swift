//
//  StakeHistoryViewController.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 06/10/2565 BE.
//  
//

import UIKit

class StakeHistoryViewController: BaseViewController {
    @IBOutlet weak var pageViewController: PageViewController!
    @IBOutlet weak var menuBarView: MenuBarView!
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        menuBarView.setupMenu(delegate: self)
        setupPageView()
        setupNavigation()
    }
    
    func setupNavigation() {
        let currency = self.presenter?.interactor?.interactorDetail.stakeEvent?.currencyId ?? ""
        let title = String(format: "activity_currencystakehistory_title".Localizable(), currency)
        setupNavigationBar(title: title,
                           titleLeftItem: "v2icon_home_stake".Localizable())
    }
    
    func setupPageView() {
        pageViewController.initPageView(listData: presenter?.menus ?? [])
        pageViewController.delegate = self
    }
    
    
    // MARK: - Properties
    var presenter: ViewToPresenterStakeHistoryProtocol?
}

extension StakeHistoryViewController: PageViewProvider {
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

extension StakeHistoryViewController: MenuBarViewDelegate {
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

extension StakeHistoryViewController: PresenterToViewStakeHistoryProtocol{
    func reloadDataTopMenu() {
        menuBarView.reloadView()
    }
    // TODO: Implement View Output Methods
}
