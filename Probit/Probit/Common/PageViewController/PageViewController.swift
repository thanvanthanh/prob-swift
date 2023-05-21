//
//  PageViewController.swift
//  Probit
//
//  Created by Nguyen Quang on 31/08/2022.
//

import UIKit

protocol PageViewProvider: AnyObject {
    func changePageNumber(_ page: Int)
    func changeSelectedViewLeftConstraint(_ offset: CGFloat)
}

class PageViewController: BaseView {
    var listData: [MenuBar] = []
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainStackView: UIStackView!
    weak var delegate: PageViewProvider?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initPageView(listData: [MenuBar], index: Int = 0) {
        self.listData = listData
        scrollView.delegate = self
        self.scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        mainStackView.removeFullyAllArrangedSubviews()
        listData.forEach { menuBar in
            let subView: UIView = menuBar.controller.view
            mainStackView.addArrangedSubview(subView)
            subView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                subView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0)
            ])
        }
        moveSelectedView(index: index, animated: false)
    }
    
    func moveSelectedView(index: Int, animated: Bool = true) {
        scrollView.layoutIfNeeded()
        let indexByLanguage = AppConstant.isLanguageRightToLeft ? self.listData.count - index - 1 : index
        scrollView.setContentOffset(CGPoint(x: scrollView.frame.size.width * CGFloat(indexByLanguage), y: 0.0), animated: animated)
    }
}

extension PageViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x / CGFloat(listData.count)
        delegate?.changeSelectedViewLeftConstraint(offset)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = Int(round(scrollView.contentOffset.x / scrollView.frame.size.width))
        let indexByLanguage = AppConstant.isLanguageRightToLeft ? self.listData.count - pageNumber - 1 : pageNumber
        delegate?.changePageNumber(indexByLanguage)
    }
}
