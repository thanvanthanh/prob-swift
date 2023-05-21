//
//  BaseTableViewDataSource.swift
//  Probit
//
//  Created by Beacon on 10/08/2022.
//

import UIKit
import Foundation

class BaseTableViewDelegate<TableViewCell: BaseTableViewCell>: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var dataArray: [[Any]] = [[]] {
        didSet {
            if dataArray.count == 0 {
                self.addNoDataView()
            } else {
                var isEmptyAllSection = true
                dataArray.forEach { section in
                    if section.count > 0 {
                        isEmptyAllSection = false
                    }
                }
                if isEmptyAllSection {
                    self.addNoDataView()
                } else {
                    self.removeNoDataView()
                }
            }
            tableView.reloadData()
        }
    }
    var didSelectRow: ((_ dataItem: IndexPath, _ cell: UITableViewCell) -> Void)?
    var didSelectHeader: ((_ section: Int) -> Void)?
    var didSelectFooter: ((_ section: Int) -> Void)?
    var setupCell: ((_ indexPath: IndexPath, _ dataItem: Any, _ cell: BaseTableViewCell) -> Void)?
    var setupHeader: ((_ headerView: UIView, _ section: Int) -> Void)?
    var setupFooter: ((_ footerView: UIView, _ section: Int) -> Void)?
    var sectionHeaderView = [UIView]()
    var sectionFooterView = [UIView]()
    var tableViewCellArray = [String]()
    var cellheight: CGFloat?
    var noDataMessage: String?
    var tableView = UITableView()
    var pullToRefreshData: (() -> Void)?
    var loadMoreData: (() -> Void)?
    var hasLoadMore: Bool = true
    var emptyType: TableEmptyType = .normal
    init(hasPull: Bool = true, hasLoadMore: Bool = true, isFromNib: Bool = true, data: [[Any]] = [[]], tableView: UITableView) {
        super.init()
        self.dataArray = data
        self.tableView = tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.removeFooter()
        self.tableView.keyboardDismissMode = .onDrag
        self.hasLoadMore = hasLoadMore
        if isFromNib {
            self.tableView.register(cellType: TableViewCell.self)
        }
        if #available(iOS 15.0, *) {
            self.tableView.sectionHeaderTopPadding = 0.0
        }
        if hasPull {
            self.addPullRefresh()
        }
        if hasLoadMore {
            addLoadmore()
        } else {
            tableView.cr.removeFooter()
        }

    }

    func addPullRefresh() {
        self.tableView.cr.addHeadRefresh(handler: {
            if self.tableView.cr.isRemoveLoadMore(), self.hasLoadMore {
                self.addLoadmore()
            }
            if let pullToRefresh = self.pullToRefreshData {
                // Calling didSelectRow that was set in ViewController.
                pullToRefresh()
            }
        })
    }
    
    func addLoadmore() {
        self.tableView.cr.addFootRefresh {
            if let loadMore = self.loadMoreData {
                // Calling didSelectRow that was set in ViewController.
                loadMore()
            }
        }
    }
    
    func addNoDataView(icons: String = "ico_nodata") {
        let data = dataArray.filter({ !$0.isEmpty })
        guard data.count == 0 else { return }
        if emptyType == .normal {
            self.tableView.setNoDataView(content: noDataMessage, icons: icons)
            print("[noDataMessage]", noDataMessage as Any)
        } else {
            
        }
    }
    
    func removeNoDataView() {
        self.tableView.removeNoDataView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count > section ? dataArray[section].count : 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellheight ?? UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var currentCell = TableViewCell.className
        if tableViewCellArray.count > indexPath.section {
            currentCell = tableViewCellArray[indexPath.section]
        }
        let data = dataArray[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: currentCell) ??  setupDefaultCell()

        if let baseCell = cell as? BaseTableViewCell {
            setupCell?(indexPath,data,baseCell)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath as IndexPath)!
        if let didSelectRow = didSelectRow {
            // Calling didSelectRow that was set in ViewController.
            didSelectRow(indexPath, cell)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if sectionHeaderView.count > section {
            return UITableView.automaticDimension
        } else {
            return .leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if sectionHeaderView.count > section {
            let headerView = sectionHeaderView[section]
            headerView.tag = section
            setupHeader?(headerView,section)
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didSelectedHeader(gesture:)))
            tap.cancelsTouchesInView = false
            headerView.addGestureRecognizer(tap)
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if sectionFooterView.count > section {
            let footerView = sectionFooterView[section]
            footerView.tag = section
            setupFooter?(footerView,section)
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didSelectedFooter(gesture:)))
            tap.cancelsTouchesInView = false
            footerView.addGestureRecognizer(tap)
            return footerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if sectionFooterView.count > section {
            return UITableView.automaticDimension
        } else {
            return .leastNormalMagnitude
        }
    }
    
    @objc func didSelectedHeader(gesture: UITapGestureRecognizer) {
        if let view = gesture.view, let headerCallBack = didSelectHeader {
            headerCallBack(view.tag)
        }
    }
    
    @objc func didSelectedFooter(gesture: UITapGestureRecognizer) {
        if let view = gesture.view, let didSelectFooter = didSelectFooter {
            didSelectFooter(view.tag)
        }
    }
    
    func setupDefaultCell() -> TableViewCell {
        let defaultCell = TableViewCell()
        defaultCell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        return defaultCell
    }
}

enum TableEmptyType {
    case normal
    case search
}
