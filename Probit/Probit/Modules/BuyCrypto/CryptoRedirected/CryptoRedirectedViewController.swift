//
//  CryptoRedirectedViewController.swift
//  Probit
//
//  Created by Thân Văn Thanh on 26/08/2022.
//  
//

import UIKit

enum CryptoRedirectedViewType: String {
    case pending = "pending"
    case done = "done"
    case failed = "failed"
}

class CryptoRedirectedViewController: BaseViewController {
    
    @IBOutlet weak var cryptoImage: UIImageView!
    @IBOutlet weak var pendingTitle: UILabel!
    @IBOutlet weak var pendingSprinTitle: UILabel!
    @IBOutlet weak var spinnerView: SpinnerView!
    @IBOutlet weak var pendingGuideTitle1: UILabel!
    @IBOutlet weak var pendingGuideTitle2: UILabel!
    @IBOutlet weak var goToButton: StyleButton!
    
    @IBOutlet weak var defaultView: UIView!
    @IBOutlet weak var notificationView: UIView!
    
    @IBOutlet weak var notifiationIcons: UIImageView!
    @IBOutlet weak var notificationTitle: UILabel!
    @IBOutlet weak var notificationHintLabel: UILabel!
    
    // MARK: - Properties
    var presenter: ViewToPresenterCryptoRedirectedProtocol?
    var viewType: CryptoRedirectedViewType = .pending
    let dispatchGroup = DispatchGroup()
    
    private var timer: Timer?
    private var count = 1
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.cryptoCheckout()
        startTimer()
        setupViewPending()
        presenter?.getCurrency()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
            switch viewType {
            default:
                hideNavigationBar(isHide: false)
            }
        stopTimer()
    }
    
    override func setupUI() {
        super.setupUI()
        setupNavigationbar()
    }
    
    override func localizedString() {
        notificationView.isHidden = true
        let method = presenter?.method ?? ""
        LoadImageUrl.shared.cryptoProviderImage(with: method.lowercased(), in: cryptoImage)
        
        pendingTitle.text = String.init(format: "buycrypto_pending_title".Localizable(),
                                        "\(method)")
        pendingSprinTitle.text = "buycrypto_pending_spinner_text".Localizable()
        pendingGuideTitle1.text = "• " + String.init(format: "buycrypto_pending_guide_1".Localizable(),
                                                     "\(method)")
        pendingGuideTitle2.text = "• " + String.init(format: "buycrypto_pending_guide_2".Localizable(),
                                                     "\(method)")
        goToButton.setTitle(String.init(format: "common_gotogeneric".Localizable(),
                                        "\(method)"),
                            for: .normal)
    }
    
    private func setupViewType(_ type: String) {
        if let type = CryptoRedirectedViewType(rawValue: type) {
            self.viewType = type
            switch type {
            case .pending:
                setupViewPending()
            case .done:
                setupViewDone()
            case .failed:
                setupViewFailed()
            }
        }
    }
    
    private func setupNavigationbar() {
        var leftTitle = "navigationbar_home".Localizable()
        let viewControllers = self.getRootTabbarViewController().viewControllers
        if viewControllers.first(where: { $0.className == WalletViewController.className}) != nil {
            leftTitle = presenter?.params?.crypto ?? ""
        }
        
        setupNavigationBar(title: "v2icon_home_buycrypto".Localizable(),
                                titleLeftItem: leftTitle)
        addRightBarItem(imageName: "ico_exit",
                        imageTouch: "ico_exit",
                        title: "")
    }
    
    private func setupViewPending() {
        hideNavigationBar(isHide: false)
        defaultView.isHidden = false
        notificationView.isHidden = true
        let method = presenter?.method ?? ""
        goToButton.setTitle(String.init(format: "common_gotogeneric".Localizable(),
                                        "\(method)"),
                            for: .normal)
        goToButton.did(.touchUpInside) { _, _ in
            self.presenter?.cryptoCheckout()
        }
    }
    
    private func setupViewDone() {
        hideNavigationBar()
        notificationView.isHidden = false
        defaultView.isHidden = true
        notifiationIcons.image = UIImage(named: "img_succes")
        notificationTitle.textColor = UIColor.color_4231c8_6f6ff7
        notificationTitle.text = "buycrypto_done_title".Localizable()
        notificationHintLabel.text = "fragment_buycrypto_notification_hintLabel".Localizable()
        goToButton.setTitle(String.init(format: "common_gotogeneric".Localizable(),
                                        "navigationbar_wallet".Localizable()), for: .normal)
        stopTimer()
        goToButton.did(.touchUpInside) { _, _ in
            self.presenter?.navigateToWallet()
        }
    }
    
    func setupViewFailed() {
        hideNavigationBar()
        notificationView.isHidden = false
        defaultView.isHidden = true
        notifiationIcons.image = UIImage(named: "ico_redirected_warning")
        notificationTitle.text = "fragment_buycrypto_notification_failt".Localizable()
        notificationTitle.textColor = UIColor.color_f25d4e
        notificationHintLabel.text = String.init(format: "buycrypto_fail_content".Localizable(),
                                                 "common_tryagain".Localizable())
        goToButton.setTitle("common_tryagain".Localizable(), for: .normal)
        stopTimer()
        goToButton.did(.touchUpInside) { _, _ in
            self.setupViewPending()
            self.presenter?.cryptoCheckout()
        }
    }
    
    override func tappedLeftBarButton(sender: UIButton) {
        stopTimer()
        let specificViewcontrollers = [CryptoTransfersViewController.className,
                                       StakeDetailsViewController.className,
                                       HomeViewController.className]
        _ = self.popToSpecialViewControlle(specialViewcontrollers: specificViewcontrollers)
    }
    
    override func tappedRightBarButton(sender: UIButton) {
        self.showPopupHelper("buycrypto_pending_dialog_title".Localizable(),
                             message: "buycrypto_pending_dialog_content".Localizable() + "                 ",
                             warning: nil,
                             acceptTitle: "dialog_yes".Localizable(),
                             cancleTitle: "dialog_no".Localizable(),
                             acceptAction: {
            self.stopTimer()
            self.popToRoot()
        }, cancelAction: nil)
    }
    
    @objc
    private func updateCountDownTime() {
        if(count > 0){
            count -= 1
        } else {
            presenter?.checkPayment()
            timer?.invalidate()
            timer = nil
            startTimer()
        }
    }
    
    private func startTimer() {
        stopTimer()
        count = 1
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(updateCountDownTime),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    deinit {
        stopTimer()
    }
    
}

extension CryptoRedirectedViewController: PresenterToViewCryptoRedirectedProtocol{
    // TODO: Implement View Output Methods
    func reloadCheckout() {
        presenter?.checkPayment()
    }
    
    func checkPayment(result: String) {
        setupViewType(result)
    }
    
    func checkoutFailure(message: String) {
        showPopupHelper("buycrypto_fail_to_load".Localizable(),
                        message: "error_message_something_went_wrong".Localizable(),
                        acceptTitle: "common_retry".Localizable(),
                        cancleTitle: "dialog_cancel".Localizable(),
                        acceptAction: {
            self.presenter?.cryptoCheckout()
            self.startTimer()
        },
                        cancelAction: {
            self.pop()
        })
    }
}
