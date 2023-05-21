//
//  IntroduceViewController.swift
//  Probit
//
//  Created by Nguyen Quang on 20/09/2022.
//  
//

import UIKit

class IntroduceViewController: BaseViewController {
    var timer: Timer?
    var currentStep: Int = 0
    let introduces: [IntroduceType] = IntroduceType.allCases
    
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var skipContainer: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var sliderStackView: UIStackView!
    @IBOutlet weak var contentStackView: UIStackView!
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        skipButton.setTitle("dialog_skip".Localizable(), for: .normal)
        hideNavigationBar(isHide: true)
        buildSliderStackView()
        buildContentStackView()
        startTimer()
    }
    
    private func buildSliderStackView() {
        sliderStackView.removeFullyAllArrangedSubviews()
        introduces.enumerated().forEach { index, _ in
            let stepView = UIButton(type: .custom)
            stepView.tag = index
            stepView.layer.cornerRadius = 2
            stepView.backgroundColor = index == currentStep ? UIColor.Basic.lightbackground : UIColor.Basic.light30
            sliderStackView.addArrangedSubview(stepView)
            stepView.addTarget(self, action: #selector(tappedSliderItem(button:)), for: .touchUpInside)
        }
    }
    
    func buildContentStackView() {
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        contentStackView.removeFullyAllArrangedSubviews()
        introduces.forEach { menuBar in
            let subView: UIView = menuBar.contentView
            contentStackView.addArrangedSubview(subView)
            
            subView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                subView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 0)
            ])
        }
    }
    
    func startTimer() {
        timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 3.5,
                                          target: self,
                                          selector: #selector(timerSchedule),
                                          userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    deinit {
        stopTimer()
    }
    
    @objc
    private func timerSchedule() {
        let nextIndex = currentStep + 1
        guard nextIndex == 3 else {
            currentStep = nextIndex
            moveSelectedView(index: currentStep)
            return
        }
        stopTimer()
        presenter?.navigateToHome()

    }
    
    @objc func tappedSliderItem(button: UIButton) {
        let index = button.tag
        moveSelectedView(index: index)
    }
    
    @IBAction func skipAction(_ sender: Any) {
        stopTimer()
        presenter?.navigateToHome()
    }
    
    // MARK: - Properties
    var presenter: ViewToPresenterIntroduceProtocol?
    
}

extension IntroduceViewController: PresenterToViewIntroduceProtocol{
    // TODO: Implement View Output Methods
}

extension IntroduceViewController: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        moveSelectedView(index: Int(pageNumber))
        startTimer()
    }
    
    func moveSelectedView(index: Int) {
        skipContainer.isHidden = index == 2
        currentStep = index
        buildSliderStackView()
        scrollView.setContentOffset(CGPoint(x: scrollView.frame.size.width * CGFloat(index), y: 0.0),
                                    animated: true)
    }
}
