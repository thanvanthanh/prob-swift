//
//  AirdropsViewController.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 26/12/2565 BE.
//  
//

import UIKit

class AirdropsViewController: BaseViewController {
    @IBOutlet weak var endTab: UIButton!
    @IBOutlet weak var activeTab: UIButton!
    @IBOutlet weak var pageViewController: PageViewController!

    var pageIndex: Int = 0 {
        didSet {
            selectedButton(button: pageIndex == 0 ? activeTab : endTab)
            unSelectedButton(button: pageIndex == 0 ? endTab : activeTab)
            pageViewController.moveSelectedView(index: pageIndex)
        }
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Properties
    var presenter: ViewToPresenterAirdropsProtocol?
    
    override func setupUI() {
        super.setupUI()
        pageIndex = 0
        setupNavigationBar(title: "v2icon_home_airdrops".Localizable(),
                           titleLeftItem: "common_previous".Localizable())
        pageViewController.delegate = self
        pageViewController.initPageView(listData: presenter?.menus ?? [], index: pageIndex)
    }
    
    override func localizedString() {
        activeTab.setTitle("activity_event_activebutton".Localizable(), for: .normal)
        endTab.setTitle("activity_event_endedbutton".Localizable(), for: .normal)
    }
    
    @IBAction func doSelectEnded(_ sender: Any) {
        pageIndex = 1
    }
    
    @IBAction func doSelectActive(_ sender: Any) {
        pageIndex = 0
    }
    
    func selectedButton(button: UIButton) {
        button.borderColor = .color_4231c8_6f6ff7
        button.borderWidth = 1.0
        button.setTitleColor(.color_4231c8_6f6ff7, for: .normal)
        button.backgroundColor = .clear
    }
    
    func unSelectedButton(button: UIButton) {
        button.borderWidth = 0.0
        button.setTitleColor(.color_7b7b7b_646464, for: .normal)
        button.backgroundColor = .color_e6e6e6_2a2a2a
    }
    
}
extension AirdropsViewController: PageViewProvider {
    func changePageNumber(_ page: Int) {
        pageIndex = page
    }
    
    func changeSelectedViewLeftConstraint(_ offset: CGFloat) {
    }
}

extension AirdropsViewController: PresenterToViewAirdropsProtocol{
    func reloadData() {
    }
    // TODO: Implement View Output Methods
}
