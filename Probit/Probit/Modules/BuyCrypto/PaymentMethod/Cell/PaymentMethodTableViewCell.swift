//
//  PaymentMethodTableViewCell.swift
//  Probit
//
//  Created by Thân Văn Thanh on 25/08/2022.
//

import UIKit

class PaymentMethodTableViewCell: BaseTableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var radioImage: UIImageView!
    @IBOutlet weak var paymentTypeImage: UIImageView!
    @IBOutlet weak var paymentTypeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var flashSaleView: UIView!
    @IBOutlet weak var paymentTypeStack: UIStackView!
    var param: PamentChanelParameters?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }
    
    override func setupCell(object: Any) {
        guard let model = object as? ServiceProvider else { return }
        let image = model.isSelected ? "ico_radio_check" : "ico_radio_uncheck"
        radioImage.image = UIImage(named: image)?.withRenderingMode(.alwaysTemplate)
        radioImage.tintColor = .color_4231c8_6f6ff7
        paymentTypeLabel.text = model.name
        amountLabel.text = model.amount
        setImage(name: model.name.lowercased(), imageView: paymentTypeImage, isPayment: true)
        updateMainView(object: model)
        flashSaleView.isHidden = model.promotion == nil
        paymentTypeStack.removeFullyAllArrangedSubviews()
        setupStackVertical(model: model)
        setupAvaiable(model: model)
    }
    
    func updateMainView(object: ServiceProvider) {
        let selectedColor = self.isDarkMode ? UIColor.color_4231c8_6f6ff7.withAlphaComponent(0.1) : UIColor(hexString: "#F4F3FF")
        let background = object.isSelected ? selectedColor : UIColor.clear
        mainView.backgroundColor = background

        let borderColor = object.isSelected ? UIColor.color_4231c8_6f6ff7 : UIColor.color_e6e6e6_424242
        mainView.layer.borderColor = borderColor.cgColor
    }
    
    func setImage(name: String, imageView: UIImageView, isPayment: Bool = false) {
        if !isPayment {
            LoadImageUrl.shared.cryptoPaymentMethodImage(with: name,
                                                         in: imageView)
        } else {
            LoadImageUrl.shared.cryptoProviderImage(with: name,
                                                    in: imageView)
        }
    }
    
    private func setupStackVertical(model: ServiceProvider) {
        let newData = model.paymentType.chunked(into: 6)
        
        newData.forEach { element in
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fill
            stackView.spacing = 4
            stackView.backgroundColor = .clear
            paymentTypeStack.addArrangedSubview(stackView)
            
            element.forEach { name in
                self.setupStackHorizontal(stackView: stackView, name: name)
            }
            let spacingView = UIView()
            spacingView.backgroundColor = .clear
            stackView.addArrangedSubview(spacingView)
        }
    }
    
    private func setupStackHorizontal(stackView: UIStackView, name: String) {
        let view = UIView()
        let imageView = UIImageView()
        
        setImage(name: name, imageView: imageView, isPayment: false)
        stackView.alpha = 1
        stackView.addArrangedSubview(view)
        view.addSubview(imageView)
        
        view.backgroundColor = UIColor.white
        view.cornerRadius = 2
        view.borderWidth = 1
        view.borderColor = UIColor.init(hex: 0xE6E6E6)
        [view, imageView].forEach({ $0.translatesAutoresizingMaskIntoConstraints = false })
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalTo: stackView.widthAnchor,
                                        multiplier: 0.2, constant: -20),
            view.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.64),
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 4),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5)
        ])
    }

    func setupAvaiable(model: ServiceProvider) {
        let avaiable = model.available
        paymentTypeStack.isHidden = !avaiable
        mainView.alpha = avaiable ? 1:0.5
        isUserInteractionEnabled = avaiable
        amountLabel.textColor = avaiable ? UIColor.color_4231c8_6f6ff7 : UIColor(hexString: "#F25D4E")

        if avaiable {
            amountLabel.text = model.amount
        } else {
            let notavailableString = "buycrypto_notavailablemsg_notavailable".Localizable()
            if let param = self.param, model.range.count == 2 {
                let minRanger = model.range.first?.currencyFormatting() ?? "0"
                let maxRanger = model.range.last?.currencyFormatting() ?? "0"
                let notavailableFromString = "buycrypto_notavailablemsg_availablefrom".Localizable().format(minRanger, maxRanger, param.fiat)
                amountLabel.text = notavailableFromString
            } else {
                amountLabel.text = notavailableString
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
