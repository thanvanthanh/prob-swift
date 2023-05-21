//
//  StakeTableViewCell.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 22/09/2565 BE.
//

import UIKit

struct StakeProgressArg {
    let hiddenDay: Bool
    let rule: Rule
}

class StakeTableViewCell: BaseTableViewCell {

    @IBOutlet weak var heightCollectionView: NSLayoutConstraint!
    @IBOutlet weak var statusGradiantView: UILabel!
    @IBOutlet weak var stakeLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var imageStake: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    let itemSize = CGSize(width: 80, height: 52)

    @IBOutlet weak var progressContent: UIView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    private var collectionViewDelegate: BaseCollectionViewDataSource<StakeCollectionViewCell>?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        statusView.removeGradientView()
        statusView.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func setupCell(object: Any, indexPath: IndexPath? = nil) {
        guard let data = object as? (StakeEventModel, StakeCurrency?) else { return }
        let model = data.0
        statusLabel.text = model.stakeEventType.title
        statusView.layoutIfNeeded()
        if model.stakeEventType.colors.count == 1 {
            statusView.backgroundColor = model.stakeEventType.colors.first
        } else {
            statusView.applyGradient(colours: model.stakeEventType.colors, locations: [0.0, 0.5, 1.0])
        }
        if let url = URL(string: model.uiDescription?.logoImage ?? "") {
            imageStake.sd_setImage(with: url, placeholderImage: UIImage(named: "ico_currency_default"))
        }
        stakeLabel.text = model.uiDescription?.locales?.enUs?.eventName
        setupCollectionView(event: model)
        let startingAmount = model.uiDescription?.startingAmount?.asDouble() ?? 0.0
        if let progressOverride = model.uiDescription?.progressOverride?.asDouble(),
           let grapFrom = model.uiDescription?.showGraphFrom?.asDouble() {
            let isShowProgress = progressOverride >= grapFrom
            progressContent.isHidden = !isShowProgress
            let text = Int(progressOverride*100)
            progressBar.progress = Float(progressOverride)
            progressLabel.text = "\("stakeevent_stake_progress".Localizable()) \(text)%"

        } else if let currency = data.1,
           let totalAmount = currency.totalAmount?.asDouble(),
           let capAmount = currency.capAmount?.asDouble(),
           let grapFrom = model.uiDescription?.showGraphFrom?.asDouble() {
            let progressValue = (totalAmount - startingAmount)/(capAmount - startingAmount)
            let isShowProgress = progressValue >= grapFrom
            progressContent.isHidden = !isShowProgress
            progressBar.progress = Float(progressValue)
            let text = Int(progressValue*100)
            progressLabel.text = "\("stakeevent_stake_progress".Localizable()) \(text)%"
        } else {
            progressContent.isHidden = true
        }
    }
    
    func setupCurency(currency: StakeCurrency?) {
    
        
    }
    
    private func setupUI() {
        [stakeLabel, progressLabel].forEach {
            $0.textAlignment = AppConstant.isLanguageRightToLeft ? .right : .left
        }
        collectionView.semanticContentAttribute = AppConstant.isLanguageRightToLeft ? .forceRightToLeft : .forceLeftToRight
    }
    
    private func setupCollectionView(event: StakeEventModel) {
        collectionViewDelegate = BaseCollectionViewDataSource(hasPull: true,
                                                              hasLoadMore: false,
                                                              itemSize: itemSize,
                                                              collectionView: collectionView)
        let rules = event.rewardDesc?.rules ?? []
        heightCollectionView.constant = rules.count > 3 ? 116.0 : 58.0
        let layout = LeftAlignedFlowLayout()
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        collectionView.collectionViewLayout = layout
        collectionViewDelegate?.setupCell = setupCollectionCell(indexPath:dataItem:cell:)
        collectionViewDelegate?.dataArray = rules.sorted(by: {
            $0.cond?.period ?? 0 > $1.cond?.period ?? 0
        }).map({ StakeProgressArg(hiddenDay: event.hiddenDay, rule: $0)})
    }
    
    private func setupCollectionCell(indexPath: IndexPath,
                                     dataItem: Any,
                                     cell: UICollectionViewCell) {
        if let cell = cell as? StakeCollectionViewCell {
            cell.setupCell(object: dataItem)
        }
    }
    
}

