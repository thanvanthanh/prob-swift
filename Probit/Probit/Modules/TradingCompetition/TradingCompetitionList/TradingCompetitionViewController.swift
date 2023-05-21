//
//  TradingCompetitionViewController.swift
//  Probit
//
//  Created by Nguyen Quang on 22/09/2022.
//  
//

import UIKit

class TradingCompetitionViewController: BaseViewController {
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
        setupNavigationBar(title: "v2icon_home_tc".Localizable(),
                           titleLeftItem: "v2icon_home_more".Localizable(),
                           isShowUnderLineColor: false)
        addRightBarItem(imageName: "ico_search", imageTouch: "", title: "")
    }
    
    override func tappedRightBarButton(sender: UIButton) {
        presenter?.navigateToTradingSearch()
    }
        
    // MARK: - Properties
    var presenter: ViewToPresenterTradingCompetitionProtocol?
}

extension TradingCompetitionViewController: PresenterToViewTradingCompetitionProtocol {
    // TODO: Implement View Output Methods
    func reloadData() {
        menuBarView.reloadView()
    }
    
    func getDataSuccess() {
        let menus = presenter?.menus ?? []
        menuBarView.reloadView()
        pageViewController.initPageView(listData: menus, index: menus.count - 1)
    }
}

extension TradingCompetitionViewController: PageViewProvider {
    
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

extension TradingCompetitionViewController: MenuBarViewDelegate {
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
       return 2
    }
}
