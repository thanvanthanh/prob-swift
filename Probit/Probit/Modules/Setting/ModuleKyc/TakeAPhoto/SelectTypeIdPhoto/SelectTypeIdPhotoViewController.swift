//
//  SelectTypeIdPhotoViewController.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 08/11/2565 BE.
//  
//

import UIKit

class SelectTypeIdPhotoViewController: BaseViewController {
    private var tableViewDelegate: BaseTableViewDelegate<SelectTypeIdPhotoTableViewCell>?
    let listSelectCard: [TypeCardId] = [.PASSPORT, .ID_CARD_FONT_SIDE, .DRIVING_FONT_LICENSE]
    @IBOutlet weak var nextBtn: StyleButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    override func setupDarkMode() {
        super.setupDarkMode()
        tableView.reloadData()
    }
    
    override func setupUI() {
        setupNavigationBar(title: "globalkyc_title".Localizable(),
                                titleLeftItem: "navigationbar_settings".Localizable())
        setupTableView()
        nextBtn.setEnable(isEnable: false)
        if let pageType = presenter?.interactor?.pageType {
            progressBar.progress = pageType.progressValue
        }
    }
    
    override func setupRightToLeft(_ isRTL: Bool) {
        super.setupRightToLeft(isRTL)
        selectLabel.textAlignment = isRTL ? .right : .left
    }
    
    override func localizedString() {
        selectLabel.text = "globalkyc_idtype_subtitle".Localizable()
        nextBtn.setTitle("common_next".Localizable(), for: .normal)
    }
    
    // MARK: - Properties
    var presenter: ViewToPresenterSelectTypeIdPhotoProtocol?
    
    func setupTableView() {
        tableView.separatorStyle = .none
        tableViewDelegate = BaseTableViewDelegate(hasPull: false,
                                                  hasLoadMore: false,
                                                  tableView: self.tableView)
        tableViewDelegate?.setupCell = setupCell(indexPath:dataItem:cell:)
        tableViewDelegate?.didSelectRow = didSelectedCell(_:_:)
        tableViewDelegate?.dataArray = [listSelectCard]
    }
    
    // MARK: - TableView delegate, datasource
    private func setupCell(indexPath: IndexPath,
                           dataItem: Any,
                           cell: UITableViewCell) {
        // TODO: Setup UI for cell
        if let selectCell = cell as? SelectTypeIdPhotoTableViewCell,
           let type = dataItem as? TypeCardId {
            let typeCardSelected = presenter?.interactor?.typeCardSelected
            selectCell.configureCell(type, isSelected: typeCardSelected == type)
        }
    }
    
    private func didSelectedCell(_ indexPath: IndexPath, _ cell: UITableViewCell) {
        guard let data = listSelectCard.at(indexPath.row) else { return }
        presenter?.setTypeCardSelected(data)
    }
    
    @IBAction func doNext(_ sender: Any) {
        UploadGovermentRouter().showScreen()
    }
     
    @objc override func tappedLeftBarButton(sender : UIButton) {
        self.navigationController?.popToViewController(ofClass: PhotoIsClearViewController.self) { isNavigated in
            if isNavigated { return }
            PhotoIsClearRouter(stylePhoto: .FACE).showScreen()
        }
    }
}

extension SelectTypeIdPhotoViewController: PresenterToViewSelectTypeIdPhotoProtocol{
    func reloadData() {
        nextBtn.setEnable(isEnable: self.presenter?.interactor?.typeCardSelected != nil)
        tableView.reloadData()
    }
    // TODO: Implement View Output Methods
}

private extension SelectTypeIdPhotoViewController {
    
    func shopPopupPopToKycIntro() {
        showPopupHelper("globalkyc_activity_closedialog_title".Localizable(),
                        message: "globalkyc_activity_closedialog_content".Localizable(),
                        warning: nil,
                        acceptTitle: "globalkyc_activity_closedialog_confirmbutton".Localizable(),
                        cancleTitle: "globalkyc_activity_closedialog_closebutton".Localizable(),
                        acceptAction: { [weak self] in
            guard let self = self else { return }
            self.navigationController?.popToViewController(ofClass: SettingViewController.self)
        }, cancelAction: nil)
    }
}
