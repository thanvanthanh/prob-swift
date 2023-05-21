
import UIKit
import SimpleQRCode

class DepositViewController: BaseViewController {
    
    @IBOutlet weak var blockChainTypeLabel: UILabel!
    
    @IBOutlet weak var depositAdressLabel: UILabel!
    
    @IBOutlet weak var cautionsLabel: UILabel!
    
    @IBOutlet weak var stackContract: UIStackView!
    @IBOutlet weak var showContract: UILabel!
    @IBOutlet weak var stackCautions: UIStackView!
    @IBOutlet weak var imageQRCode: UIImageView!
    @IBOutlet weak var collectionType: UICollectionView!
    @IBOutlet weak var collectionTypeHeight: NSLayoutConstraint!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var addressIdLabel: UILabel!
    @IBOutlet weak var copyBtn: HighlightButon!
    @IBOutlet weak var copyDesBtn: HighlightButon!
    @IBOutlet weak var destiationTagView: UIView!
    @IBOutlet weak var destiationContentView: UIView!
    @IBOutlet weak var destiationLabel: UILabel!
    @IBOutlet weak var destionationValue: UILabel!
    let itemSize = CGSize(width: 76, height: 38)
    private var collectionViewDelegate: BaseCollectionViewDataSource<DateTypeRateCollectionViewCell>?
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = collectionType.collectionViewLayout.collectionViewContentSize.height
        collectionTypeHeight.constant = height
        self.stackCautions.layoutIfNeeded()
        self.view.layoutIfNeeded()
    }
    
    override func setupUI() {
        let title = String(format: "activity_deposit_title".Localizable(),presenter?.interactor?.walletCurrency.id ?? "")
        let icon = String(format: CurrencyIconType.crypto.url, presenter?.interactor?.walletCurrency.id ?? "")
        setupNavigationBar(title: title,
                           icon: icon,
                           titleLeftItem: "common_previous".Localizable())
        setupCollectionView()
        copyBtn.applyLightButtonStyle()
        copyDesBtn.applyLightButtonStyle()
    }
    
    private func updateBorderColor() {
        [addressView, destiationContentView].forEach {
            $0?.borderWidth = 1
            $0?.cornerRadius = 2
            $0?.borderColor = UIColor.color_e6e6e6_646464
        }
    }
    
    override func setupDarkMode() {
        super.setupDarkMode()
        updateBorderColor()
        collectionType.reloadData()
    }
    
    override func localizedString() {
        blockChainTypeLabel.text = "common_blockchaintype".Localizable()
        depositAdressLabel.text = "activity_deposit_address_title".Localizable()
        cautionsLabel.text = "common_cautions".Localizable()
        showContract.text = "dialog_smart_contract_warning_beforeclick".Localizable()
        copyBtn.setTitle("activity_deposit_copy".Localizable(), for: .normal)
        copyDesBtn.setTitle("activity_deposit_copy".Localizable(), for: .normal)
        if let currencyId = presenter?.interactor?.walletCurrency.id {
            let caution1 = "activity_deposit_multiplatformnotice".Localizable()
            let caution2 = "activity_deposit_notice1_1".Localizable()
            let caution3 = "activity_deposit_notice1_2".Localizable()
            let caution4 = "activity_deposit_notice2_1".Localizable()
            stackCautions.addArrangedSubview(BulletedListView(caution: String(format: caution1, currencyId)))
            stackCautions.addArrangedSubview(BulletedListView(caution: String(format: caution2, currencyId)))
            stackCautions.addArrangedSubview(BulletedListView(caution: String(format: caution3, currencyId)))
            if let platformSelected = presenter?.interactor?.platformSelected {
                stackCautions.addArrangedSubview(BulletedListView(caution: String(format: caution4, "\(platformSelected.minConfirmationCount ?? 0)", currencyId)))
            }
        }
    }

    override func setupRightToLeft(_ isRTL: Bool) {
        super.setupRightToLeft(isRTL)
        showContract.textAlignment = isRTL ? .right : .left
    }
    
    @IBAction func doCopyDes(_ sender: Any) {
        UIPasteboard.general.string = destionationValue.text ?? ""
        showSuccess(message: "copy_to_clipboard_toast".Localizable())
    }
    
    @IBAction func doCopy(_ sender: Any) {
        UIPasteboard.general.string = addressIdLabel.text ?? ""
        showSuccess(message: "copy_to_clipboard_toast".Localizable())
    }
    // MARK: - Properties
    var presenter: ViewToPresenterDepositProtocol?
    
    private func setupCollectionView() {
        collectionViewDelegate = BaseCollectionViewDataSource(hasPull: true,
                                                              hasLoadMore: false,
                                                              collectionView: collectionType)
        let layout = LeftAlignedFlowLayout()
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        collectionType.collectionViewLayout = layout
        collectionViewDelegate?.setupCell = setupCollectionCell(indexPath:dataItem:cell:)
        collectionViewDelegate?.didSelectItem = didSelectedCell(_:_:_:)
        collectionViewDelegate?.layoutSize = layoutSize(_:_:_:)
        collectionViewDelegate?.dataArray = []
    }
    
    private func setupCollectionCell(indexPath: IndexPath,
                                     dataItem: Any,
                                     cell: UICollectionViewCell) {
        let platfromSelected = presenter?.interactor?.platformSelected
        if let cell = cell as? DateTypeRateCollectionViewCell,
           let platForm = dataItem as? Platform {
            let title = platForm.displayName?.name?.localized ?? ""
            cell.billData(title: "\(title)",
                          isSelected: platfromSelected?.id == platForm.id,
                          textColor: UIColor.color_c8c8c8_7b7b7b,
                          borderColor: UIColor.color_c8c8c8_7b7b7b)
        }
    }
    
    private func didSelectedCell(_  indexPath: IndexPath,
                                 _ data: Any,
                                 _ cell: UICollectionViewCell) {
        guard let data = data as? Platform else { return }
        presenter?.interactor?.platformSelected = data
        presenter?.interactor?.idPlatformSelected = data.id
        presenter?.viewDidLoad()
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let qrCode = QRCode(string: string)
        let image: UIImage? = try? qrCode?.image()
        return image
    }
    
    func layoutSize(_ collectionView: UICollectionView,
                    _ layout : UICollectionViewLayout,
                    _ indexPath: IndexPath) -> CGSize {
        let platform = presenter?.interactor?.walletCurrency.currency?.platform?
            .filter({$0.depositSuspended != true}) ?? []
        if let title = platform.at(indexPath.item)?.displayName?.name?.localized {
            let widthSize = title.getSizeText(font: .font(style: .medium, size: 14)).width
            return CGSize(width: widthSize + 22.0,
                          height: itemSize.height)
        }
        return itemSize
    }
}


extension DepositViewController: PresenterToViewDepositProtocol{
    // TODO: Implement View Output Methods
    func updateUI() {
        guard let depositAddress = presenter?.interactor?.depositAddress,
        let address = depositAddress.address else {
            self.copyBtn.disabledLightButtonStyle()
            self.copyBtn.isEnabled = false
            return
        }
        if let configDeposit = presenter?.interactor?.configDeposit {
            configDeposit.notice?.forEach({ notice in
                switch notice.type {
                case .SMART_CONTRACT, .POPUP:
                    stackContract.isHidden = false
                    showContract.addTapGesture {
                        ContractAdressView().show(title: String(format: "dialog_smart_contract_warning_title".Localizable(),
                                                                configDeposit.currencyID ?? ""),
                                                  address: notice.data ?? "",
                                                  titleButton: "common_confirm".Localizable(),
                                                  onNextAction: nil)
                    }
                case .TEXT:
                    let dic = presenter?.interactor?.configWdwarnModel?.dictionary
                    if let predefined = notice.text?.predefined,
                       let text = dic?[predefined], !text.isEmpty {
                        if let values = notice.text?.value, values.count > 0 {
                            let newText = "- " + text.replacingOccurrences(of: "${1}", with: "%@")
                            stackCautions.addArrangedSubview(BulletedListView(caution: String(format: newText, values)))
                        } else {
                            stackCautions.addArrangedSubview(BulletedListView(caution: "- " + text))
                        }
                    }
                case .none:
                    return
                }
            })
        } else {
            stackContract.isHidden = true
        }
        if let platformSelected = presenter?.interactor?.platformSelected,
           let requireDestinationTag = platformSelected.requireDestinationTag,
           let tagText = presenter?.interactor?.depositAddress?.destinationTag,
            requireDestinationTag {
            destiationTagView.isHidden = false
            destionationValue.text = tagText
            destiationLabel.text = platformSelected.displayName?.destinationTag?.localized ?? ""
        } else {
            destiationTagView.isHidden = true
        }
        self.imageQRCode.image = generateQRCode(from: address)
        addressIdLabel.text = address
        showContract.underline()
        let platform = presenter?.interactor?.walletCurrency.currency?.platform?.filter({$0.depositSuspended != true}) ?? []
        collectionViewDelegate?.dataArray = platform
    }
}
