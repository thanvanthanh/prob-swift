//
//  TransactionListViewController.swift
//  Probit
//
//  Created by Dang Nguyen on 27/10/2022.
//  
//

import UIKit

class TransactionListViewController: BaseViewController {
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timeRangeLabel: UILabel!
    @IBOutlet weak var timeTitleLabel: UILabel!
    private var tableViewDelegate: BaseTableViewDelegate<TransactionHistoryTableViewCell>?
    
    // MARK: - Properties
    var presenter: ViewToPresenterTransactionListProtocol?

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Setup UI
    override func setupUI() {
        setupTableView()
        timeTitleLabel.textAlignment = AppConstant.isLanguageRightToLeft ? .right : .left
        timeRangeLabel.textAlignment = AppConstant.isLanguageRightToLeft ? .right : .left
    }
    
    func viewPageWillAppear() {
        presenter?.viewWillAppear()
        applyFilter()
    }
    
    override func localizedString() {
        timeTitleLabel.text = "filter_rowtitle_dates".Localizable()
    }
    
    func setupTableView() {
        tableViewDelegate = BaseTableViewDelegate(hasPull: false,
                                                  hasLoadMore: false,
                                                  tableView: self.tableView)
        tableViewDelegate?.setupCell = setupCell(indexPath:dataItem:cell:)
        tableViewDelegate?.cellheight = UITableView.automaticDimension
        tableViewDelegate?.noDataMessage = "activity_walletdetails_nohistory".Localizable()
        tableViewDelegate?.addNoDataView()
        tableViewDelegate?.dataArray = [presenter?.interactor?.transactionHistory ?? []]
    }
    
    override func setupDarkMode() {
        super.setupDarkMode()
        if tableView != nil {
            tableView.reloadData()
        }
    }
    
    func applyFilter() {
        updateRange()
        presenter?.getTransactionHistory()
    }
    
    func updateRange() {
        let startDate = presenter?.interactor?.startTime ?? Date()
        let endDate = presenter?.interactor?.endTime ?? Date().previousMonth
        
        let startTime = startDate.stringFromDate(format: "yyyy/MM/dd")
        let endTime = endDate.stringFromDate(format: "yyyy/MM/dd")
        timeRangeLabel.text = AppConstant.isLanguageRightToLeft ? "\(endTime)~\(startTime)" : "\(startTime)~\(endTime)"
    }
    
    // MARK: - Actions
    @IBAction func filterTransation(_ sender: UIButton) {
        presenter?.gotoDatePicker(delegate: self)
    }
    
    // MARK: - TableView delegate, datasource
    private func setupCell(indexPath: IndexPath, dataItem: Any, cell: UITableViewCell) {
        // TODO: Setup UI for cell
        if let transactionCell = cell as? TransactionHistoryTableViewCell,
           let transition = dataItem as? TransactionHistory,
           let currency = presenter?.interactor?.currency {
            transactionCell.setupCell(object: [dataItem, currency])
            transactionCell.cancelRequestAction = cancelAction
            transactionCell.detailAction = { [weak self] in
                guard let `self` = self else { return }
                self.presenter?.gotoDetailTransaction(transaction: transition, currency: currency)
            }
        }
    }
    
    func cancelAction(id: String) {
        presenter?.cancelTransaction(transactionId: id)
    }
}

extension TransactionListViewController: PresenterToViewTransactionListProtocol{
    func updateTransactionStatus(transactionId: String) {
        if var transactions = self.tableViewDelegate?.dataArray.first as? [TransactionHistory],
           let currentTransactionIndex = transactions.firstIndex(where: { $0.id == transactionId}) {
            transactions[currentTransactionIndex].updateStatus(newStatus: .canceled)
            self.tableViewDelegate?.dataArray = [transactions]
        }
    }
    
    func showLoadingView() {
    }
    
    func loadDataToView() {
    }
    
    func reloadView() {
        self.updateRange()
        tableViewDelegate?.dataArray = [presenter?.interactor?.transactionHistory ?? []]
    }
}

extension TransactionListViewController: FilterSearchViewDelegate {
    func updateFilterTime(startTime: Date, endTime: Date) {
        presenter?.interactor?.startTime = startTime
        presenter?.interactor?.endTime = endTime
        let startTime = startTime.stringFromDate(format: "yyyy/MM/dd")
        let endTime = endTime.stringFromDate(format: "yyyy/MM/dd")
        timeRangeLabel.text = AppConstant.isLanguageRightToLeft ? "\(endTime)~\(startTime)" : "\(startTime)~\(endTime)"
    }
    
    var filterModel: SearchFilterModel {
        get {
            var defaultFilterModel = SearchFilterModel(limit: 100)
            defaultFilterModel.startTime = Date().previousMonth
            defaultFilterModel.endTime = Date()
            return presenter?.interactor?.filterModel ?? defaultFilterModel
        }
        set {
            presenter?.interactor?.startTime = newValue.startTime
            presenter?.interactor?.endTime = newValue.endTime
            let startTime = newValue.startTime.stringFromDate(format: "yyyy/MM/dd")
            let endTime = newValue.endTime.stringFromDate(format: "yyyy/MM/dd")
            timeRangeLabel.text = AppConstant.isLanguageRightToLeft ? "\(endTime)~\(startTime)" : "\(startTime)~\(endTime)"
            presenter?.interactor?.filterModel = newValue
        }
    }
    
    func doSearch() {
    }
}
