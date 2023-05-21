//
//  AnnouncementSection.swift
//  Probit
//
//  Created by Nguyen Quang on 09/09/2022.
//

import UIKit
import InfiniteLayout

class CarouselSection: BaseView {
    var timer: Timer?
    var currentIndex: Int = 0
    weak var delegate: HomeSectionProtocol?
    private var carousels: [CarouselModel] = []
    @IBOutlet weak var pageControl: PageControl!
    @IBOutlet weak var collectionView: InfiniteCollectionView!
    @IBOutlet weak var widthPage: NSLayoutConstraint!
    
    init(content: [String]) {
        super.init()
        setupCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        collectionView.isPagingEnabled = true
        collectionView.preferredCenteredIndexPath = nil
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.infiniteDelegate = self
        collectionView.register(cellType: CarouselSectionViewCell.self)
    }
    
    func loadContentCarousel(data: [CarouselModel]) {
        guard data.count > 0 else { return }
        carousels = data
        collectionView.reloadData()
        pageControl.isHidden = data.count < 2
        collectionView.isScrollEnabled = data.count > 1
        if data.count > 1 {
            pageControl.setNumberOfPage(carousels.count)
            startTimer()
        }
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
}

// MARK: - UICollectionViewDataSource
extension CarouselSection: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselSectionViewCell",
                                                      for: indexPath) as! CarouselSectionViewCell
        let indexPath = self.collectionView.indexPath(from: indexPath)
        cell.setupCell(model: carousels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.carousels.count
    }
    
}
// MARK: - UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension CarouselSection: UICollectionViewDelegate,
                               UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let indexPath = self.collectionView.indexPath(from: indexPath)
        guard let eventLink = carousels[indexPath.row].urlLink else { return }
        delegate?.navigateToEvent(link: eventLink, title: "")
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width,
               height: collectionView.frame.height - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}

extension CarouselSection: InfiniteCollectionViewDelegate {
    func infiniteCollectionView(_ infiniteCollectionView: InfiniteCollectionView,
                                didChangeCenteredIndexPath from: IndexPath?,
                                to: IndexPath?) {
        guard let index = to, self.carousels.count > 1 else { return }
        pageControl.setCurrentPage(collectionView.indexPath(from: index).row)
        currentIndex = index.row
        stopTimer()
        startTimer()
    }
    
    func scrollTo(index: IndexPath) {
        self.collectionView.scrollToItem(at: index,
                                         at: .centeredHorizontally,
                                         animated: true)
        pageControl.setCurrentPage(collectionView.indexPath(from: index).row)
    }
}
