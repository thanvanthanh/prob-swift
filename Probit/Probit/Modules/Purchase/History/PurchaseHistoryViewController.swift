//
//  PurchaseHistoryViewController.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 19/10/2565 BE.
//  
//

import UIKit

class PurchaseHistoryViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    private var tableViewDelegate: BaseTableViewDelegate<PurchaseHistoryTableViewCell>?

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setupNavigation()
        setupTable()
    }
    
    func setupTable() {
        tableViewDelegate = BaseTableViewDelegate(hasPull: false,
                                                  hasLoadMore: false,
                                                  tableView: self.tableView)
        tableViewDelegate?.setupCell = setupCell(indexPath:dataItem:cell:)
        tableViewDelegate?.didSelectRow = didSelectedCell(_:_:)
        tableViewDelegate?.noDataMessage = "report_nocontent_orderhistory".Localizable()
    }
    
    func setupNavigation() {
        setupNavigationBar(title: "activity_buy_prob_history_title".Localizable(),
                                titleLeftItem: "common_previous".Localizable())
    }

    // MARK: - Properties
    var presenter: ViewToPresenterPurchaseHistoryProtocol?
    
    // MARK: - TableView delegate, datasource
    private func setupCell(indexPath: IndexPath, dataItem: Any, cell: UITableViewCell) {
        // TODO: Setup UI for cell
        if let moreCell = cell as? PurchaseHistoryTableViewCell,
           let data = presenter?.interactor?.listPurChaseModel.at(indexPath.row) {
            moreCell.setupCell(object: data)
        }
    }
    
    private func didSelectedCell(_ dataItem: Any, _ cell: UITableViewCell) {

    }
}

extension PurchaseHistoryViewController: PresenterToViewPurchaseHistoryProtocol{
    func updateUI() {
        tableViewDelegate?.dataArray = [presenter?.interactor?.listPurChaseModel ?? []]
    }
    // TODO: Implement View Output Methods
}
