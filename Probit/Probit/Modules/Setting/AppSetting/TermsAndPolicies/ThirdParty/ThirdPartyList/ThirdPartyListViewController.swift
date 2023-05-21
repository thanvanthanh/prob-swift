//
//  ThirdPartyListViewController.swift
//  Probit
//
//  Created by Thân Văn Thanh on 08/12/2022.
//  
//

import UIKit

class ThirdPartyListViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var tableViewDelegate: BaseTableViewDelegate<ThirdPartyTableViewCell>?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        setupTable()
        setupNavigationBar(title: "activity_thirdpartylicenses_play_oss".Localizable(),
                           titleLeftItem: "common_previous".Localizable())
    }
    
    func setupTable() {
        tableViewDelegate = BaseTableViewDelegate(hasPull: false,
                                                  hasLoadMore: false,
                                                  tableView: self.tableView)
        tableViewDelegate?.setupCell = setupCell(indexPath:dataItem:cell:)
        tableViewDelegate?.didSelectRow = didSelectedCell(_:_:)
        tableViewDelegate?.dataArray = [(presenter?.listThirdParty ?? [])]
        tableViewDelegate?.cellheight = 56
    }
    
    // MARK: - TableView delegate, datasource
    private func setupCell(indexPath: IndexPath, dataItem: Any, cell: UITableViewCell) {
        // TODO: Setup UI for cell
        if let cell = cell as? ThirdPartyTableViewCell {
            cell.setupCell(object: dataItem)
        }
    }
    
    private func didSelectedCell(_ dataItem: Any, _ cell: UITableViewCell) {
        guard let indexPath = dataItem as? IndexPath else { return }
        guard let model = presenter?.listThirdParty[indexPath.row] else { return }
        presenter?.navigateToDetail(html: model.url)
    }

    // MARK: - Properties
    var presenter: ViewToPresenterThirdPartyListProtocol?
    
}

extension ThirdPartyListViewController: PresenterToViewThirdPartyListProtocol{
    // TODO: Implement View Output Methods
}
