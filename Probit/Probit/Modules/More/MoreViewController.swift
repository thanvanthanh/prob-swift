//
//  MoreViewController.swift
//  Probit
//
//  Created by Nguyen Quang on 21/09/2022.
//  
//

import UIKit

class MoreViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    private var tableViewDelegate: BaseTableViewDelegate<MoreTableViewCell>?
    // MARK: - Properties
    var presenter: ViewToPresenterMoreProtocol?

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func setupUI() {
        super.setupUI()
        setupNavigationbar()
        setupTable()
    }

    func setupNavigationbar() {
        setupNavigationBar(title: "v2icon_home_more".Localizable(),
                                titleLeftItem: "navigationbar_home".Localizable())
    }
    
    func setupTable() {
        tableViewDelegate = BaseTableViewDelegate(hasPull: false,
                                                  hasLoadMore: false,
                                                  tableView: self.tableView)
        tableViewDelegate?.setupCell = setupCell(indexPath:dataItem:cell:)
        tableViewDelegate?.didSelectRow = didSelectedCell(_:_:)
        tableViewDelegate?.dataArray = [(presenter?.mores ?? [])]
        tableViewDelegate?.cellheight = 60
    }
    
    // MARK: - TableView delegate, datasource
    private func setupCell(indexPath: IndexPath,
                           dataItem: Any, cell: UITableViewCell) {
        // TODO: Setup UI for cell
        if let moreCell = cell as? MoreTableViewCell {
            moreCell.setupCell(object: dataItem)
            let isHiddenSeparator = indexPath.row == (presenter?.mores ?? []).count - 1
            moreCell.separatorInset.left = isHiddenSeparator ? UIScreen.main.bounds.width : 16
            moreCell.separatorInset.right = isHiddenSeparator ? 0 : 16
        }
    }
    
    private func didSelectedCell(_ dataItem: Any,
                                 _ cell: UITableViewCell) {
        guard let indexPath = dataItem as? IndexPath else { return }
        guard let model = presenter?.mores[indexPath.row] else { return }
        presenter?.navigateNextScreen(type: model, viewController: self)
    }
}

extension MoreViewController: PresenterToViewMoreProtocol{
    // TODO: Implement View Output Methods
}
