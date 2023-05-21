//
//  TradingCompetitionDetailViewController.swift
//  Probit
//
//  Created by Nguyen Quang on 22/09/2022.
//
//

import UIKit
import WebKit

class TradingCompetitionDetailViewController: BaseViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var eventView: UIButton!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var boosterView: BoosterView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var webViewHtml: WKWebView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var prizeTotalLabel: UILabel!
    
    @IBOutlet weak var requirementLabel: UILabel!
    @IBOutlet weak var requirementSpacing: UIView!
    @IBOutlet weak var requirementStackView: UIStackView!
    @IBOutlet weak var requirementContainerView: UIStackView!
    
    @IBOutlet weak var informationStackView: UIStackView!
    @IBOutlet weak var informationLabel: UILabel!
    
    @IBOutlet weak var prizesView: HighlightView!
    @IBOutlet weak var prizesLabel: UILabel!
    @IBOutlet weak var leaderBoardView: HighlightView!
    @IBOutlet weak var leaderBoardLabel: UILabel!
    
    @IBOutlet weak var noticeStackView: UIStackView!
    
    @IBOutlet weak var noticeLabel: UILabel!
    @IBOutlet weak var confirmButton: StyleButton!
    @IBOutlet weak var heightConstraintHtmlView: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var actionView: UIView!
    
    @IBOutlet weak var ineligibleView: UIView!
    @IBOutlet weak var ineligibleLabel: UILabel!
    
    // MARK: - Private Variable
    private var seeDetailsBulletedListView: BulletedListView?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        getObservers()
        presenter?.viewDidLoad()
        boosterView.isHidden = true
        confirmButton.isHidden = true
        ineligibleView.isHidden = true
        scrollView.contentInset.bottom = 50
        prizesView.applyNornalStyle()
        leaderBoardView.applyNornalStyle()
    }
    
    override func localizedString() {
        containerView.isHidden = true

        webViewHtml.scrollView.isScrollEnabled = false
        webViewHtml.uiDelegate = self
        webViewHtml.navigationDelegate = self
        webViewHtml.isOpaque = false
        webViewHtml.scrollView.backgroundColor = .clear
        webViewHtml.backgroundColor = .clear
        leaderBoardLabel.text = "tradecompetition_main_leaderboard".Localizable()
        prizesLabel.text = "tradecompetition_main_prizes".Localizable()
        contentLabel.text = "tradecompetition_main_summary_warning".Localizable()
        ineligibleLabel.text = "tradecompetition_main_starttrading_button_warning".Localizable()
        
        let prizesTap = UITapGestureRecognizer(target: self, action: #selector(prizesTapAction))
        prizesView.addGestureRecognizer(prizesTap)
        let leaderBoardTap = UITapGestureRecognizer(target: self, action: #selector(leaderBoardTapAction))
        leaderBoardView.addGestureRecognizer(leaderBoardTap)
        confirmButton.setTitle("tradecompetition_main_starttrading_button_title".Localizable(), for: .normal)
        noticeLabel.text = "dialog_notice".Localizable()
    }
    
    func setupNavigation() {
        setupNavigationBar(title: (presenter?.title).value,
                                titleLeftItem: "v2icon_home_tc".Localizable())
        addRightBarItem(imageName: "", imageTouch: "", title: "")
    }
    
    @objc func prizesTapAction() {
        presenter?.navigateToTradingPrizes()
    }
    
    @objc func leaderBoardTapAction() {
        presenter?.navigateToLeaderBoard()
    }
    
    @IBAction func startTradingAction(_ sender: Any) {
        presenter?.startTrading()
    }
    
    func getObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loginComplete(notfication:)),
                                               name: .loginComplete,
                                               object: nil)
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: .loginComplete, object: nil)
    }
    
    @objc
    func loginComplete(notfication: NSNotification) {
        presenter?.viewDidLoad()
    }
    
    deinit {
        removeObservers()
    }
    
    // MARK: - Properties
    var presenter: ViewToPresenterTradingCompetitionDetailProtocol?
    
}

extension TradingCompetitionDetailViewController: PresenterToViewTradingCompetitionDetailProtocol{
    // TODO: Implement View Output Methods
    func reloadData() {
        containerView.isHidden = false
        
        buildInfoSection()
        buildRequirementSection()
        buildInformationSection()
        buildNoticeContent()
        if let state = presenter?.isIneligible, state {
            confirmButton.isHidden = true
            ineligibleView.isHidden = false
        } else {
            confirmButton.isHidden = false
            ineligibleView.isHidden = true
        }
    }
    
    private func buildInfoSection() {
        guard let data = presenter?.tradingDetail else { return }
        
        avatarView.setImage(data.avatar)
        nameLabel.text = data.name
        prizeTotalLabel.text = data.prizeTotal
        eventView.setTitle(presenter?.trading?.titleTrading, for: .normal)
 
        if let content = data.description, content.count > 0 {
            webViewHtml.isHidden = false
            let colorLink = isDarkMode ? "4231C8" : "6F6FF7"
            //            let colorLink = isDarkMode ? "8AFF66" : "FF3E3B"\
            webViewHtml.loadHTMLString(content: data.description ?? "",
                                       family: UIFont.FontStyles.regular.name,
                                       size: 14,
                                       color: colorLink)
        } else {
            webViewHtml.isHidden = true
            heightConstraintHtmlView.constant = 0
        }
        
        guard let eventType = presenter?.trading?.stakeEventType, eventType == .RUNNING else {
            eventView.backgroundColor = presenter?.trading?.stakeEventType?.colors.first
            return
        }
        eventView.applyGradient(colours: eventType.colors)
    }
    
    private func buildRequirementSection() {
        guard let data = presenter?.tradingDetail else { return }
        requirementStackView.removeFullyAllArrangedSubviews()
        requirementLabel.text = "tradecompetition_main_requirement_title".Localizable()
        // Create Prob Stake view
        buildStakeSection(tradingDetail: data)
        buildKycSection(tradingDetail: data)
        
        guard data.config.isShowKyc || data.config.isShowStake else {
            requirementSpacing.isHidden = true
            requirementContainerView.isHidden = true
            return
        }
        requirementSpacing.isHidden = false
        requirementContainerView.isHidden = false
    }
    
    private func buildStakeSection(tradingDetail: TradingDetail) {
        guard let minStakeCount = tradingDetail.config.minStakeCount, minStakeCount.asInt > 0 else { return }
        let myStatusStake = presenter?.myStatusStake?.doubleValue() ?? 0.0
        let fractionDigitsValue = myStatusStake.fractionDigits(min: 6, max: 8, roundingMode: .ceiling)

        // build UI stake section
        let probStakeTitle = "tradecompetition_main_requirement_probstake_title".Localizable()
        let probStakeValue = String(format: "tradecompetition_main_requirement_probstake_value".Localizable(),
                                    minStakeCount)
        let probStakeView = RequirementView(value: probStakeValue, title: probStakeTitle)
        requirementStackView.addArrangedSubview(probStakeView)
        // build UI My status, Eligibility show display when isAuthorization
        guard AppConstant.isAuthorization else { return }
        // My status
        let myStatusTitle = "tradecompetition_main_requirement_probstake_mystatus_title".Localizable()
        let myStatusValue = String(format: "tradecompetition_main_requirement_probstake_mystatus_value".Localizable(),
                                   fractionDigitsValue).Localizable()
        let myStatusView = RequirementView(value: myStatusValue, title: myStatusTitle)
        requirementStackView.addArrangedSubview(myStatusView)
        // Eligibility
        let eligibilityTitle = "tradecompetition_main_requirement_probstake_eligibility_title".Localizable()
        let eligibilityValue = "tradecompetition_main_requirement_probstake_eligibility_gostake".Localizable()
        let isEligibility = minStakeCount.asDouble() <= myStatusStake
        let eligibilityView = RequirementView(eligibilityValue: eligibilityValue, title: eligibilityTitle, isEligibility: isEligibility)
        eligibilityView.delegate = self
        requirementStackView.addArrangedSubview(eligibilityView)
    }

    private func buildKycSection(tradingDetail: TradingDetail) {
        guard let kycLevel = tradingDetail.config.kycLevel, kycLevel.asInt > 0 else { return }
        let myStatusKyc = presenter?.myStatusKyc?.string ?? "1"
        requirementStackView.addArrangedSubview(buildSpacingView())
        // build UI stake section
        let kycTitle = "tradecompetition_main_requirement_kyc_title".Localizable()
        let kycValue = String(format: "tradecompetition_main_requirement_kyc_value".Localizable(), kycLevel)
        let kycView = RequirementView(value: kycValue, title: kycTitle)
        requirementStackView.addArrangedSubview(kycView)
        // build UI My status, Eligibility show display when isAuthorization
        guard AppConstant.isAuthorization else { return }
        // My status
        let myStatusTitle = "tradecompetition_main_requirement_kyc_mystatus_title".Localizable()
        let myStatusValue = String(format: "tradecompetition_main_requirement_kyc_mystatus_value".Localizable(),
                                   myStatusKyc)
        let myStatusView = RequirementView(value: myStatusValue, title: myStatusTitle)
        requirementStackView.addArrangedSubview(myStatusView)
        // Eligibility
        let eligibilityTitle = "tradecompetition_main_requirement_kyc_eligibility_title".Localizable()
        let eligibilityValue = "tradecompetition_main_requirement_kyc_eligibility_verification".Localizable()
        let isEligibility = kycLevel.asDouble() == myStatusKyc.asDouble()
        let eligibilityView = RequirementView(eligibilityValue: eligibilityValue, title: eligibilityTitle, isEligibility: isEligibility)
        eligibilityView.delegate = self
        requirementStackView.addArrangedSubview(eligibilityView)
    }
    
    private func buildInformationSection() {
        guard let data = presenter?.tradingDetail else { return }
        informationStackView.removeFullyAllArrangedSubviews()
        informationLabel.text = "tradecompetition_main_info_title".Localizable()
        
        if AppConstant.isAuthorization {
            let myRank = RequirementView(value: "--", title: "tradecompetition_main_info_rank".Localizable())
            informationStackView.addArrangedSubview(myRank)
        } else {
            let myRank = RequirementView(valueUnderline: "tradecompetition_main_info_rank_loginrequired".Localizable(),
                                         title: "tradecompetition_main_info_rank".Localizable())
            myRank.valueLabel.isUserInteractionEnabled = true
            myRank.valueLabel.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                          action: #selector(navigateToLogin(gesture:))))
            informationStackView.addArrangedSubview(myRank)
        }
        if let startDate = data.startDate?.stringFromDateWithSemantic() {
            let startView = RequirementView(value: startDate,
                                            title: "tradecompetition_main_info_start".Localizable())
            informationStackView.addArrangedSubview(startView)
        }
        if let endDate = data.endDate?.stringFromDateWithSemantic() {
            let endView = RequirementView(value: endDate,
                                          title: "tradecompetition_main_info_end".Localizable())
            informationStackView.addArrangedSubview(endView)
        }
        // setup UI boost section
        if let boost = data.uiDescription.data.boost {
            buildBoostView(boost: boost)
        }
    }
    
    private func buildBoostView(boost: TradingBoost) {
        boosterView.isHidden = false
        setStateBoostView(isActive: boost.active)
        prizesLabel.text = "tradecompetition_prize_title_boost".Localizable()
        // build booster view
        let boosterTitle = "tradecompetition_main_info_booster".Localizable()
        let boosterAchieved = "tradecompetition_main_info_booster_achieved".Localizable()
        let boosterNotAchieved = "tradecompetition_main_info_booster_notachieved".Localizable()
        let stateBoost = boost.active ? boosterAchieved : boosterNotAchieved
        let boostView = RequirementView(value: stateBoost, title: boosterTitle)
        boostView.displayBoosterView(isSelected: !boost.active)
        informationStackView.addArrangedSubview(boostView)
        
        // build booster goal view
        let boosterGoalTitle = "tradecompetition_main_info_boostergoal".Localizable()
        let targetPriceTitle = "tradecompetition_main_info_boostergoal_targetprice".Localizable()
        let targetvolumeTitle = "tradecompetition_main_info_boostergoal_targetvolume".Localizable()

        if let targetVolume = boost.targetVolume, let targetCurrency = boost.targetCurrency {
            let boostGoalView = RequirementView(value: "\(targetvolumeTitle) \(targetVolume) \(targetCurrency)",
                                                title: boosterGoalTitle)
            informationStackView.addArrangedSubview(boostGoalView)
        }
        if let targetAmount = boost.targetAmount, let targetCurrency = boost.targetCurrency {
            let boostGoalView = RequirementView(value: "\(targetPriceTitle) \(targetAmount) \(targetCurrency)",
                                                title: boosterGoalTitle)
            informationStackView.addArrangedSubview(boostGoalView)
        }
    }
    
    private func buildNoticeContent() {
        guard let data = presenter?.tradingDetail else { return }
        var contents: [BulletedListView] = []
        
        if data.uiDescription.data.notice {
            contents.append(BulletedListView(content: "tradecompetition_main_notice_notice1".Localizable()))
        } else {
            data.notice.forEach { contents.append(BulletedListView(html: $0)) }
        }
        if let kycLevel = data.config.kycLevel, kycLevel.asInt >= 2 {
            let text = String(format: "tradecompetition_main_notice_notice7".Localizable(), kycLevel)
            contents.append(BulletedListView(content: text))
        }
        contents.append(BulletedListView(content: "tradecompetition_main_notice_notice8".Localizable()))
        if let rankingUseQuote = data.config.rankingUseQuote, let rankingCurrency = data.config.rankingCurrency, rankingUseQuote {
            let string = String(format: "tradecompetition_main_notice_notice11".Localizable(), rankingCurrency)
            
            let title = NSMutableAttributedString()
            let part1 = NSAttributedString(string: string,
                                           attributes: [.foregroundColor: UIColor.color_282828_fafafa,
                                                        .font: UIFont(name: "SFPro-Medium", size: 14)!])
            let part2 = NSAttributedString(string: " " + "tradecompetition_main_starttrading_buttomsheet_warning_seedetail".Localizable(),
                                           attributes: [.foregroundColor: UIColor.color_4231c8_6f6ff7,
                                                        .font: UIFont(name: "SFPro-Medium", size: 14)!,
                                                        .underlineStyle: NSUnderlineStyle.single.rawValue])
            title.append(part1)
            title.append(part2)
            
            let seeDetailsBulletedListView = BulletedListView(attributedText: title)
            seeDetailsBulletedListView.isUserInteractionEnabled = true
            seeDetailsBulletedListView.contentLabel.isUserInteractionEnabled = true
            seeDetailsBulletedListView.contentLabel.lineBreakMode = .byWordWrapping
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(tappedOnLabel))
            tap.numberOfTapsRequired = 1
            seeDetailsBulletedListView.addGestureRecognizer(tap)
            self.seeDetailsBulletedListView = seeDetailsBulletedListView
            
            contents.append(seeDetailsBulletedListView)
            
        // See Details = "<a href=\"https://support.probit.com/hc/${user location}/articles/360039482652\"target=\"_blank\">See Details</a>"
        // ${user location} = "en-us", "ko-kr"...
        } else {
            contents.append(BulletedListView(content: "tradecompetition_main_notice_notice12".Localizable()))
        }
        contents.append(BulletedListView(content: "tradecompetition_main_notice_notice14".Localizable()))
        contents.append(BulletedListView(content: "tradecompetition_main_notice_notice15".Localizable()))
        noticeStackView.removeFullyAllArrangedSubviews()
        contents.forEach { item in
            noticeStackView.addArrangedSubview(item)
        }
    }
    
    @objc private func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
        guard let label = seeDetailsBulletedListView?.contentLabel,
              let text = label.text else { return }
        let seeDetailsRange = (text as NSString).range(of: "tradecompetition_main_starttrading_buttomsheet_warning_seedetail".Localizable())
        
        let urlString = String(format: AppConstant.Link.seeDetailsCompetition, AppConstant.localeId.lowercased())
        if gesture.didTapAttributedTextInLabel(label: label, inRange: seeDetailsRange),
           let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func setStateBoostView(isActive: Bool) {
        if isActive {
            boosterView.activeView()
        } else {
            boosterView.unActiveView()
        }
    }
    
    private func buildSpacingView() -> UIView {
        let spaceView = UIView()
        let containerView = UIView()
        containerView.addSubview(spaceView)
        containerView.backgroundColor = .clear
        spaceView.backgroundColor = UIColor.color_e6e6e6_424242
        spaceView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: 12),
            spaceView.heightAnchor.constraint(equalToConstant: 1),
            spaceView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 0),
            spaceView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
            spaceView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0)
        ])
        return containerView
    }
    
    @objc
    private func navigateToLogin(gesture: UITapGestureRecognizer) {
        presenter?.navigateToLogin()
    }
}

extension TradingCompetitionDetailViewController: RequirementViewDelegate {
    func goToStake() {
        StakeRouter().showScreen()
    }
    
    func goToKyc() {
        presenter?.goToKyc()
    }
}
extension TradingCompetitionDetailViewController: WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if navigationAction.navigationType == .linkActivated, let url = navigationAction.request.url {
            decisionHandler(.cancel)
            showPopupHelper("dialog_notice".Localizable(),
                            message: "dialog_navigateaway_content".Localizable(),
                            acceptTitle: "dialog_go".Localizable(),
                            cancleTitle: "dialog_cancel".Localizable(),
                            acceptAction: {
                UIApplication.shared.open(url)
            }, cancelAction: nil)
            return
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.body.scrollHeight") { (height, error) in
            if let height = height as? CGFloat {
                self.heightConstraintHtmlView.constant = height
            }
        }
    }
}
