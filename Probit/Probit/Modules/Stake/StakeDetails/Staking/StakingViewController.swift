//
//  StakingViewController.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 23/09/2565 BE.
//  
//

import UIKit

class StakingViewController: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pieChartView: UIView!
    @IBOutlet weak var balanceValueLabel: UILabel!
    @IBOutlet weak var totalBalanceLabel: UILabel!
    @IBOutlet weak var balanceExchangeValue: UILabel!
    @IBOutlet weak var stakedAmountValue: UILabel!
    @IBOutlet weak var stakeAmountLabel: UILabel!
    @IBOutlet weak var lockedUpValue: UILabel!
    @IBOutlet weak var lockedUpLabel: UILabel!
    @IBOutlet weak var unStakingLabel: UILabel!
    @IBOutlet weak var unStakingValue: UILabel!
    @IBOutlet weak var goTradeView: UIView!
    @IBOutlet weak var goTradeLabel: UILabel!
    @IBOutlet weak var exchangeCollectionView: UICollectionView!
    @IBOutlet weak var collectionView_height: NSLayoutConstraint!
    @IBOutlet weak var giftSubTitle: UILabel!
    @IBOutlet weak var giftTitle: UILabel!
    @IBOutlet weak var giftView: UIView!
    @IBOutlet weak var giftProgress: ButtonProgress!
    @IBOutlet weak var lastUpdated: UILabel!
    @IBOutlet weak var stakeHistoryButton: HighlightButon!
    @IBOutlet weak var stakeButton: StyleButton!
    @IBOutlet weak var unStakeButton: StyleButton!
    
    @IBOutlet weak var tooltipContainer: UIStackView!
    @IBOutlet weak var tooltipLabel: UILabel!
    @IBOutlet weak var viewTooltip: UIView!
    private var validMarkets = [Market]()
    // MARK: - Properties
    var presenter: ViewToPresenterStakingProtocol?
    var stakeDetailsInteractorDelegate: StakeDetailsInteractorProtocol?
    private let piechart = Piechart()

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChart()
        lastUpdated.text = String(format: "fragment_walletdetailsv2_coin_lastupdated".Localizable(), Date().stringFromDateWithSemantic())
        applyOutlineButton2Style()
        tooltipContainer.isHidden = true
    }
    
    func applyOutlineButton2Style() {
        stakeHistoryButton.cornerRadius = 2
        stakeHistoryButton.borderWidth = 1
        stakeHistoryButton.bgColor = .clear
        stakeHistoryButton.strokeColor = .color_b6b6b6_7b7b7b
        stakeHistoryButton.textColor = .color_b6b6b6_7b7b7b
        stakeHistoryButton.highlightType = .outlineButton2
        stakeHistoryButton.titleLabel?.font = .font(style: .medium, size: 16)
    }
    
    override func setupRightToLeft(_ isRTL: Bool) {
        super.setupRightToLeft(isRTL)
        [totalBalanceLabel, goTradeLabel].forEach { $0.textAlignment = isRTL ? .right : .left }
        [balanceValueLabel, balanceExchangeValue].forEach { $0?.textAlignment = isRTL ? .left : .right}
        [stakedAmountValue, lockedUpValue, unStakingValue].forEach { $0?.textAlignment = isRTL ? .left : .right}
        exchangeCollectionView.semanticContentAttribute = isRTL ? .forceRightToLeft : .forceLeftToRight
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height: CGFloat = exchangeCollectionView.collectionViewLayout.collectionViewContentSize.height
        collectionView_height.constant = height
        goTradeView.isHidden = height == 0.0
        view.layoutIfNeeded()
    }
    
    override func setupUI() {
        unStakeButton.style = .style_2
        stakeButton.style = .style_1
        unStakeButton.setEnable(isEnable: false)
        stakeButton.setEnable(isEnable: false)
        scrollView.hideKeyboard()
    }
    
    override func setupDarkMode() {
        super.setupDarkMode()
        unStakeButton.borderColor = UIColor.color_b6b6b6_7b7b7b
        stakeHistoryButton.borderColor = UIColor.color_b6b6b6_7b7b7b
    }

    override func localizedString() {
        totalBalanceLabel.text = "viewholder_wallet_total_balance".Localizable()
        stakeAmountLabel.text = "activity_stakedetails_stakedamount".Localizable()
        goTradeLabel.text = "fragment_walletdetailsv2_coin_gototrade_title".Localizable()
        stakeHistoryButton.setTitle("fragment_walletdetailsv2_stake_stakehistory".Localizable(), for: .normal)
        unStakeButton.setTitle("activity_stakedetails_unstake".Localizable(), for: .normal)
        stakeButton.setTitle("activity_stakedetails_stake".Localizable(), for: .normal)
        lockedUpLabel.text = "activity_stakedetails_lockedupamount".Localizable()
        unStakingLabel.text = "activity_stakedetails_unstakableamount".Localizable()
    }
    
    func setupReward() {
        setupTooltip()
        guard let stakeEvent = stakeDetailsInteractorDelegate?.stakeEvent,
        stakeEvent.stakeEventType == .RUNNING else {
            giftView.isHidden = true
            return
        }
        if let supportArticleId = stakeEvent.uiDescription?.supportArticleId {
            giftView.addTapGesture {
                CommonWebViewRouter().showScreen(titleBackScreen: "common_previous".Localizable(),
                                                 urlString: String(format: AppConstant.Link.articleLink, supportArticleId),
                                                 titleNavigation: "Probit")
            }
        }
        
        if let enUs = stakeEvent.uiDescription?.locales?.enUs {
            giftView.isHidden = false
            giftTitle.text = enUs.prizeString
            if let period = enUs.period,
               let startTime = stakeEvent.startTime,
               let endTime = stakeEvent.endTime,
               !period.isEmpty {
                giftSubTitle.isHidden = false
                let startDate = startTime.stringFromDateWithSemantic(gmtFormat: "")
                let endDate = endTime.stringFromDateWithSemantic()
                giftSubTitle.text = AppConstant.isLanguageRightToLeft ? "\(endDate) ~ \(startDate)" : "\(startDate) ~ \(endDate)"
            } else {
                giftSubTitle.isHidden = true
            }
        } else {
            giftView.isHidden = true
        }
        if let progressOverride = stakeEvent.uiDescription?.progressOverride?.asDouble(),
           let grapFrom = stakeEvent.uiDescription?.showGraphFrom?.asDouble() {
            let isShowProgress = progressOverride > grapFrom
            giftProgress.isHidden = !isShowProgress
            let slice = ButtonProgress.Slice(color: UIColor.color_4231c8_6f6ff7,
                                             value: progressOverride * 100)
            giftProgress.setupView(slice: slice,
                                   viewLabelColor: UIColor.color_4231c8_6f6ff7.withAlphaComponent(0.12))

        } else if let currency = stakeDetailsInteractorDelegate?.stakeCurrency,
           let totalAmount = currency.totalAmount?.asDouble(),
           let capAmount = currency.capAmount?.asDouble(),
           let grapFrom = stakeEvent.uiDescription?.showGraphFrom?.asDouble() {
            let startingAmount = stakeEvent.uiDescription?.startingAmount?.asDouble() ?? 0.0
            let progressValue = (totalAmount - startingAmount)/(capAmount - startingAmount)
            if progressValue > grapFrom {
                let slice = ButtonProgress.Slice(color: UIColor.color_4231c8_6f6ff7,
                                                 value: progressValue * 100)
                giftProgress.setupView(slice: slice,
                                       viewLabelColor: UIColor.color_4231c8_6f6ff7.withAlphaComponent(0.12))
                giftProgress.isHidden = false
            } else {
                giftProgress.isHidden = true
            }
        } else {
            giftProgress.isHidden = true
        }
    }
    
    func setupGoTrade() {
        validMarkets = stakeDetailsInteractorDelegate?.walletCurrency?.markets.filter({ market in
            stakeDetailsInteractorDelegate?.currencies?.contains(where: {$0.currency?.id == market.quoteCurrencyID}) ?? true }) ?? [Market]()
        configLayout()
        let nib = UINib(nibName: "ExchangeCell", bundle: .main)
        exchangeCollectionView.register(nib, forCellWithReuseIdentifier: "cell")
        exchangeCollectionView.dataSource = self
        exchangeCollectionView.delegate = self
        self.viewDidLayoutSubviews()
    }
    
    func setupTooltip() {
        tooltipContainer.isHidden = false
        if let membership = stakeDetailsInteractorDelegate?.membership,
           let currencyId = stakeDetailsInteractorDelegate?.stakeEvent?.currencyId,
           currencyId == "PROB" {
            viewTooltip.isHidden = false
            lastUpdated.isHidden = true
            tooltipLabel.text = String(format: "membershiplevel_tolevel".Localizable(),  membership.nextLevel, membership.membershipNextLevel?.title ?? "")
        } else {
            viewTooltip.isHidden = true
            lastUpdated.isHidden = false
        }
    }

    private func configLayout() {
        let layout = LeftAlignedFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 14
        exchangeCollectionView.collectionViewLayout = layout
        exchangeCollectionView.isScrollEnabled = false
    }
    
    func billDataChart() {
        let currency = stakeDetailsInteractorDelegate?.stakeCurrency
        stakeButton.setEnable(isEnable: currency?.stakeable ?? true)
        let enableSv = (currency?.unstakeable ?? true)
        unStakeButton.setEnable(isEnable: enableSv)
        guard let stakeDetailsInteractorDelegate = self.stakeDetailsInteractorDelegate,
              let stakeAmount = stakeDetailsInteractorDelegate.stakeAmount else { return }
        let balancy = stakeDetailsInteractorDelegate.walletCurrency?.userBalace
        let balanceTotalDB = balancy?.total.asDouble() ?? 0
        let stakedAmountDB =  stakeAmount.stakeAmount?.asDouble() ?? 0
        let lockedUpAmountDB = stakeAmount.stakeLockAmount?.asDouble() ?? 0
        let unStakingAmountValueDB = (stakeAmount.stakeAmount?.asDouble() ?? 0.0) - (stakeAmount.stakeLockAmount?.asDouble() ?? 0.0)
        
        stakedAmountValue.text = stakedAmountDB.fractionDigits(min: 8, max: 8, roundingMode: .down)
        lockedUpValue.text = lockedUpAmountDB.fractionDigits(min: 8, max: 8, roundingMode: .down)
        unStakingValue.text = unStakingAmountValueDB.fractionDigits(min: 8, max: 8, roundingMode: .down)
        balanceValueLabel.text = balanceTotalDB.fractionDigits(min: 8, max: 8, roundingMode: .down)
        stakedAmountValue.textColor = stakedAmountDB > 0 ? UIColor.color_282828_fafafa : UIColor.color_b6b6b6_7b7b7b
        lockedUpValue.textColor = lockedUpAmountDB > 0 ? UIColor.color_282828_fafafa : UIColor.color_b6b6b6_7b7b7b
        unStakingValue.textColor = unStakingAmountValueDB > 0 ? UIColor.color_282828_fafafa : UIColor.color_b6b6b6_7b7b7b
        unStakeButton.setEnable(isEnable: enableSv && unStakingAmountValueDB != 0)

        var item1 = Piechart.Slice()
        item1.value = 0
        item1.color = UIColor.color_d9d9d9_7b7b7b
        item1.text = stakedAmountDB.toPercent(total: balanceTotalDB)

        var item2 = Piechart.Slice()
        item2.value = lockedUpAmountDB
        item2.color = UIColor(hexString: "#F25D4E")
        item2.text = lockedUpAmountDB.toPercent(total: balanceTotalDB)
        
        var item3 = Piechart.Slice()
        item3.value = unStakingAmountValueDB
        item3.color = UIColor.color_4231c8_6f6ff7
        item3.text = unStakingAmountValueDB.toPercent(total: balanceTotalDB)
        
        piechart.total = balanceTotalDB
        piechart.settupChartView(slices: [item1, item2, item3])
    }

    func setupChart() {
        pieChartView.addSubview(piechart)
        // Set contraints to full view
        piechart.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            piechart.topAnchor.constraint(equalTo: pieChartView.topAnchor, constant: 16.0),
            piechart.bottomAnchor.constraint(equalTo: pieChartView.bottomAnchor),
            piechart.leadingAnchor.constraint(equalTo: pieChartView.leadingAnchor),
            piechart.trailingAnchor.constraint(equalTo: pieChartView.trailingAnchor)
        ])
    }
    
    func updateViewExchageRate() {
        let usdtRate: Double? = stakeDetailsInteractorDelegate?.walletCurrency?.usdtRate
        if let usdtRate = usdtRate {
            let balanceTotalDB = stakeDetailsInteractorDelegate?.walletCurrency?.userBalace?.total.asDouble()
            let text = ((balanceTotalDB ?? 0)*usdtRate).fractionDigits(min: 2,max: 2)
            balanceExchangeValue.text = isLanguageRightToLeft ? "≈ USDT \(text)" : "≈ \(text) USDT"
        } else {
            balanceExchangeValue.text = "-"
        }
        if stakeDetailsInteractorDelegate?.walletCurrency?.id == "USDT" {
            balanceExchangeValue.text = ""
        }
    }
    
    @IBAction func goStakeHistory(_ sender: Any) {
        presenter?.navigateToStakeHistory()
    }
    
    @IBAction func doUnstake(_ sender: Any) {
        if self.isConnectedToInternet {
            presenter?.navigateToUnStake()
        } else {
            self.showFloatsMessage(message: "network_connection_unstable_warning".Localizable(), type: .error)
        }
    }
    
    @IBAction func doStake(_ sender: Any) {
        if self.isConnectedToInternet {
            presenter?.navigateToStakeAmount()
        } else {
            self.showFloatsMessage(message: "network_connection_unstable_warning".Localizable(), type: .error)
        }
    }
}

extension StakingViewController: PresenterToViewStakingProtocol{
    // TODO: Implement View Output Methods
}

extension StakingViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return validMarkets.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = validMarkets.at(indexPath.row) else { return UICollectionViewCell() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ExchangeCell
        cell.configureCell(item)
        cell.round()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = validMarkets.at(indexPath.row) else { return }
        let exchange = ExchangeTicker()
        exchange.displayName = presenter?.interactor?.displayName
        exchange.mapping(withMarket: item)
        ExchangeDetailRouter().showScreen(exchange: exchange)
    }
}

extension StakingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let item = validMarkets.at(indexPath.row),
              let baseCurrencyID = item.baseCurrencyID, let quoteCurrencyID = item.quoteCurrencyID else { return .zero }
        let text = baseCurrencyID + "/" + quoteCurrencyID
        let string = text.getSizeText(font: UIFont.font(style: .regular, size: 14))
        return CGSize(width: string.width + 28,
                      height: 32.0)
       
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
