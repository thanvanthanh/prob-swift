//
//  PopupStartTradingViewController.swift
//  Probit
//
//  Created by Nguyen Quang on 26/09/2022.
//  
//

import UIKit

class PopupStartTradingViewController: BaseViewController {
    
    @IBOutlet weak var backScreen: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var contentLabel: UILabel!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        dismissPopUpTappedView()
        configLayout()
        hideNavigationBar()
        setupBackground()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        hideNavigationBar(isHide: false)
    }
    
    override func localizedString() {
        cancelButton.setTitle("tradecompetition_main_starttrading_buttomsheet_cancel".Localizable(), for: .normal)
        titleLabel.text = "tradecompetition_main_starttrading_buttomsheet_title".Localizable()
        let attributedText = NSMutableAttributedString()
        let content = "\("tradecompetition_main_starttrading_buttomsheet_warning".Localizable()) "
        let seeDetail = "tradecompetition_main_starttrading_buttomsheet_warning_seedetail".Localizable()
        let attrContent = [NSAttributedString.Key.foregroundColor: UIColor.color_4231c8_6f6ff7,
                           NSAttributedString.Key.font: UIFont.font(style: .regular, size: 14)]
        let attrSeeDetail = [NSAttributedString.Key.foregroundColor: UIColor.color_4231c8_6f6ff7,
                             NSAttributedString.Key.font: UIFont.font(style: .bold, size: 14)]
        
        let attributedSeeDetail = NSMutableAttributedString(string: seeDetail, attributes: attrSeeDetail)
        attributedSeeDetail.addAttribute(NSAttributedString.Key.underlineStyle,
                                         value: NSUnderlineStyle.single.rawValue,
                                         range: NSRange(location: 0, length: attributedSeeDetail.length))
        attributedText.append(NSAttributedString(string: content, attributes: attrContent))
        attributedText.append(attributedSeeDetail)
        contentLabel.attributedText = attributedText
        contentLabel.isUserInteractionEnabled = true
        contentLabel.addGestureRecognizer(UITapGestureRecognizer(target:self,
                                                                 action: #selector(handerSeeDetailAction(_:))))
    }
    
    private func configLayout() {
        let marketIds = presenter?.marketIds.compactMap { $0 } ?? []
        let content = marketIds.chunked(into: 3)
        mainStackView.removeFullyAllArrangedSubviews()
        
        content.forEach { element in
            let stackView = UIStackView()
            stackView.spacing = 12
            stackView.axis = .horizontal
            element.forEach { text in
                let view = buildSectionItem(text: text)
                view.addTapGesture(action: {
                    self.presenter?.gotoExchangeDetail(marketId: text)
                })
                stackView.addArrangedSubview(view)
            }
            stackView.spacer()
            mainStackView.addArrangedSubview(stackView)
        }
    }
    
    override func setupDarkMode() {
        super.setupDarkMode()
        setupBackground()
    }
    
    func setupBackground() {
        let alpha = self.isDarkMode ? 0.7 : 0.5
        backScreen.backgroundColor = UIColor.init(hex: 0x282828, alpha: alpha)
    }
    
    @objc private func handerSeeDetailAction(_ tapGesture: UITapGestureRecognizer) {
        let detailString = "tradecompetition_main_starttrading_buttomsheet_warning_seedetail".Localizable()
        guard let attributedText = contentLabel.attributedText,
              let range = attributedText.string.range(of: detailString) else {
            return
        }
        let linkRange = NSRange(range, in: attributedText.string)
        if tapGesture.didTapAttributedTextInLabel(label: contentLabel, inRange: linkRange) {
            guard let url = URL(string: AppConstant.Link.tradingFee) else { return }
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func dismissPopUpTappedView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissPopUp))
        backScreen.addGestureRecognizer(tap)
    }
    
    private func buildSectionItem(text: String) -> UIView {
        let containerView = UIView()
        let titleLabel = UILabel()
        titleLabel.text = text
        titleLabel.font = .primary(size: 14)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.init(hexString: "7B7B7B")
        let widthCell = text.getSizeText(font: .primary(size: 14)).width + 28
        
        containerView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: 32),
            titleLabel.widthAnchor.constraint(equalToConstant: widthCell),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0)
        ])
        containerView.layer.cornerRadius = 16
        containerView.backgroundColor = UIColor.color_f5f5f5_2a2a2a
        return containerView
    }
    
    @objc func dismissPopUp() {
        dismiss(animated: true)
    }
    
    // MARK: - Properties
    var presenter: ViewToPresenterPopupStartTradingProtocol?
    
}

extension PopupStartTradingViewController: PresenterToViewPopupStartTradingProtocol{
    // TODO: Implement View Output Methods
}
