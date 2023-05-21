//
//  TradingCompetitionContentViewController.swift
//  Probit
//
//  Created by Nguyen Quang on 22/09/2022.
//  
//

import UIKit

class TradingCompetitionContentViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var tableViewDelegate: BaseTableViewDelegate<TradingCompetitionCell>?

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    func setupTableView() {
        tableView.separatorInset = .zero
        tableView.separatorColor = UIColor.color_e6e6e6_424242
        tableViewDelegate = BaseTableViewDelegate(hasPull: false,
                                                  hasLoadMore: false,
                                                  tableView: self.tableView)
        tableViewDelegate?.setupCell = setupCell(indexPath:dataItem:cell:)
        tableViewDelegate?.didSelectRow = didSelectedCell(_:_:)
        tableViewDelegate?.cellheight = UITableView.automaticDimension
        tableViewDelegate?.dataArray = [presenter?.tradings ?? []]
        tableViewDelegate?.noDataMessage = "No search results found."
        tableViewDelegate?.addNoDataView()
    }
    
    // MARK: - TableView delegate, datasource
    private func setupCell(indexPath: IndexPath, dataItem: Any, cell: UITableViewCell) {
        if let tradingCell = cell as? TradingCompetitionCell {
            tradingCell.setupCell(object: dataItem)
        }
    }
    
    private func didSelectedCell(_ dataItem: Any, _ cell: UITableViewCell) {
        guard let indexPath = dataItem as? IndexPath,
              let model = presenter?.tradings[indexPath.row] else { return }
        presenter?.navigateToTradingCompetitionDetail(model: model)
    }
    
    // MARK: - Properties
    var presenter: ViewToPresenterTradingCompetitionContentProtocol?
    
}

extension TradingCompetitionContentViewController: PresenterToViewTradingCompetitionContentProtocol{
    // TODO: Implement View Output Methods
}
