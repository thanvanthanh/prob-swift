//
//  NetworkFeeView.swift
//  Probit
//
//  Created by Dang Nguyen on 06/12/2022.
//

import UIKit

typealias DismissNetworkFee = ((WithdrawalFee) -> Void)

class NetworkFeeView: BaseView {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var networkFeeTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    private var networkFeeArray = [WithdrawalFee]()
    private var selectedNetworkFee: WithdrawalFee?
    private var dismissView: DismissNetworkFee?
    private var tableViewDelegate: BaseTableViewDelegate<NetworkFeeTableViewCell>?

    override func localizedString() {
        networkFeeTitleLabel.text = "common_networkfee".Localizable()
        doneButton.setTitle("transferdistributionhistoryadapter_done".Localizable(), for: .normal)
    }
    
    func setupTableView() {
        tableViewDelegate = BaseTableViewDelegate(hasPull: false,
                                                  hasLoadMore: false,
                                                  tableView: self.tableView)
        tableViewDelegate?.setupCell = setupCell(indexPath:dataItem:cell:)
        tableViewDelegate?.didSelectRow = didSelectedCell(_:_:)
        tableViewDelegate?.dataArray = [networkFeeArray]
    }
    
    // MARK: - TableView delegate, datasource
    private func setupCell(indexPath: IndexPath, dataItem: Any, cell: UITableViewCell) {
        // TODO: Setup UI for cell
        if let networkFeeCell = cell as? NetworkFeeTableViewCell, let currentNetworkFee = self.selectedNetworkFee {
            networkFeeCell.setupCell(object: [dataItem, currentNetworkFee])
        }
    }
    
    private func didSelectedCell(_ dataItem: Any, _ cell: UITableViewCell) {
        guard let indexPath = dataItem as? IndexPath else { return }
        selectedNetworkFee = networkFeeArray[indexPath.row]
        tableView.reloadData()
    }
    
    func detectNetworkFee(networkFeeList: [WithdrawalFee], currentNetworkFee: WithdrawalFee, isShow: Bool, dismiss: @escaping (WithdrawalFee) -> Void) {
        dismissView = dismiss
        networkFeeArray = networkFeeList
        self.selectedNetworkFee = currentNetworkFee
        if isShow {
            showNetworkFeeView()
        } else {
            self.removeFromSuperview()
        }
    }
    
    func showNetworkFeeView() {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        delegate.window?.addSubview(self)
        setupTableView()
    }
    
    @IBAction func dismissView(_ sender: UIButton) {
        if let dismiss = self.dismissView, let currentNetworkFee = self.selectedNetworkFee {
            dismiss(currentNetworkFee)
        }
        self.removeFromSuperview()
    }
    
    @IBAction func selectedNetworkFee(_ sender: UIButton) {
        if let dismiss = self.dismissView, let currentNetworkFee = self.selectedNetworkFee {
            dismiss(currentNetworkFee)
        }
        self.removeFromSuperview()
    }
}
