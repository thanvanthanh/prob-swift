//
//  StakingAmountTermViewController.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 03/10/2565 BE.
//  
//

import UIKit

class StakingAmountTermViewController: BaseViewController {
    
    @IBOutlet weak var cautionsTitle: UILabel!
    @IBOutlet weak var cautionsLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var iconCautions: UIImageView!
    @IBOutlet weak var stackAgree: UIStackView!
    @IBOutlet weak var checkIconBotton: UIImageView!
    @IBOutlet weak var lineTopView: UIView!
    @IBOutlet weak var checkBoxLabel: UILabel!
    @IBOutlet weak var stakeButton: StyleButton!
    @IBOutlet weak var cautionStackView: UIStackView!
    
    var detailLabel: UILabel?
    var currencyId: String?
    var isAgree: Bool = false {
        didSet {
            checkIconBotton.image = UIImage(named: isAgree ? "ico_selected" : "ico_not_selected")
            stakeButton.setEnable(isEnable: isAgree)
        }
    }
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAction()
        setupNavigation()
    }
    
    // MARK: - Properties
    var presenter: ViewToPresenterStakingAmountTermProtocol?
    
    func setupAction() {
        let tapAgree = UITapGestureRecognizer(target: self, action: #selector(doTapAgree))
        stackAgree.isUserInteractionEnabled = true
        stackAgree.addGestureRecognizer(tapAgree)
    }
    
    override func setupUI() {
        super.setupUI()
        stakeButton.style = .style_1
        checkIconBotton.image = UIImage(named: isAgree ? "ico_selected" : "ico_not_selected")
        stakeButton.setEnable(isEnable: isAgree)
        lineTopView.backgroundColor = UIColor.color_4231c8_6f6ff7.withAlphaComponent(0.2)
    }
    
    override func localizedString() {
        amountLabel.text = "viewholder_history_orderhistory_amount".Localizable()
        cautionsLabel.text = "common_cautions".Localizable()
        cautionsTitle.text = "common_cautions".Localizable()
        checkBoxLabel.text = "fragment_deposit_krwagreement_checkbox_label".Localizable()
        cautionsLabel.text = "fragment_deposit_krwagreement_title".Localizable()
        
        cautionStackView.removeFullyAllArrangedSubviews()
        var cautions: [CautionModel] = []
        
        if presenter?.router?.stakeTermType == .STAKE {
            cautions.append(CautionModel(content: "fragment_stakecautionv2_notice_1".Localizable(),
                                         isAttributedString: false))
            cautions.append(CautionModel(content: "fragment_stakecautionv2_notice_2".Localizable(),
                                         isAttributedString: false))
        } else {
            let details = "dialog_details".Localizable() + "."
            let attributedString = "fragment_stakecautionv2_notice_prob_2".Localizable() + " \(details)"
            
            cautions.append(CautionModel(content: attributedString, isAttributedString: true))
            cautions.append(CautionModel(content: "fragment_stakecautionv2_notice_3".Localizable(),
                                         isAttributedString: false))
        }
        
        cautions.forEach { item in
            let view = BulletedListView(caution: item.content,
                                        font: UIFont.font(style: .regular, size: 14),
                                        color: .color_7b7b7b_b6b6b6)
            if item.isAttributedString {
                let details = "dialog_details".Localizable() + "."
                view.contentLabel.attributedText = item.content.setUnderline(textList: [details],
                                                                             attributes: getNormalStakeLabelAttributes(),
                                                                             underlineAttributes: getDetailStakeLabelAttributes())
                self.detailLabel = view.contentLabel
                view.contentLabel.isUserInteractionEnabled = true
                view.contentLabel.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                              action: #selector(cautionAction(_:))))
            }
            cautionStackView.addArrangedSubview(view)
        }
    }
    
    @objc
    func cautionAction(_ tapGesture: UITapGestureRecognizer) {
        guard let detailLabel = detailLabel else { return }
        let detailString = "dialog_details".Localizable() + "."
        
        guard let attributedText = detailLabel.attributedText,
              let range = attributedText.string.range(of: detailString) else { return }
        let linkRange = NSRange(range, in: attributedText.string)
        let locationInRange = tapGesture.didTapAttributedTextInLabel(label: detailLabel, inRange: linkRange)
        
        if locationInRange {
            MembershipRouter().showScreen()
        }
    }
    
    // MARK: - Actions
    @objc
    func doTapAgree() {
        isAgree = !isAgree
    }
    
    func setupNavigation() {
        let currency = currencyId ?? ""
        let title = self.presenter?.router?.stakeTermType.titleNav(currencyTitle: currency) ?? ""
        stakeButton.setTitle(title, for: .normal)
        setupNavigationBar(title: title,
                           titleLeftItem: "common_previous".Localizable())
    }
    
    @IBAction func doStake(_ sender: Any) {
        guard let stakeTermType = self.presenter?.router?.stakeTermType else { return }
        if stakeTermType == .STAKE {
            presenter?.doStake()
        } else {
            presenter?.doUnStake()
        }
    }
    
    func getNormalStakeLabelAttributes() -> [NSAttributedString.Key: Any] {
        return [
            .font : UIFont.font(style: .regular, size: 14),
            .foregroundColor : UIColor.color_7b7b7b_b6b6b6]
    }
    
    func getDetailStakeLabelAttributes() -> [NSAttributedString.Key: Any] {
        return [
            .font : UIFont.font(style: .regular, size: 14),
            .underlineStyle : 1,
            .foregroundColor : UIColor.color_4231c8_6f6ff7]
    }
}

extension StakingAmountTermViewController: PresenterToViewStakingAmountTermProtocol{
    func showPopupSuccess() {
        guard let stakeTermType = self.presenter?.router?.stakeTermType else { return }
        let title = "activity_lockscreen_complete_label_josaalt".Localizable()
        PopupHelper().showSuccessVC(viewController: self,
                                    title:  String(format: title, (stakeTermType == .STAKE) ?  "activity_stakedetails_stake".Localizable() : "activity_stakedetails_unstake".Localizable()),
                                    image: "img_succes",
                                    onDismiss: { [weak self] in
            guard let self = self else { return }
            let viewControllers = self.getRootTabbarViewController().viewControllers
            viewControllers.enumerated().forEach { (index, vc) in
                if vc is StakeDetailsViewController {
                    self.navigationController?.popToViewController(vc, animated: true)
                }
                if vc is MembershipViewController {
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            }
        })
    }
}
