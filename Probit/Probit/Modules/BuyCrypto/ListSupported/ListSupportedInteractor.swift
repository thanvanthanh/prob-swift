//
//  ListSupportedInteractor.swift
//  Probit
//
//  Created by Thân Văn Thanh on 24/08/2022.
//  
//

import Foundation

class ListSupportedInteractor: PresenterToInteractorListSupportedProtocol {
    
    // MARK: Properties
    var presenter: InteractorToPresenterListSupportedProtocol?
    var listData: BuyCryptoModel?
    var listSupported: [ListSupported] = []
    var allData: [ListSupported] =  []
    var cryptoType: CryptoType?
    
    func getData() {
        guard let listData = cryptoType == .fiat ? listData?.data?.fiat : listData?.data?.crypto else { return }
        listSupported = listData.map({ data in
            return ListSupported(name: data.currencyID,
                                 subName: data.displayName?.localized,
                                 type: cryptoType)
        })
        allData = listSupported
        presenter?.dataListDidFetch()
    }
    
    func filterData(searchText: String) {
        guard searchText != "" else {
            listSupported = allData
            presenter?.dataListDidFetch()
            return
        }
        listSupported = allData.filter({ data -> Bool in
            let searchName = data.name?.range(of: searchText, options: .caseInsensitive) != nil
            let searchSubName = data.subName?.range(of: searchText, options: .caseInsensitive) != nil
            return searchName || searchSubName
        })
        presenter?.dataListDidFetch()
    }
}
