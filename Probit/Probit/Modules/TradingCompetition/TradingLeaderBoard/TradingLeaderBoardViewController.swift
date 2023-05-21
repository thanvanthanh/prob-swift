//
//  TradingLeaderBoardViewController.swift
//  Probit
//
//  Created by Nguyen Quang on 25/09/2022.
//  
//

import UIKit

class TradingLeaderBoardViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    private let timeLabel = UILabel()
    private var tableViewDelegate: BaseTableViewDelegate<TradingLeaderBoardCell>?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupTableView()
    }

    func setupNavigation() {
        setupNavigationBar(title: "tradecompetition_leaderboard_list_titlebar_title".Localizable(),
                                titleLeftItem: presenter?.title)
    }
    
    func setupTableView() {
        tableView.separatorStyle = .none
        tableViewDelegate = BaseTableViewDelegate(hasPull: false,
                                                  hasLoadMore: false,
                                                  tableView: self.tableView)
        tableViewDelegate?.setupCell = setupCell(indexPath:dataItem:cell:)
        tableViewDelegate?.didSelectRow = didSelectedCell(_:_:)
        tableViewDelegate?.dataArray = [presenter?.leaderboard?.data ?? []]
        tableViewDelegate?.sectionHeaderView = [initHeaderView()]
        tableViewDelegate?.noDataMessage = presenter?.noDataMessage
        tableViewDelegate?.addNoDataView(icons: "")

    }
    
    // MARK: - TableView delegate, datasource
    private func setupCell(indexPath: IndexPath, dataItem: Any, cell: UITableViewCell) {
        if let tradingCell = cell as? TradingLeaderBoardCell {
            tradingCell.setupCell(object: dataItem)
        }
    }
    
    private func didSelectedCell(_ dataItem: Any, _ cell: UITableViewCell) {

    }
    
    private func initHeaderView() -> UIView {        
        let headerView = UIView()
        timeLabel.textAlignment = .right
        timeLabel.textColor = UIColor.Basic.grayText6
        timeLabel.text = presenter?.leaderboard?.updatedTimeInGMT
        timeLabel.font = UIFont.font(style: .medium, size: 14)

        headerView.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 24),
            timeLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 12),
            timeLabel.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -16),
            timeLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -12)
        ])
        return headerView
    }
    
    // MARK: - Properties
    var presenter: ViewToPresenterTradingLeaderBoardProtocol?
    
}

extension TradingLeaderBoardViewController: PresenterToViewTradingLeaderBoardProtocol{
    // TODO: Implement View Output Methods
}
