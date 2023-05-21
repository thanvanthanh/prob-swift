//
//  PageControl.swift
//  Earable
//
//  Created by Sotatek on 08/06/2022.
//  Copyright © 2022 Earable. All rights reserved.
//

import UIKit
import SnapKit

final class PageControl: UIView {
    
    private var numberOfPage: Int = 5
    private var currentPage: Int = 0
    private var dotColor: UIColor = .init(hexString: "DADADA")
    
    private let space: CGFloat = 8
    private let dotWidth: CGFloat = 6
    private let dotHeight: CGFloat = 6
    private let selectedWidth: CGFloat = 14
    private let mainStackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setNumberOfPage(_ pages: Int) {
        guard self.numberOfPage != pages else { return }
        self.numberOfPage = pages
        guard numberOfPage > currentPage else { return }
        self.updateNumberOfPage()
    }
    
    func setCurrentPage(_ page: Int) {
        guard page < self.numberOfPage else {
            return
        }
        self.updateCurrentPage(page)
    }
    
    private func initView() {
        mainStackView.spacing = space
        mainStackView.axis = .horizontal
        mainStackView.distribution = .fill
        self.addSubview(mainStackView)
        
        mainStackView.snp.makeConstraints { make in
            make.height.equalTo(dotHeight)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func updateNumberOfPage() {
        mainStackView.removeFullyAllArrangedSubviews()
        for i in 0 ..< self.numberOfPage {
            let dot = UIImageView()
            dot.layer.cornerRadius = dotWidth / 2
            dot.image = i == currentPage ? UIImage(named: "img_current_page_bg") : nil
            dot.backgroundColor = dotColor
            mainStackView.addArrangedSubview(dot)
            dot.snp.makeConstraints { make in
                make.width.equalTo(i == currentPage ? selectedWidth : dotWidth)
            }
        }
    }
    
    private func updateCurrentPage(_ page: Int) {
        guard page != currentPage else { return }
        currentPage = page
        updateNumberOfPage()
    }
}
