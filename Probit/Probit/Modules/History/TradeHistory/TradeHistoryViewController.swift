//
//  TradeHistoryViewController.swift
//  Probit
//
//  Created by Nguyen Quang on 29/08/2022.
//  
//

import UIKit

class TradeHistoryViewController: BaseViewController {
    @IBOutlet weak var filterSearchView: FilterSearchView!
    @IBOutlet weak var tableView: UITableView!
    private var tableViewDelegate: BaseTableViewDelegate<OpenOrdersTableViewCell>?
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        setupTableView()
        filterSearchView.delegate = self
        setupFilterAreaColor()
    }
    
    func viewPageWillAppear() {
        presenter?.viewWillAppear()
        filterSearchView.updateView()
    }
    
    func setupTableView() {
        tableView.separatorStyle = .none
        tableViewDelegate = BaseTableViewDelegate(hasPull: false,
                                                  hasLoadMore: false,
                                                  tableView: self.tableView)
        tableViewDelegate?.setupCell = setupCell(indexPath:dataItem:cell:)
        tableViewDelegate?.didSelectRow = didSelectedCell(_:_:)
        tableViewDelegate?.cellheight = UITableView.automaticDimension
        tableViewDelegate?.noDataMessage = "report_nocontent_tradehistory".Localizable()
        tableViewDelegate?.addNoDataView()
        tableViewDelegate?.dataArray = [presenter?.interactor?.tradeHistorys ?? []]
    }
    
    override func setupDarkMode() {
        super.setupDarkMode()
        setupFilterAreaColor()
        if tableView != nil {
            tableView.reloadData()
        }
    }
    
    func setupFilterAreaColor() {
        let filterViewBackgroundColor = isDarkMode ? UIColor.init(hex: 0x424242, alpha: 0.2) : UIColor.init(hex: 0xf5f5f5)
        filterSearchView.backgroundColor = filterViewBackgroundColor
    }
    
    // MARK: - TableView delegate, datasource
    private func setupCell(indexPath: IndexPath, dataItem: Any, cell: UITableViewCell) {
        // TODO: Setup UI for cell
        if let openOrdersCell = cell as? OpenOrdersTableViewCell {
            openOrdersCell.setupCell(object: dataItem)
            let historyCount = presenter?.interactor?.tradeHistorys.count ?? 0
            openOrdersCell.lineView.isHidden = false
            if historyCount > 0, indexPath.row == (historyCount - 1) {
                openOrdersCell.lineView.isHidden = true
            }
        }
    }
    
    private func didSelectedCell(_ dataItem: Any, _ cell: UITableViewCell) {
        print("selected item table view")
    }
    
    // MARK: - Properties
    var presenter: ViewToPresenterTradeHistoryProtocol?
    
}

extension TradeHistoryViewController: FilterSearchViewDelegate {
    func updateFilterTime(startTime: Date, endTime: Date) {
    }
    
    var filterModel: SearchFilterModel {
        get {
            presenter?.interactor?.filterModel ?? SearchFilterModel(limit: 100)
        }
        set {
            presenter?.interactor?.filterModel = newValue
        }
    }
    
    func doSearch() {
        presenter?.viewWillAppear()
    }
}

extension TradeHistoryViewController: PresenterToViewTradeHistoryProtocol {
    func showLoadingView() {
    }
    
    func loadDataToView() {
    }
    
    func reloadView() {
        tableViewDelegate?.dataArray = [presenter?.interactor?.tradeHistorys ?? []]
    }
}
