//
//  OpenOrdersPresenter.swift
//  Probit
//
//  Created by Nguyen Quang on 29/08/2022.
//  
//

import Foundation

protocol OpenOrdersDelegate: AnyObject {
    func didCancelOrderSuccess()
}

class OpenOrdersPresenter: ViewToPresenterOpenOrdersProtocol {
    // MARK: Properties
    var view: PresenterToViewOpenOrdersProtocol?
    var interactor: PresenterToInteractorOpenOrdersProtocol?
    var router: PresenterToRouterOpenOrdersProtocol?
    var screenType: OpenOrdersType?
    var orderOpens: [OrderDataModel] { interactor?.orderOpens ?? []}
    weak var delegate: OpenOrdersDelegate?
    
    func viewWillAppear(hidePair: Bool) {
        view?.showLoading()
        interactor?.getData(hidePair: hidePair)
    }
}

extension OpenOrdersPresenter: InteractorToPresenterOpenOrdersProtocol {
    func cancelOrderSucess(hidePair: Bool, orderDatas: [OrderDataEntry]) {
        view?.hideLoading()
        interactor?.getData(hidePair: hidePair)
        if orderDatas.count == 1, let marketID = orderDatas.first?.marketID?.replacingOccurrences(of: "-", with: "/") {
            let text =  String(format: "fragment_openorder_v2_cancel_single".Localizable(), marketID)
            view?.showSuccess(message: text)
        } else if orderDatas.count > 1 {
            view?.showSuccess(message: "fragment_openorder_v2_cancel_multiple_all".Localizable())
        }
        self.delegate?.didCancelOrderSuccess()
    }
    
    func doCancelOrder(openOrder: OrderDataModel, hidePair: Bool) {
        view?.showLoading()
        interactor?.doCancelOrder(openOrder: openOrder, hidePair: hidePair)
    }
    
    func doCancelAllOrder(hidePair: Bool) {
        view?.showLoading()
        interactor?.doCancelAllOrder(hidePair: hidePair)
    }
    
    func handerApiError(error: ServiceError) {
        view?.hideLoading()
        view?.showError(error: error)
    }
    
    func changeStateResponseSucces() {
        view?.hideLoading()
        view?.reloadData()
    }
}
