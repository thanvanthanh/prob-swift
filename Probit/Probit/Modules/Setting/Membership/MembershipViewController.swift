//
//  MembershipViewController.swift
//  Probit
//
//  Created by Thân Văn Thanh on 30/08/2022.
//  
//

import UIKit

class MembershipViewController: BaseViewController {
        
    @IBOutlet weak var membershipLabel: UILabel!
    @IBOutlet weak var tradingFeeTitle: UILabel!
    @IBOutlet weak var percentTradingFee: UILabel!
    
    @IBOutlet weak var tradingFeeWithProbTitle: UILabel!
    @IBOutlet weak var percentTradingFeeWithProb: UILabel!
    
    @IBOutlet var payingWithProbTitle: [UILabel]!
    
    @IBOutlet weak var feeDiscountTitle: UILabel!
    @IBOutlet weak var percentFeeDiscount: UILabel!
    @IBOutlet weak var referBonusTitle: UILabel!
    @IBOutlet weak var percentReferBonus: UILabel!
    
    @IBOutlet weak var membershipTradingfeeButton: UIButton!
    
    @IBOutlet weak var probStatusTitle: UILabel!
    @IBOutlet weak var toLevelLabel: UILabel!
    
    @IBOutlet weak var membershipCurrent: UILabel!
    @IBOutlet weak var membershipNextLevel: UILabel!
    
    @IBOutlet weak var probCountLabel: UILabel!
    @IBOutlet weak var countProbToLevel: UILabel!
    
    @IBOutlet weak var stakedAmountLabel: UILabel!
    @IBOutlet weak var countStakedAmount: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var availableBalanceLabel: UILabel!
    @IBOutlet weak var countAvailableBalance: UILabel!
    
    @IBOutlet weak var stakeProbButton: StyleButton!
    
    // MARK: - Properties
    var presenter: ViewToPresenterMembershipProtocol?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.getData()
    }
    
    override func setupUI() {
        super.setupUI()
        setupNavigationBar(title: "activity_membership_titlebar".Localizable(),
                           titleLeftItem: "navigationbar_settings".Localizable())
    }
    
    override func setupRightToLeft(_ isRTL: Bool) {
        super.setupRightToLeft(isRTL)
        membershipNextLevel.textAlignment = isRTL ? .left : .right
        countProbToLevel.textAlignment = isRTL ? .left : .right
        countStakedAmount.textAlignment = isRTL ? .left : .right
        countAvailableBalance.textAlignment = isRTL ? .left : .right
    }

    override func localizedString() {
        [tradingFeeTitle,
         tradingFeeWithProbTitle].forEach { $0?.text = "customview_membershipbenefits_tradingfee_title".Localizable()}
        feeDiscountTitle.text = "customview_membershipbenefits_feediscount_title".Localizable()
        payingWithProbTitle.forEach { $0.text = "customview_membershipbenefits_pay_in_prob".Localizable() }
        referBonusTitle.text = "customview_membershipbenefits_referralbonus_title".Localizable()
        membershipTradingfeeButton.setTitle("activity_membership_membershipandtradingfee".Localizable(),
                                            for: .normal)
        membershipTradingfeeButton.underline()
        probStatusTitle.text = "activity_membership_probstatus_title".Localizable()
        stakedAmountLabel.text = "activity_stakedetails_stakedamount".Localizable()
        availableBalanceLabel.text = "fragment_stakeamount_availablebalance_title".Localizable()
        stakeProbButton.setTitle("activity_membership_stakeprob".Localizable(), for: .normal)
    }
    
    private func setupUIWhenComplete() {
        guard let model = presenter?.membershipData?.data,
              let feesDiscount = presenter?.feesDiscount,
              let progressBarRate = presenter?.progressBarRate,
              let myStakeAmount = presenter?.myStakeAmount,
              let countProbToLevels = presenter?.countProbToLevel else { return }
        progressBar.progress = progressBarRate
        percentTradingFee.text = model.tradeFeeRate.toPercentage
        percentTradingFeeWithProb.text = model.tradeFeeRateByProb.toPercentage
        percentReferBonus.text = model.referralBonusAmount.toPercentage
        percentFeeDiscount.text = feesDiscount
        [probCountLabel, countStakedAmount].forEach { $0?.text = myStakeAmount }
        countProbToLevel.text = countProbToLevels
        membershipCurrent.text = model.membershipType?.title
        membershipNextLevel.text = model.membershipNextLevel?.title
        setupToLevelText(model: model)
        setupMemberShipTitle(model: model)
        let userBalance = presenter?.userBalanceData
        countAvailableBalance.text = AppConstant.isLanguageRightToLeft ? "PROB \(userBalance?.replaceCurrency() ?? "0")" : "\(userBalance?.replaceCurrency() ?? "0") PROB"
    }
    
    // MARK: - Actions
    
    @IBAction func membershipTradingFeeAction(_ sender: Any) {
        presenter?.navigateToTradingFeeWebsite(viewcontroller: self)
    }
    
    @IBAction func stakeProbAction(_ sender: Any) {
        guard let stakeInteracter = presenter?.stakeInteracter else { return }
        StakingAmountRouter(stakingType: .STAKE, interactorDetail: stakeInteracter).showScreen()
    }
    
}

extension MembershipViewController: PresenterToViewMembershipProtocol{
    // TODO: Implement View Output Methods
    func callingApiComplete() {
        setupUIWhenComplete()
        hideLoading()
    }
    
    func loadApiError() {
        hideLoading()
        //
    }
}

// MARK: - Attributed
extension MembershipViewController {
    // membership
    func setupMemberShipTitle(model: MembershipDetailModel) {
        let text = String.init(format: "activity_membership_mymembershiplabel".Localizable(),
                               "\(model.membershipType?.title ?? "")")
        let currentLevel = model.membershipType?.title ?? ""
        
        let attributedText = NSMutableAttributedString.getAttributedString(fromString: text)
        attributedText.apply(color: UIColor.color_282828_fafafa, subString: text)
        attributedText.apply(font: .medium(size: 16), subString: text)
        attributedText.apply(color: UIColor.color_4231c8_6f6ff7, subString: currentLevel)
        attributedText.apply(font: .medium(size: 16), subString: currentLevel)
        membershipLabel.attributedText = attributedText
    }
    
    // To Level
    private func setupToLevelText(model: MembershipDetailModel) {
        let maxLevel = model.membershipType == MembershipDetailModel.MembershipType.allCases.last
        [countProbToLevel, membershipNextLevel].forEach {$0?.isHidden = maxLevel}
        let countNextLevel = AppConstant.isLanguageRightToLeft ? "PROB \(model.nextLevel.replaceCurrency())" : "\(model.nextLevel.replaceCurrency()) PROB"
        var toLevel = String.init(format: "membershiplevel_tolevel".Localizable(),
                                  countNextLevel,
                                  model.membershipNextLevel?.title ?? "")
        toLevel.append("!")
        let attributedText = NSMutableAttributedString.getAttributedString(fromString: toLevel)
        attributedText.apply(color: UIColor.Basic.grayText6, subString: toLevel)
        attributedText.apply(font: .primary(size: 14), subString: toLevel)
        attributedText.apply(color: UIColor.Basic.blue, subString: countNextLevel)
        attributedText.apply(color: UIColor.Basic.blue, subString: model.membershipNextLevel?.title ?? "")
        attributedText.apply(font: .medium(size: 14), subString: countNextLevel)
        attributedText.apply(font: .medium(size: 14), subString: model.membershipNextLevel?.title ?? "")
        attributedText.underLine(subString: countNextLevel)
        attributedText.underLine(subString: model.membershipNextLevel?.title ?? "")
        if maxLevel {
            toLevelLabel.text = "membershiplevel_highest".Localizable()
        } else {
            toLevelLabel.attributedText = attributedText
        }
        
    }
}
