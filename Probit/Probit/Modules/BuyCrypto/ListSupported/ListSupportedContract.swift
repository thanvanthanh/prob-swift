//
//  ListSupportedContract.swift
//  Probit
//
//  Created by Thân Văn Thanh on 24/08/2022.
//  
//

import Foundation
import UIKit


// MARK: View Output (Presenter -> View)
protocol PresenterToViewListSupportedProtocol {
    func reloadData()
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterListSupportedProtocol {
    
    var view: PresenterToViewListSupportedProtocol? { get set }
    var interactor: PresenterToInteractorListSupportedProtocol? { get set }
    var router: PresenterToRouterListSupportedProtocol? { get set }
    var listSupported: [ListSupported] { get }
    var isSelectType: String? { get set }
    var listData: BuyCryptoModel? { get set }
    var cryptoType: CryptoType? { get set}
    func viewDidLoad()
    func filterData(searchText: String)
    func selectedData(data: ListSupported, type: CryptoType)
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorListSupportedProtocol {
    
    var presenter: InteractorToPresenterListSupportedProtocol? { get set }
    var listSupported: [ListSupported] { get set }
    var listData: BuyCryptoModel? { get set }
    var cryptoType: CryptoType? { get set}
    func getData()
    func filterData(searchText: String)
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterListSupportedProtocol {
    func dataListDidFetch()
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterListSupportedProtocol {
    
}
