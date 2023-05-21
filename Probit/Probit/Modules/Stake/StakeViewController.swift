//
//  StakeViewController.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 22/09/2565 BE.
//  
//

import UIKit

class StakeViewController: BaseViewController {
    @IBOutlet weak var pageViewController: PageViewController!
    @IBOutlet weak var menuBarView: MenuBarView!
    var presenter: ViewToPresenterStakeProtocol?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        pageViewController.delegate = self
        menuBarView.setupMenu(delegate: self)
        pageViewController.initPageView(listData: presenter?.menus ?? [], index: 2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    override func setupUI() {
        setupNavigationBar(title: "v2icon_home_stake".Localizable(),
                           titleLeftItem: "v2icon_home_more".Localizable(),
                           isShowUnderLineColor: false)
        addRightBarItem(imageName: "ico_search", imageTouch: "ico_search", title: "")
    }
    
    // MARK: - Collection delegate, datasource
    override func tappedRightBarButton(sender: UIButton) {
        presenter?.navigateToSearch()
    }
}

extension StakeViewController: PresenterToViewStakeProtocol{
    // TODO: Implement View Output Methods
    func reloadDataTopMenu() {
        menuBarView?.reloadView()
    }
}

extension StakeViewController: MenuBarViewDelegate {
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

extension StakeViewController: PageViewProvider {
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
