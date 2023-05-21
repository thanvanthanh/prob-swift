//
//  AnnouncementSection.swift
//  Probit
//
//  Created by Nguyen Quang on 28/09/2022.
//

import UIKit

final class AnnouncementSection: BaseView {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var announcementLabel: UILabel!
    
    // MARK: - Private Variable
    private var annoucements: [Annoucement] = []
    private var timer: Timer?
    private var currentIndex: Int = 0
    
    // MARK: - Public Variable
    weak var delegate: HomeSectionProtocol?
    
    // MARK: - Lifecycle
    override init() {
        super.init()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        stopTimer()
    }
}

// MARK: - Public
extension AnnouncementSection {
    func loadContentBanner(annoucements: [Annoucement]) {
        self.annoucements = annoucements
        guard !annoucements.isEmpty else { return }
        timerSchedule()
        startTimer()
    }
}

// MARK: - Private
private extension AnnouncementSection {
    func setupView() {
        let tapEye = UITapGestureRecognizer(target: self, action: #selector(titleTapped))
        announcementLabel.isUserInteractionEnabled = true
        announcementLabel.addGestureRecognizer(tapEye)
    }
    
    @objc func titleTapped() {
        guard let articleId = annoucements[currentIndex].articleId,
              currentIndex < annoucements.count else { return }
        delegate?.navigateToEvent(link: String(format: AppConstant.Link.articleLink, articleId.string),
                                  title: "")
    }
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 5,
                                     target: self,
                                     selector: #selector(timerSchedule),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func timerSchedule() {
        announcementLabel.fadeTransition(0.2)
        announcementLabel.text = annoucements[currentIndex].title
        currentIndex += 1
        
        if currentIndex >= annoucements.count {
            currentIndex = 0
        }
    }
}
