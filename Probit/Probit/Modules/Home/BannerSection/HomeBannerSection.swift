//
//  HomeBannerSection.swift
//  Probit
//
//  Created by Nguyen Quang on 25/08/2022.
//

import Foundation
import InfiniteLayout

class HomeBannerSection: BaseView {
    var timer: Timer?
    var currentIndex: Int = 0
    weak var delegate: HomeSectionProtocol?
    private var bannerItems: [HomeBannerModel] = []
    @IBOutlet weak var collectionView: InfiniteCollectionView!
    
    override init() {
        super.init()
        setupCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        collectionView.velocityMultiplier = 0
        collectionView.isItemPagingEnabled = true
        collectionView.preferredCenteredIndexPath = [0, 0]
        
        collectionView.register(cellType: BannerCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.infiniteDelegate = self
    }
    
    func loadContentBanner(data: [HomeBannerModel]) {
        guard data.count > 0 else { return }
        bannerItems = data
        collectionView.reloadData()
        startTimer()
    }
    
    func startTimer() {
        timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 5.0,
                                          target: self,
                                          selector: #selector(timerSchedule),
                                          userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc
    private func timerSchedule() {
        guard currentIndex < collectionView.numberOfItems(inSection: 0) - 1 else {
            currentIndex = 0
            let indexPath = IndexPath(row: currentIndex, section: 0)
            self.scrollTo(index: indexPath)
            return
        }
        currentIndex += 1
        let indexPath = IndexPath(row: currentIndex, section: 0)
        self.scrollTo(index: indexPath)
    }
    
    deinit {
        stopTimer()
    }
}

// MARK: - UICollectionViewDataSource
extension HomeBannerSection: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCollectionViewCell",
                                                      for: indexPath) as! BannerCollectionViewCell
        let indexPath = self.collectionView.indexPath(from: indexPath)
        cell.setupCell(object: bannerItems[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.bannerItems.count
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension HomeBannerSection: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let indexPath = self.collectionView.indexPath(from: indexPath)
        guard let eventLink = bannerItems[indexPath.row].eventLink else { return }
        delegate?.navigateToEvent(link: eventLink, title: "")
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width - 124,
               height: collectionView.frame.height - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }
}

extension HomeBannerSection: InfiniteCollectionViewDelegate {
    func infiniteCollectionView(_ infiniteCollectionView: InfiniteCollectionView,
                                didChangeCenteredIndexPath from: IndexPath?,
                                to: IndexPath?) {
        guard let index = to else { return }
        currentIndex = index.row
        stopTimer()
        startTimer()
    }
    
    func scrollTo(index: IndexPath) {
        self.collectionView.scrollToItem(at: index,
                                         at: .centeredHorizontally,
                                         animated: true)
    }
}
