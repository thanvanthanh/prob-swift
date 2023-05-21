//
//  OrderHistoryViewController.swift
//  Probit
//
//  Created by Nguyen Quang on 29/08/2022.
//  
//

import UIKit

class OrderHistoryViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterView: FilterSearchView!
    
    private var tableViewDelegate: BaseTableViewDelegate<OpenOrdersTableViewCell>?
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        setupTableView()
        setupFilterView()
    }
    
    func viewPageWillAppear() {
        presenter?.viewWillAppear()
        filterView.updateView()
    }
    
    private func setupFilterView() {
        filterView.delegate = self
        filterView.updateView()
    }
    
    func setupTableView() {
        tableView.separatorStyle = .none
        tableViewDelegate = BaseTableViewDelegate(hasPull: false,
                                                  hasLoadMore: false,
                                                  tableView: self.tableView)
        tableViewDelegate?.setupCell = setupCell(indexPath:dataItem:cell:)
        tableViewDelegate?.didSelectRow = didSelectedCell(_:_:)
        tableViewDelegate?.noDataMessage = "report_nocontent_orderhistory".Localizable()
        tableViewDelegate?.cellheight = UITableView.automaticDimension
        let orders = presenter?.interactor?.orders ?? []
        tableViewDelegate?.dataArray = [orders]
    }

    override func setupDarkMode() {
        super.setupDarkMode()
        if tableView != nil {
            tableView.reloadData()
        }
    }
    
    // MARK: - TableView delegate, datasource
    private func setupCell(indexPath: IndexPath, dataItem: Any, cell: UITableViewCell) {
        // TODO: Setup UI for cell
        if let openOrdersCell = cell as? OpenOrdersTableViewCell {
            openOrdersCell.setupCell(object: dataItem)
        }
    }
    
    private func didSelectedCell(_ dataItem: Any, _ cell: UITableViewCell) {
        print("selected item table view")
    }

    // MARK: - Properties
    var presenter: ViewToPresenterOrderHistoryProtocol?
    
}

extension OrderHistoryViewController: FilterSearchViewDelegate {
    func updateFilterTime(startTime: Date, endTime: Date) {
    }
    
    func doSearch() {
        presenter?.viewWillAppear()
    }
    
    
    var filterModel: SearchFilterModel {
        get {
            presenter?.interactor?.filterModel ?? SearchFilterModel(limit: 100)
        }
        set {
            presenter?.interactor?.filterModel = newValue
        }
    }
}

extension OrderHistoryViewController: PresenterToViewOrderHistoryProtocol{
    // TODO: Implement View Output Methods
    func reloadData() {
        let orders = presenter?.interactor?.orders ?? []
        tableViewDelegate?.dataArray = [orders]
    }
}
