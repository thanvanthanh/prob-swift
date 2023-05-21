//
//  CompleteAlertVC.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 03/10/2565 BE.
//

import UIKit

class CompleteAlertVC: BaseViewController {
    @IBOutlet weak var imgBanner: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var bottomContent: UIView!
    
    @IBOutlet weak var stackCautions: UIStackView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var successButton: StyleButton!
    var timer: Timer?
    var timeToDismiss: Int = 3
    var onDismiss: (() -> Void)?
    var type: CompleteTypePopup = .STAKE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    private func setupView() {
        switch type {
        case .STAKE:
            messageLabel.isHidden = false
            bottomContent.isHidden = true
            stackCautions.isHidden = true
            startTimer()
            messageLabel.text = "activity_stake_complete_willreturnsoon".Localizable()
            self.view.backgroundColor = UIColor.color_fafafa_181818
        case .PURCHASE:
            bottomContent.isHidden = false
            successButton.setTitle(String(format: "common_gotogeneric".Localizable(),
                                          "navigationbar_wallet".Localizable()), for: .normal)
            descriptionLabel.text = "fragment_buycrypto_notification_hintLabel".Localizable()
            descriptionLabel.updateSemanticContent()
            messageLabel.isHidden = true
            self.view.backgroundColor = UIColor.color_fafafa_181818
            stackCautions.isHidden = true
        case .PURCHASE_STAKE:
            startTimer()
            messageLabel.font = UIFont.primary(size: 16.0)
            messageLabel.text = "activity_buy_prob_complete_willreturnsoon".Localizable() //PROB-577
            bottomContent.isHidden = true
            messageLabel.isHidden = false
            self.view.backgroundColor = UIColor.color_fafafa_181818
            stackCautions.isHidden = false
            stackCautions.removeFullyAllArrangedSubviews()
            stackCautions.alignment = .leading
            let caution1String = "activity_buy_prob_complete_notice1".Localizable()
            let caution1 = BulletedListView(caution: caution1String,
                                            font: UIFont.primary(size: 13.0),
                                            color: UIColor.color_646464_7b7b7b)
            let caution2String = "activity_buy_prob_complete_notice2".Localizable()
            let caution2 = BulletedListView(caution: caution2String,
                                            font: UIFont.primary(size: 13.0),
                                            color: UIColor.color_646464_7b7b7b)
            stackCautions.addArrangedSubview(caution1)
            stackCautions.addArrangedSubview(caution2)
        case .PURCHASE_STAKE_LEVER_UP:
            startTimer()
            messageLabel.text = "activity_buy_prob_complete_willreturnsoon".Localizable() //PROB-577
            bottomContent.isHidden = true
            messageLabel.isHidden = false
            stackCautions.isHidden = false
            self.view.backgroundColor = UIColor(hexString: "#4231C8")
            self.messageLabel.textColor = UIColor.color_fafafa
            self.titleLabel.textColor = UIColor.color_fafafa
            stackCautions.removeFullyAllArrangedSubviews()
            stackCautions.alignment = .center
            let caution = BulletedListView(caution: "activity_buy_prob_complete_levelup_notice1".Localizable(),
                                           font: UIFont.primary(size: 13.0),
                                           color: UIColor.color_fafafa)
            caution.contentLabel.textAlignment = .center
            stackCautions.addArrangedSubview(caution)
        }
    }
    
    @IBAction func doDismiss(_ sender: Any) {
        self.onDismiss?()
        self.dismiss(animated: true) {}
    }
    
    @discardableResult
    func load() -> CompleteAlertVC {
        self.loadView()
        return self
    }
    
    @objc func dismissPopup(gesture: UITapGestureRecognizer) {
        self.onDismiss?()
        self.dismiss(animated: true) {}
    }
    
    
    func startTimer() {
        timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 1.0,
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
        timeToDismiss -= 1
        if timeToDismiss <= 0 {
            self.onDismiss?()
            self.dismiss(animated: true)  {
                self.stopTimer()
            }
        }
    }
    
    // MARK: - IBAction Methods
    @discardableResult
    func setTitle(_ title: String?) -> CompleteAlertVC {
        self.titleLabel.text = title
        self.titleLabel.isHidden = (title?.isEmpty ?? true)
        return self
    }
    
    @discardableResult
    func setImage(_ image: String) -> CompleteAlertVC {
        imgBanner.image = UIImage(named: image)
        return self
    }
    
    @discardableResult
    func setOnDismiss(onDismiss: @escaping () -> Void) -> CompleteAlertVC {
        self.onDismiss = onDismiss
        return self
    }
    
    @discardableResult
    func setUpType(_ type: CompleteTypePopup) -> CompleteAlertVC {
        self.type = type
        setupView()
        return self
    }
    
    @discardableResult
    func setTimeDismiss(timeToDismiss: Int) -> CompleteAlertVC {
        self.timeToDismiss = timeToDismiss
        return self
    }
}
