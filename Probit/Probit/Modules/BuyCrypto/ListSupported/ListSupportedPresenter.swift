//
//  ListSupportedPresenter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 24/08/2022.
//  
//

import Foundation

class ListSupportedPresenter: ViewToPresenterListSupportedProtocol {
    
    weak var delegate: BuyCryptoDelegate?
    // MARK: Properties
    var view: PresenterToViewListSupportedProtocol?
    var interactor: PresenterToInteractorListSupportedProtocol?
    var router: PresenterToRouterListSupportedProtocol?
    var listSupported: [ListSupported] { interactor?.listSupported ?? [] }
    var isSelectType: String?
    var listData: BuyCryptoModel?
    var cryptoType: CryptoType?
    
    init(delegate: BuyCryptoDelegate? = nil) {
        self.delegate = delegate
    }
    
    func viewDidLoad() {
        interactor?.getData()
    }
    
    func filterData(searchText: String) {
        interactor?.filterData(searchText: searchText)
    }
    
    func selectedData(data: ListSupported, type: CryptoType) {
        delegate?.getSpend(data: data, type: type)
    }
}

extension ListSupportedPresenter: InteractorToPresenterListSupportedProtocol {
    func dataListDidFetch() {
        view?.reloadData()
    }
}
