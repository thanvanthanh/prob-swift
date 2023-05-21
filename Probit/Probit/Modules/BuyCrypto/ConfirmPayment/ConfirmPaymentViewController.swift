//
//  ConfirmPaymentViewController.swift
//  Probit
//
//  Created by Thân Văn Thanh on 26/08/2022.
//  
//

import UIKit

class ConfirmPaymentViewController: BaseViewController {
    
    @IBOutlet weak var notificationTitleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var confirmTitle: UILabel!
    @IBOutlet weak var paymentDetailStackView: UIStackView!
    @IBOutlet weak var receiveLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var selectImage: UIImageView!
    @IBOutlet weak var confirmSelectLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    // MARK: - Properties
    var presenter: ViewToPresenterConfirmPaymentProtocol?
    private var isSelected: Bool = false
    
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }

    override func setupUI() {
        super.setupUI()
        var leftTitle = "navigationbar_home".Localizable()
        let viewControllers = self.getRootTabbarViewController().viewControllers
        if viewControllers.first(where: { $0.className == WalletViewController.className}) != nil {
            leftTitle = presenter?.paymentParams?.crypto ?? ""
        }
        setupNavigationBar(title: "v2icon_home_buycrypto".Localizable(),
                                titleLeftItem: leftTitle)
        previousButton.borderColor = UIColor.color_4231c8_6f6ff7
        previousButton.setTitleColor(UIColor.color_4231c8_6f6ff7, for: .normal)
    }
    
    override func localizedString() {
        amountLabel.attributedText = amountText()
        
        confirmTitle.text = "buycrypto_confirmpayment_title".Localizable()
        receiveLabel.text = "buycrypto_confirmpayment_receive_title".Localizable()
        warningLabel.text = "\("buycrypto_confirmpayment_warning_header".Localizable()) \("buycrypto_confirmpayment_warning_body".Localizable())"
        
        let disclaimerTitle = String.init(format: "buycrypto_confirmpayment_disclaimer_title".Localizable(),
                                          "\(presenter?.method ?? "")")
        notificationTitleLabel.text = disclaimerTitle
        detailLabel.text = "buycrypto_confirmpayment_disclaimer_content".Localizable()
        selectButton.setTitle("", for: .normal)
        
        confirmSelectLabel.text = "buycrypto_confirmpayment_disclaimer_checkbox_text".Localizable()
        previousButton.setTitle("common_previous".Localizable(), for: .normal)
        confirmButton.setTitle("common_confirm".Localizable(), for: .normal)
    }
    
    override func setupDarkMode() {
        super.setupDarkMode()
        previousButton.layer.borderColor = UIColor.color_b6b6b6_7b7b7b.cgColor
    }
    
    override func tappedLeftBarButton(sender: UIButton) {
        let specificViewcontrollers = [CryptoTransfersViewController.className,
                                       StakeDetailsViewController.className,
                                       HomeViewController.className]
        _ = self.popToSpecialViewControlle(specialViewcontrollers: specificViewcontrollers)
    }
    
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom)
        scrollView.setContentOffset(bottomOffset, animated: true)
    }
   
    @IBAction func selectedConfirmAction(_ sender: Any) {
        isSelected = !isSelected
        selectImage.image = isSelected ? UIImage(named: "ico_radio_tick") : UIImage(named: "ico_radio_untick")
        let backgroundColor = isSelected ? UIColor.color_4231c8_6f6ff7 : UIColor.color_b6b6b6_282828
        let textColor = isSelected ? UIColor.color_fafafa : UIColor.color_fafafa_646464
        confirmButton.setTitleColor(textColor, for: .normal)
        confirmButton.backgroundColor = backgroundColor
    }
    
    @IBAction func previousAction(_ sender: Any) {
        self.pop()
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        isSelected ? presenter?.navigateToCryptoRedirected() : scrollToBottom()
    }
    
}

extension ConfirmPaymentViewController: PresenterToViewConfirmPaymentProtocol{
    // TODO: Implement View Output Methods
    func reloadData() {
        let newData = presenter?.paymentInfo ?? []
        paymentDetailStackView.removeFullyAllArrangedSubviews()
        
        newData.enumerated().forEach { index, payment in
            let view = PaymentDetail()
            view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                view.heightAnchor.constraint(greaterThanOrEqualToConstant: 65)
            ])
            view.configView(data: payment)
            paymentDetailStackView.addArrangedSubview(view)
            if index != newData.count - 1 {
                view.hidenLineView(false)
            }
        }
    }
}
// MARK: - Set Attributed amount
extension ConfirmPaymentViewController {
    private func amountText() -> NSMutableAttributedString {
        let receiveAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.label,
                                                                .font: UIFont.font(style: .medium, size: 20) as Any]

        let cryptoAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(hexString: "#7B7B7B"),
                                                               .font: UIFont.font(style: .medium, size: 20) as Any]
        let clean = presenter?.paymentParams?.cryptoAmount
        let receive = NSMutableAttributedString(string: "\(clean ?? "") ",
                                                attributes: receiveAttributes)
        let crypto = NSMutableAttributedString(string: presenter?.paymentParams?.crypto ?? "",
                                                attributes: cryptoAttributes)
        if AppConstant.isLanguageRightToLeft {
            crypto.append(NSAttributedString(string: " "))
            crypto.append(receive)
            return crypto
        } else {
            receive.append(crypto)
            return receive
        }
    }
}
