//
//  AirdropsCollectionPageViewController.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 26/12/2565 BE.
//  
//

import UIKit

class AirdropsCollectionPageViewController: BaseViewController {
    private var tableViewDelegate: BaseTableViewDelegate<EventAirdropsTableViewCell>?
    @IBOutlet weak var tableView: UITableView!
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setupTableView()
    }

    // MARK: - Properties
    var presenter: ViewToPresenterAirdropsCollectionPageProtocol?
    
    
    func setupTableView() {
        tableView.separatorStyle = .none
        tableViewDelegate = BaseTableViewDelegate(hasPull: false,
                                                  hasLoadMore: false,
                                                  tableView: self.tableView)
        tableViewDelegate?.didSelectRow = didSelectedCell(_:_:)
        tableViewDelegate?.setupCell = setupCell(indexPath:dataItem:cell:)
        tableViewDelegate?.noDataMessage = "airdrop_event_nomatch".Localizable()
        tableViewDelegate?.dataArray = [presenter?.interactor?.listAirdrop ?? []]
    }
    
    private func didSelectedCell(_ indexPath: IndexPath, _ cell: UITableViewCell) {
        guard let data = presenter?.interactor?.listAirdrop.at(indexPath.row),
              let eventLink = data.eventLink else { return }
        let url = String(format: AppConstant.Link.articleLink, eventLink)
        CommonWebViewRouter().showScreen(titleBackScreen: "common_previous".Localizable(),
                                         urlString: url,
                                         titleNavigation: "ProBit Global")
        
    }
    
    private func didSelectedFooter(_ section: Int) {
        presenter?.loadMore()
        tableViewDelegate?.sectionFooterView = [UIView]()
        tableView.reloadData()
    }
    
    private let buttonLoadMore = HighlightButon(type: .custom)

    private func initFooterView() -> UIView {
        let footerView = UIView()
        buttonLoadMore.setTitle("v2icon_home_more".Localizable(), for: .normal)
        buttonLoadMore.titleLabel?.font = UIFont.font(style: .medium, size: 16.0)
        footerView.addSubview(buttonLoadMore)
        
        buttonLoadMore.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.bottom.top.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
        }
        
        buttonLoadMore.bgColor = .color_background_view
        buttonLoadMore.strokeColor = UIColor.color_4231c8_6f6ff7
        buttonLoadMore.textColor = UIColor.color_4231c8_6f6ff7
        buttonLoadMore.borderWidth = 1
        buttonLoadMore.cornerRadius = 2
        buttonLoadMore.highlightType = .outlineButton1
        return footerView
    }
    
    private func setupCell(indexPath: IndexPath, dataItem: Any, cell: UITableViewCell) {
        // TODO: Setup UI for cell
        if let moreCell = cell as? EventAirdropsTableViewCell,
           let data = presenter?.interactor?.listAirdrop.at(indexPath.row) {
            moreCell.setupCell(object: data, indexPath: indexPath)
        }
    }
}

extension AirdropsCollectionPageViewController: PresenterToViewAirdropsCollectionPageProtocol{
    func showFooterLoadMore() {
        tableViewDelegate?.sectionFooterView = [initFooterView()]
        tableViewDelegate?.didSelectFooter = didSelectedFooter(_:)
    }
    
    func reloadData() {
        tableViewDelegate?.dataArray = [presenter?.interactor?.listAirdrop ?? []]
    }
    // TODO: Implement View Output Methods
}
