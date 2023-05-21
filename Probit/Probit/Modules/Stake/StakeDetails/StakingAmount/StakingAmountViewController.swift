//
//  StakingAmountViewController.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 30/09/2565 BE.
//  
//

import UIKit

class StakingAmountViewController: BaseViewController {
    @IBOutlet weak var amountStepLabel: UILabel!
    
    @IBOutlet weak var cautionStepLabel: UILabel!
    @IBOutlet weak var balanceValue: UILabel!
    @IBOutlet weak var balanceTitle: UILabel!
    @IBOutlet weak var lineTopView: UIView!
    @IBOutlet weak var stakeAmountLabel: UILabel!
    @IBOutlet weak var stackAmountContent: UIStackView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var currencyId: UILabel!
    @IBOutlet weak var amountTextField: StyleTextField!
    @IBOutlet weak var fillMaxButton: UIButton!
    @IBOutlet weak var lockUpContentView: UIView!
    @IBOutlet weak var lockUpTitle: UILabel!
    @IBOutlet weak var lockUpPercent: UILabel!
    @IBOutlet weak var lockUpCollectionView: UICollectionView!
    @IBOutlet weak var spacingBottom: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lastUpdateView: UIView!
    @IBOutlet weak var lastUpdateTitle: UILabel!
    @IBOutlet weak var validLabel: UILabel!
    @IBOutlet weak var heightTagView: NSLayoutConstraint!
    @IBOutlet weak var nextButton: StyleButton!
    @IBOutlet weak var lastUpdateValue: UILabel!
    @IBOutlet weak var expectedReward: UILabel!
    @IBOutlet weak var cautionsLabel: UILabel!
    var stakingType: StakingType?
    let layout: UICollectionViewFlowLayout = LeftAlignedFlowLayout()
    var interactorDetail: StakeDetailsInteractorProtocol!
    private var timePeriod: [Rule] = []
    private var timeSelected: Rule?
    private var currency: WalletCurrency?

    var isValid: Bool = false {
        didSet {
            nextButton.setEnable(isEnable: isValid)
            expectedReward.isHidden = !isValid
        }
    }

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupLockUpPeriod()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addObserverKeyBoard()
        setUpLastUpdate()
        scrollView.keyboardDismissMode = .interactive
    }
    
    override func setupRightToLeft(_ isRTL: Bool) {
        super.setupRightToLeft(isRTL)
        [balanceTitle, stakeAmountLabel].forEach { $0?.textAlignment = isRTL ? .right : .left }
        balanceValue.textAlignment = isRTL ? .left : .right
        lockUpCollectionView.semanticContentAttribute = isRTL ? .forceRightToLeft : .forceLeftToRight
    }
    
    func setupLockUpPeriod() {
        let stakeEvent = interactorDetail.stakeEvent
        timePeriod = stakeEvent?.rewardDesc?.rules ?? []
        timeSelected = timePeriod.first
        if let timeSelected = self.timeSelected,
           let annualRate = timeSelected.reward?.annualRate?.asDouble(),
           stakeEvent?.stakeEventType == .RUNNING {
            lockUpPercent.text = "fragment_stakeamount_annualrewardrate_title".Localizable() + "\(annualRate * 100) %"
        }
        lockUpCollectionView.register(cellType: PeriodCollectionViewCell.self)
        lockUpCollectionView.dataSource = self
        lockUpCollectionView.delegate = self
        lockUpCollectionView.isScrollEnabled = false
        configLayout()
        fillMaxButton.addLongPressGhostButton()
    }
    
    func setUpLastUpdate() {
        let dateString = Date().stringFromDateWithSemantic()
        let text = "viewholder_stakedetails_lockend_title".Localizable() + " \(dateString)"
        let attributedText = NSMutableAttributedString.getAttributedString(fromString: text)
        attributedText.apply(color: UIColor.color_b6b6b6_7b7b7b, subString: text)
        attributedText.apply(font: .primary(size: 12), subString: text)
        attributedText.apply(color: UIColor.color_282828_06_e6e6e6, subString: dateString)
        attributedText.apply(font: .medium(size: 12), subString: dateString)
        lastUpdateTitle.attributedText = attributedText
    }
    
    override func localizedString() {
        lockUpTitle.text = "fragment_stakeamount_stakeperiod_title".Localizable()
        validLabel.text = "fragment_withdrawal_amount_withdrawalamount_notenoughbalance_hintlabel".Localizable()
        amountLabel.text = "viewholder_history_orderhistory_amount".Localizable()
        cautionsLabel.text = "caution".Localizable()
        nextButton.setTitle("common_next".Localizable(), for: .normal)
        fillMaxButton.setTitle("100%", for: .normal)
    }
    
    override func setupUI() {
        super.setupUI()
        scrollView.hideKeyboard()
        self.nextButton.setEnable(isEnable: false)
        self.amountTextField.delegate = self
        let currency = interactorDetail.stakeEvent?.currencyId ?? ""
        if let stakingType = self.presenter?.router?.stakingType, stakingType == .STAKE {
            balanceTitle.text = "fragment_stakeamount_availablebalance_title".Localizable()
            stakeAmountLabel.text = "fragment_stakeamount_stakeamount_title".Localizable()
            let available = interactorDetail.walletCurrency?.userBalace?.available.asDouble() ?? 0.0
            balanceValue.text = available.fractionDigits() + " \(currency)"
            lockUpContentView.isHidden = false
            lastUpdateView.isHidden = false
        } else {
            balanceTitle.text = "activity_stakedetails_unstakableamount".Localizable()
            stakeAmountLabel.text = "fragment_unstakeamount_unstakeamount_title".Localizable()
            lockUpContentView.isHidden = true
            lastUpdateView.isHidden = true
            let stakeAmount = interactorDetail.stakeAmount?.stakeAmount?.asDouble() ?? 0.0
            let stakeLockAmount = interactorDetail.stakeAmount?.stakeLockAmount?.asDouble() ?? 0.0
            let unStakingAmountValueDB = stakeAmount - stakeLockAmount
            balanceValue.text = "\(unStakingAmountValueDB.fractionDigits()) \(currency)"
            
        }
        amountTextField.delegateFC = self
        amountTextField.isCustomColor = true
        lineTopView.backgroundColor = UIColor.color_4231c8_6f6ff7.withAlphaComponent(0.2)
        amountTextField.textAlignment = AppConstant.isLanguageRightToLeft ? .left : .right
    }

    
    override func setupDarkMode() {
        super.setupDarkMode()
        setupValid(validString: amountTextField.text ?? "")
        cautionStepLabel.borderColor = UIColor.color_b6b6b6_7b7b7b
    }
    
    func setupValid(validString: String) {
        let valid = validString.isEmpty || isValid
        stackAmountContent.borderColor = valid ? UIColor.color_e6e6e6_646464 : UIColor.Basic.red
        fillMaxButton.borderColor = valid ? UIColor.color_e6e6e6_646464 : UIColor.Basic.red
        validLabel.isHidden = valid
    }
    
    // MARK: - Properties
    var presenter: ViewToPresenterStakingAmountProtocol?
    
    private func configLayout() {
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        lockUpCollectionView.collectionViewLayout = layout
        reloadTagLayout()
    }
    
    @objc func reloadTagLayout() {
        weak var weakSelf = self
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            if let strong = weakSelf {
                strong.lockUpCollectionView.layoutIfNeeded()
                let heightTag = strong.getEstimatedSize(collectionView: strong.lockUpCollectionView).height
                strong.heightTagView.constant = heightTag
            }
        })
    }
    
    func getEstimatedSize(collectionView: UICollectionView) -> CGSize {
        collectionView.layoutIfNeeded()
        collectionView.superview?.layoutIfNeeded()
        var offsetX = 0.0
        var offsetY = 40.0
        for i in 0 ..< timePeriod.count {
            let item = timePeriod[i]
            let string = item.cond?.period?.hourToString
            var width = (string?.getSizeText(font: .font(style: .regular, size: 14)).width ?? 0) + 30
            let isSelected = item.cond?.period == timeSelected?.cond?.period
            if isSelected {
                width += 30
            }
            if (offsetX + width) > collectionView.bounds.width {
                offsetX = 0
                offsetY += 40
            }
            offsetX += width
        }
        return CGSize(width: collectionView.bounds.width, height: offsetY)
    }
    
    // MARK: - Properties
    func setupNavigation() {
        let currency = interactorDetail.stakeEvent?.currencyId ?? ""
        let title = self.presenter?.router?.stakingType.titleNav(currencyTitle: currency) ?? ""
        currencyId.text = currency
        setupNavigationBar(title: title,
                           titleLeftItem: "common_previous".Localizable())
    }
    
    @IBAction func goToTermStaking(_ sender: Any) {
        guard let currencyId = interactorDetail.stakeEvent?.currencyId,
              let period = timeSelected?.cond?.period,
              let amount = amountTextField.text?.replaceComaByDot() else {return}
        
        if let totalAmount = interactorDetail.stakeCurrency?.totalAmount?.asDouble(),
           let capAmount = interactorDetail.stakeCurrency?.capAmount?.asDouble(),
           let stakingType = self.stakingType, stakingType == .STAKE {
            let myTotalAmount = totalAmount + amount.asDouble()
            if myTotalAmount > capAmount {
                self.showFloatsMessage(message: "fragment_stakeamount_errortext_reachedcapamount".Localizable(), type: .error)
                return
            }
        }
        self.presenter?.goToTerm(currencyId:  currencyId,
                                 period: period,
                                 amount: amount)
    }
    
    override func updateLayoutWhenKeyboardChanged(height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.spacingBottom.constant = height > 0 ? height : 10
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func doFillMaxAmount(_ sender: Any) {
        if let stakingType = self.presenter?.router?.stakingType, stakingType == .STAKE {
            let balancy = interactorDetail.walletCurrency?.userBalace
            let available = balancy?.available.asDouble() ?? 0
            self.amountTextField.text = available.forTrailingZero()
            self.validateAmountField(validString: available.asString())
            
        } else {
            let stakeAmount = interactorDetail.stakeAmount?.stakeAmount?.asDouble() ?? 0
            let stakeLockAmount = interactorDetail.stakeAmount?.stakeLockAmount?.asDouble() ?? 0
            let unStakingAmountValueDB = (stakeAmount - stakeLockAmount)
            self.amountTextField.text = unStakingAmountValueDB.forTrailingZero()
            self.validateAmountField(validString: unStakingAmountValueDB.asString())
        }
    }

    func validateAmountField(validString: String) {
        guard let stakeCurrency = interactorDetail.stakeCurrency else {
            return
        }
        let value = validString.replaceComaByDot().asDouble()
        let minAmount = stakeCurrency.minAmount?.asDouble()
        let maxAmount = stakeCurrency.maxAmount?.asDouble()
        let maxValid = maxAmount == nil || maxAmount == 0.0 ? true : value <= maxAmount!
        let minValid = minAmount == nil || minAmount == 0.0 ? true : value >= minAmount!
        if !maxValid {
            validLabel.text = String(format: "fragment_stakeamount_maximum_amount".Localizable(),
                                     maxAmount?.fractionDigits(min: 0, max: 8) ?? "")
        }
        if !minValid {
            validLabel.text = String(format: "fragment_stakeamount_minimum_amount".Localizable(),
                                     minAmount?.fractionDigits() ?? "")
        }
   
        if let stakingType = self.presenter?.router?.stakingType, stakingType == .STAKE {
            if value == 0 {
                validLabel.text = "fragment_stakeamount_not_empty_amount".Localizable()
            }
            let available =  interactorDetail.walletCurrency?.userBalace?.available.asDouble() ?? 0.0
            if !(value <= available) {
                validLabel.text = "fragment_withdrawal_amount_withdrawalamount_notenoughbalance_hintlabel".Localizable()
            }
            self.isValid = maxValid && minValid && value <= available && value != 0
        } else {
            if value == 0 {
                validLabel.text = "fragment_unstake_not_empty_amount".Localizable()
            }
            guard let stakeAmount = interactorDetail.stakeAmount?.stakeAmount?.asDouble(),
                  let stakeLockAmount = interactorDetail.stakeAmount?.stakeLockAmount?.asDouble()
            else { return }
            let unStakingAmountValueDB = stakeAmount - stakeLockAmount
            if !(value <= unStakingAmountValueDB) {
                validLabel.text = "fragment_withdrawal_amount_withdrawalamount_notenoughbalance_hintlabel".Localizable()
            }
            self.isValid = maxValid && minValid && value <= unStakingAmountValueDB && value != 0
        }
        caculator(value: value, rule: timeSelected)
        setupValid(validString: validString)
    }
    
    func caculator(value: Double?, rule: Rule?) {
        setUpLastUpdate()
        guard let value = value,
              let period = rule?.cond?.period,
              let annualRate = rule?.reward?.annualRate?.asDouble(),
              let currency = interactorDetail.stakeEvent?.currencyId,
              interactorDetail.stakeEvent?.stakeEventType == .RUNNING else { return }
        let expectValue = value * annualRate / 365.0 * (Double(period)/24.0)
        let expect = expectValue.fractionDigits(min: 8, max: 8, roundingMode: .down)

        let text = "fragment_stakeamountv2_expectedrewards_title".Localizable() + " \(expect) \(currency) (At the end)"
        let rewardsValue = " \(expect) \(currency) (At the end)"

        let attributedText = NSMutableAttributedString.getAttributedString(fromString: text)
        attributedText.apply(color: UIColor.color_b6b6b6_7b7b7b, subString: text)
        attributedText.apply(font: .primary(size: 12), subString: text)
        attributedText.apply(color: UIColor.color_282828_06_e6e6e6, subString: rewardsValue)
        attributedText.apply(font: .medium(size: 12), subString: rewardsValue)
        expectedReward.attributedText = attributedText
    }
    
    func validateAmountUI(amount: String) {
        self.validateAmountField(validString: amount)
        amountTextField.textColor = currencyId.textColor
    }
}

extension StakingAmountViewController: PresenterToViewStakingAmountProtocol{
    // TODO: Implement View Output Methods
}

extension StakingAmountViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)  else {
            return true
        }
        let strValid = updatedString.replaceComaByDot().split(separator: ".")
        if let last = strValid.last, strValid.count > 1, last.count > 8 {
            return false
        }
        validateAmountUI(amount: updatedString)
        if string == "," {
            textField.text = updatedString.replaceComaByDot()
            return false
        }
        return true
    }
    
}

extension StakingAmountViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timePeriod.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: PeriodCollectionViewCell.self, for: indexPath)!
        let item = timePeriod[indexPath.item]
        let isSelected = item.cond?.period == timeSelected?.cond?.period
        cell.binData(item, isSelected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        timeSelected = timePeriod[indexPath.item]
        if let timeSelected = self.timeSelected,
           let annualRate = timeSelected.reward?.annualRate?.asDouble(),
           interactorDetail.stakeEvent?.stakeEventType == .RUNNING {
            lockUpPercent.text = "fragment_stakeamount_annualrewardrate_title".Localizable() + (AppConstant.isLanguageRightToLeft ? ": %\(annualRate * 100)" : ": \(annualRate * 100) %")
        }
        if let text = amountTextField.text, !text.isEmpty {
            self.validateAmountField(validString: text)
        }
        collectionView.reloadData()
    }
}

extension StakingAmountViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = timePeriod[indexPath.item]
        if let time = item.cond?.period {
            let string = time.hourToString.getSizeText(font: UIFont.font(style: .regular, size: 14))
            let isSelected = item.cond?.period == timeSelected?.cond?.period
            return CGSize(width: string.width + 30 + (isSelected ? 30 : 0),
                   height: 32.0)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension StakingAmountViewController: StyleTextFieldProtocol {
    func focusTextField() {
        stackAmountContent.borderColor = amountTextField.strokeFocusColor
    }
    
    func unFocusTextField() {
        
    }
}
