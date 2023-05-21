//
//  TradingPrizesViewController.swift
//  Probit
//
//  Created by Nguyen Quang on 23/09/2022.
//  
//

import UIKit

class TradingPrizesViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var tableViewDelegate: BaseTableViewDelegate<TradingPrizesTableViewCell>?

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupTableView() {
        tableView.separatorStyle = .none
        tableView.contentInset.top = 36
        tableViewDelegate = BaseTableViewDelegate(hasPull: false,
                                                  hasLoadMore: false,
                                                  tableView: self.tableView)
        tableViewDelegate?.setupCell = setupCell(indexPath:dataItem:cell:)
        tableViewDelegate?.didSelectRow = didSelectedCell(_:_:)
        tableViewDelegate?.cellheight = 41
        tableViewDelegate?.dataArray = [presenter?.tradings ?? []]
    }
    
    // MARK: - TableView delegate, datasource
    private func setupCell(indexPath: IndexPath, dataItem: Any, cell: UITableViewCell) {
        if let tradingCell = cell as? TradingPrizesTableViewCell {
            tradingCell.setupCell(object: dataItem)
            let tradings = presenter?.tradings ?? []
            tradingCell.spacingBottom.isHidden = indexPath.row != tradings.count - 1
        }
    }
    
    private func didSelectedCell(_ dataItem: Any, _ cell: UITableViewCell) {

    }

    // MARK: - Properties
    var presenter: ViewToPresenterTradingPrizesProtocol?
    
}

extension TradingPrizesViewController: PresenterToViewTradingPrizesProtocol{
    // TODO: Implement View Output Methods
}
