//
//  MenuBarView.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 03/12/2565 BE.
//

import Foundation
import UIKit

protocol MenuBarViewDelegate: AnyObject {
    func didSelectMenuItem(indexPath: IndexPath)
    var menus: [MenuBar] { get set}
    var defaultLeftConstraint: Int { get }
}

class MenuBarView: BaseView {
    @IBOutlet weak var selectedViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var widthViewSeparetor: NSLayoutConstraint!
    private var collectionViewDelegate: BaseCollectionViewDataSource<MenuBarItem>?
    var delegate: MenuBarViewDelegate?
    override func setupUI() {
    }
    
    func setupMenu(delegate: MenuBarViewDelegate) {
        self.delegate = delegate
        guard let menus = self.delegate?.menus else { return }
        let itemSize = CGSize(width: Int(UIScreen.main.bounds.width) / menus.count, height: 44)
        let defaultLeftConstraint = AppConstant.isLanguageRightToLeft ? menus.count - 1 - delegate.defaultLeftConstraint : delegate.defaultLeftConstraint
        changeSelectedViewLeftConstraint(itemSize.width * CGFloat(defaultLeftConstraint))
        widthViewSeparetor.constant = itemSize.width
        collectionViewDelegate = BaseCollectionViewDataSource(hasPull: true,
                                                              hasLoadMore: false,
                                                              itemSize: itemSize,
                                                              collectionView: collectionView)
        collectionViewDelegate?.setupCell = setupCell(indexPath:dataItem:cell:)
        collectionViewDelegate?.didSelectItem = didSelectItem(_:_:_:)
        collectionViewDelegate?.dataArray = delegate.menus
    }
    
    func changeSelectedViewLeftConstraint(_ offset: CGFloat) {
        if AppConstant.isLanguageRightToLeft {
            guard let menus = self.delegate?.menus else { return }
            let widthItem = UIScreen.main.bounds.width/CGFloat(menus.count)
            selectedViewLeftConstraint.constant = UIScreen.main.bounds.width - (widthItem + offset)
        } else {
            selectedViewLeftConstraint.constant = offset
        }
    }
    
    func scrollToItem(indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func reloadView() {
        collectionViewDelegate?.dataArray = self.delegate?.menus ?? []
    }
    
    // MARK: - Collection delegate, datasource
    private func setupCell(indexPath: IndexPath,
                           dataItem: Any,
                           cell: UICollectionViewCell) {
        if let cell = cell as? MenuBarItem {
            cell.setupCell(object: dataItem)
        }
    }
    
    private func didSelectItem(_ indexPath: IndexPath,_ data: Any,_ cell: UICollectionViewCell) {
        if let delegate = self.delegate, cell is MenuBarItem {
            delegate.didSelectMenuItem(indexPath: indexPath)
        }
    }
}
