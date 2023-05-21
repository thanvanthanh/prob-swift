//
//  StakeHistoryPageViewController.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 06/10/2565 BE.
//  
//

import UIKit

class StakeHistoryPageViewController: BaseViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    private var tableViewDelegate: BaseTableViewDelegate<StakeHistoryTableViewCell>?
    var stakeType: StakeType?

    var listData: [StakeDetailModel] = [] {
        didSet {
            tableViewDelegate?.dataArray = [(listData)]
        }
    }
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.text = localTimeZoneAbbreviation
    }
    
    override func setupUI() {
        super.setupUI()
        setupTable()
    }

    // MARK: - Properties
    var presenter: ViewToPresenterStakeHistoryPageProtocol?
    
    func setupTable() {
        tableViewDelegate = BaseTableViewDelegate(hasPull: false,
                                                  hasLoadMore: false,
                                                  tableView: self.tableView)
        tableViewDelegate?.setupCell = setupCell(indexPath:dataItem:cell:)
        tableViewDelegate?.didSelectRow = didSelectedCell(_:_:)
        tableViewDelegate?.noDataMessage = "activity_walletdetails_nohistory".Localizable()
    }
    
    func fillData(data: [StakeDetailModel]) {
        if let stakeType = self.stakeType {
            self.listData = data.filter({$0.stakeType == stakeType}).sorted(by: {$0.stakedTime?.toDate() ?? Date() > $1.stakedTime?.toDate() ?? Date()})
        } else {
            self.listData = data.sorted(by: {$0.stakedTime?.toDate() ?? Date() > $1.stakedTime?.toDate() ?? Date()})
        }
       
    }
    
    // MARK: - TableView delegate, datasource
    private func setupCell(indexPath: IndexPath, dataItem: Any, cell: UITableViewCell) {
        // TODO: Setup UI for cell
        if let moreCell = cell as? StakeHistoryTableViewCell,
           let data = listData.at(indexPath.row) {
            moreCell.setupCell(object: data)
        }
    }
    
    private func didSelectedCell(_ dataItem: Any, _ cell: UITableViewCell) {

    }
}

extension StakeHistoryPageViewController: PresenterToViewStakeHistoryPageProtocol{
    // TODO: Implement View Output Methods
}
