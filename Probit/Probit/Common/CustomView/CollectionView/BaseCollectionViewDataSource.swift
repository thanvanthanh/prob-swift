//
//  BaseCollectionViewDataSource.swift
//  Probit
//
//  Created by Nguyen Quang on 24/08/2022.
//

import UIKit
import Foundation

class BaseCollectionViewDataSource<CollectionViewCell: BaseCollectionViewCell>: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: .init())
    var hasLoadMore: Bool = true
    var itemSize: CGSize? = nil
    var lineSpacing: CGFloat = 0
    var interitemSpacing: CGFloat = 0
    var dataArray: [Any] = [] {
        didSet { collectionView.reloadData() }
    }
    
    var loadMoreData: (() -> Void)?
    var pullToRefreshData: (() -> Void)?
    var getCurrentPage: ((_ page: Int) -> Void)?
    var didSelectItem: ((_ indexPath: IndexPath, _ dataItem: Any, _ cell: UICollectionViewCell) -> Void)?
    var setupCell: ((_ indexPath: IndexPath, _ dataItem: Any, _ cell: BaseCollectionViewCell) -> Void)?
    
    var layoutSize: ((_ collectionView: UICollectionView,
                          _ layout : UICollectionViewLayout,
                          _ indexPath: IndexPath) -> CGSize)?
    
    init(hasPull: Bool = true,
         hasLoadMore: Bool = true,
         isFromNib: Bool = true,
         data: [Any] = [],
         lineSpacing: CGFloat = 0,
         interitemSpacing: CGFloat = 0,
         itemSize: CGSize = .zero,
         scrollDirection: UICollectionView.ScrollDirection = .horizontal,
         collectionView: UICollectionView) {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = itemSize
        layout.minimumLineSpacing = lineSpacing
        layout.scrollDirection = scrollDirection
        layout.minimumInteritemSpacing = interitemSpacing
        collectionView.collectionViewLayout = layout
        self.itemSize = itemSize
        super.init()
        
        self.dataArray = data
        self.collectionView = collectionView
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.hasLoadMore = hasLoadMore
        
        if isFromNib {
            self.collectionView.register(cellType: CollectionViewCell.self)
        }
        if hasPull {
            self.addPullRefresh()
        }
        if hasLoadMore {
            addLoadmore()
        }
    }
    
    func addPullRefresh() {
        self.collectionView.cr.addHeadRefresh(handler: {
            if self.collectionView.cr.isRemoveLoadMore(), self.hasLoadMore {
                self.addLoadmore()
            }
            if let pullToRefresh = self.pullToRefreshData {
                // Calling didSelectRow that was set in ViewController.
                pullToRefresh()
            }
        })
    }
    
    func addLoadmore() {
        self.collectionView.cr.addFootRefresh {
            if let loadMore = self.loadMoreData {
                // Calling didSelectRow that was set in ViewController.
                loadMore()
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currentCell = CollectionViewCell.className
        let data = dataArray[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: currentCell, for: indexPath)
        if let baseCell = cell as? BaseCollectionViewCell {
            setupCell?(indexPath, data, baseCell)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        let data = dataArray[indexPath.row]
        if let didSelectItem = didSelectItem {
            didSelectItem(indexPath, data, cell)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        if let getCurrentPage = getCurrentPage {
            getCurrentPage(page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let layoutSize = layoutSize {
            return layoutSize(collectionView, collectionViewLayout, indexPath)
        }
        return self.itemSize ?? .zero
    }
}
