//
//  TradingSelectInteractor.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 14/10/2565 BE.
//  
//

import Foundation

class TradingSelectInteractor: PresenterToInteractorTradingSelectProtocol {    
    var listFilted: [ItemSelectModel] = []
    var typeList: String
    // MARK: Properties
    var presenter: InteractorToPresenterTradingSelectProtocol?
    var delegate: TradingSelectViewControllerDelegate
    var listData: [ItemSelectModel] = []
    init(delegate: TradingSelectViewControllerDelegate, typeList: String) {
        self.delegate = delegate
        self.typeList = typeList
        self.listFilted = delegate.listData(type: typeList)
        self.listData = delegate.listData(type: typeList)
    }
    
    func filterData(searchText: String) {
        let text = searchText.asTrimmed
        listFilted = text.isEmpty ? delegate.listData(type: typeList) : delegate.listData(type: typeList).filter({ data -> Bool in
            return data.title.range(of: text, options: .caseInsensitive) != nil || data.subTitle.range(of: text, options: .caseInsensitive) != nil
        })
        presenter?.dataListDidFetch()
    }
    
    func itemSelected() -> ItemSelectModel? {
        return delegate.itemSelected(type: typeList)
    }
}
