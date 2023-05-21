//
//  KycIntroduceViewController.swift
//  Probit
//
//  Created by Bradley Hoang on 01/11/2022.
//  
//

import UIKit

final class KycIntroduceViewController: BaseViewController {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var kycStepView: HighlightView!
    @IBOutlet private weak var kycStep2Label: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var firstProsLabel: UILabel!
    @IBOutlet private weak var secondProsLabel: UILabel!
    @IBOutlet private weak var errorTitleLabel: UILabel!
    @IBOutlet private weak var errorTitleView: UIView!
    @IBOutlet private weak var errorReasonLabel: UILabel!
    @IBOutlet private weak var confirmButton: StyleButton!
    @IBOutlet weak var stackRejectCode: UIStackView!
    var timer: Timer?
    var timeReview: Date?
    // MARK: - Properties
    var presenter: ViewToPresenterKycIntroduceProtocol?
    var leftTitle = "navigationbar_settings".Localizable()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        setupNavigationBar(title: "globalkyc_title".Localizable(),
                           titleLeftItem: leftTitle)
        kycStepView.applyOutlineButtonStyle1()
    }
    
    override func localizedString() {
        kycStep2Label.text = "globalkyc_step2".Localizable()
        titleLabel.text = "globalkyc_landing_title".Localizable()
        firstProsLabel.text = "globalkyc_landing_benefits_wlimit".Localizable()
        secondProsLabel.text = "globalkyc_landing_benefits_ieo".Localizable()
        errorTitleLabel.text = "globalkyc_infopanel_rejectedreason".Localizable()
        errorReasonLabel.text = "globalkyc_landing_prepareids".Localizable()
        confirmButton.setTitle("globalkyc_landing_button_begin".Localizable(), for: .normal)
    }
}

// MARK: - IBAction
private extension KycIntroduceViewController {
    @IBAction private func confirmButtonTapped(_ sender: Any) {
        self.presenter?.navigateByStatus()
    }
}

// MARK: - Private
private extension KycIntroduceViewController {
    func setupRejectCode() {
        stackRejectCode.removeFullyAllArrangedSubviews()
        guard let rejectCodeArray = presenter?.interactor?.kycStatusModel.rejectCodeArray else { return }
        rejectCodeArray.forEach { rejectMess in
            stackRejectCode.addArrangedSubview(BulletedListView(caution: rejectMess))
        }
    }
    
    func setupView() {
        guard let kycStatusModel = presenter?.interactor?.kycStatusModel else { return }
        switch kycStatusModel.statusType {
        case .done:
            confirmButton.setEnable(isEnable: false)
            let title = String(format: "globalkyc_landing_button_complete".Localizable(), "globalkyc_step2".Localizable())
            confirmButton.setTitle(title, for: .normal)
            errorTitleView.isHidden = true
        case .rejected:
            errorTitleView.isHidden = false
            let inTimeReview = (kycStatusModel.availableTimeDate ?? Date()) > Date()
            if inTimeReview {
                self.timeReview = kycStatusModel.availableTimeDate
                confirmButton.setEnable(isEnable: false)
                setupButton()
                self.startTimer()
            } else {
                confirmButton.setEnable(isEnable: true)
                confirmButton.setTitle("globalkyc_landing_button_begin".Localizable(), for: .normal)
            }
        case .pending:
            confirmButton.setEnable(isEnable: false)
            let title = String(format: "globalkyc_landing_button_processing".Localizable(), "globalkyc_step2".Localizable())
            confirmButton.setTitle(title, for: .normal)
            errorTitleView.isHidden = true
        default:
            confirmButton.setEnable(isEnable: true)
            confirmButton.setTitle("globalkyc_landing_button_begin".Localizable(), for: .normal)
            errorTitleView.isHidden = true
        }
    }
    
    func setupButton() {
        guard let timeReview = self.timeReview else { return }
        let time = timeReview.timeIntervalSince(Date()).stringFromTimeInterval()
        let text = String(format: "globalkyc_landing_button_availableafter".Localizable(), time)
        confirmButton.setTitle(text,
                               for: .normal)
    }
    
    func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(updateCountDownTime),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func updateCountDownTime() {
        guard let timeReview = self.timeReview else { return }
        if timeReview > Date() {
            setupButton()
        } else {
            stopTimer()
            setupView()
        }
    }
    
}

// MARK: - PresenterToView
extension KycIntroduceViewController: PresenterToViewKycIntroduceProtocol {
    func reloadView() {
        setupRejectCode()
        setupView()
    }
    // TODO: Implement View Output Methods
}
