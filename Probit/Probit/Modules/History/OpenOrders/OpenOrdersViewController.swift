//
//  OpenOrdersViewController.swift
//  Probit
//
//  Created by Nguyen Quang on 29/08/2022.
//  
//

import UIKit

class OpenOrdersViewController: BaseViewController {
    
    @IBOutlet weak var blurHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var openOrdersLabel: UILabel!
    
    @IBOutlet weak var cancelAllView: UIView!
    @IBOutlet weak var cancelAllButton: HighlightButon!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var coverHidenOrderView: UIView!
    @IBOutlet weak var hidenOrderView: SwitchView!
    private var tableViewDelegate: BaseTableViewDelegate<OpenOrdersTableViewCell>?
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        hideNavigationBar()
    }
    
    func viewPageWillAppear() {
        guard let type = presenter?.screenType else { return }
        if type == .defaults {
            presenter?.viewWillAppear(hidePair: false)
        } else {
            presenter?.viewWillAppear(hidePair: hidenOrderView.isOn)
        }
    }
    
    override func setupUI() {
        super.setupUI()
        setupCancelAreaColor()
        hidenOrderView.type = .check
        hidenOrderView.setIsOn(true)
        hidenOrderView.delegate = self
        
        cancelAllButton.strokeColor = .color_e6e6e6_424242
        cancelAllButton.bgColor = .color_fafafa_000000_15
        cancelAllButton.textColor = (presenter?.orderOpens.isEmpty ?? true) ? .color_7b7b7b_b6b6b6:.color_282828_b6b6b6
        cancelAllButton.highlightType = .outlineButton2
        
    }
    
    override func localizedString() {
        super.localizedString()
        openOrdersLabel.text = "report_openorders".Localizable()
        hidenOrderView.setTitle("fragment_openorder_v2_marketfilter".Localizable())
        cancelAllButton.setTitle("fragment_openorder_cancelbar_cancel".Localizable(), for: .normal)
    }
    
    func setupTableView() {
        tableView.separatorStyle = .none
        tableViewDelegate = BaseTableViewDelegate(hasPull: false,
                                                  hasLoadMore: false,
                                                  tableView: self.tableView)
        tableViewDelegate?.noDataMessage = "report_nocontent_openorder".Localizable()
        tableViewDelegate?.setupCell = setupCell(indexPath:dataItem:cell:)
        tableViewDelegate?.didSelectRow = didSelectedCell(_:_:)
        tableViewDelegate?.cellheight = UITableView.automaticDimension
        let orderOpens = presenter?.interactor?.orderOpens ?? []
        let colorTitle: UIColor = orderOpens.isEmpty ? .color_7b7b7b_b6b6b6:.color_282828_b6b6b6
        cancelAllButton.setTitleColor(colorTitle, for: .normal)
        tableViewDelegate?.dataArray = [orderOpens]
        setupOpenOrders()
    }
    
    override func setupDarkMode() {
        super.setupDarkMode()
        setupCancelAreaColor()
        if tableView != nil {
            tableView.reloadData()
        }
    }
    
    func setupCancelAreaColor() {
//        let cancelButtonBorderColor = HighlightType.outline.color
//        cancelAllButton.borderColor = cancelButtonBorderColor
    }
    
    private func setupOpenOrders() {
        guard let type = presenter?.screenType else { return }
        [blurView, headerView, coverHidenOrderView].forEach { $0?.isHidden = type == .defaults}
        
        guard  type == .bottomSheet else { return }
        viewPageWillAppear()
        self.blurHeightConstraint.constant = 1
        blurView.backgroundColor = .clear
        
        guard type == .bottomSheet else { return }
        UIView.animate(withDuration: 1, delay: 0.1) {
            self.hideLoading()
            self.blurHeightConstraint.constant = 0.2
            self.blurView.backgroundColor = UIColor(hexString: "#282828")
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissVC))
        tap.cancelsTouchesInView = true
        blurView.addGestureRecognizer(tap)
    }
    
    // MARK: - TableView delegate, datasource
    private func setupCell(indexPath: IndexPath, dataItem: Any, cell: UITableViewCell) {
        // TODO: Setup UI for cell
        if let openOrdersCell = cell as? OpenOrdersTableViewCell {
            openOrdersCell.setupCell(object: dataItem)
            openOrdersCell.doCancel = { [weak self] in
                guard let self = self,
                      let  openOrder = dataItem as? OrderDataModel,
                      let type = self.presenter?.screenType else { return }
                if type == .defaults {
                    self.presenter?.doCancelOrder(openOrder: openOrder, hidePair: false)
                } else {
                    self.presenter?.doCancelOrder(openOrder: openOrder,
                                                  hidePair: self.hidenOrderView.isOn)
                }
                
            }
        }
    }
    
    private func didSelectedCell(_ dataItem: Any, _ cell: UITableViewCell) {
        print("selected item table view")
    }
    
    @objc func dismissVC() {
        UIView.animate(withDuration: 0.5, animations: {
            self.blurView.backgroundColor = .clear
        }, completion: {_ in
            self.dismiss(animated: true)
        })
    }
    
    @IBAction func cancelAllAction(_ sender: Any) {
        guard let orderOpens = presenter?.interactor?.orderOpens,
              !orderOpens.isEmpty else { return }
        PopupHelper.shared.show(viewController: self,
                                title: "dialog_notice".Localizable(),
                                message: "fragment_openorder_v2_cancel_dialog_content".Localizable(),
                                activeTitle: "common_confirm".Localizable(),
                                activeAction: { [weak self] in
            guard let self = self,
                  let type = self.presenter?.screenType else { return }
            if type == .defaults {
                self.presenter?.doCancelAllOrder(hidePair: false)
            } else {
                self.presenter?.doCancelAllOrder(hidePair: self.hidenOrderView.isOn)
            }
            
        },cancelTitle: "dialog_cancel".Localizable(),
                                cancelAction: nil)
        
    }
    
    @IBAction func headerAction(_ sender: Any) {
        dismissVC()
    }
    
    // MARK: - Properties
    var presenter: ViewToPresenterOpenOrdersProtocol?
    
}

extension OpenOrdersViewController: PresenterToViewOpenOrdersProtocol {
    // TODO: Implement View Output Methods
    func reloadData() {
        let orderOpens = presenter?.interactor?.orderOpens ?? []
        cancelAllButton.isEnabled = !orderOpens.isEmpty
        tableViewDelegate?.dataArray = [orderOpens]
        let titleColor: UIColor = orderOpens.isEmpty ? .color_7b7b7b_b6b6b6 : .color_282828_b6b6b6
        cancelAllButton.setTitleColor(titleColor, for: .normal)
    }
}

extension OpenOrdersViewController: SwitchViewDelegate {
    func onStateChanged(sender: SwitchView) {
        guard let type = presenter?.screenType, type == .bottomSheet else { return }
        presenter?.viewWillAppear(hidePair: hidenOrderView.isOn)
        
    } 
}
