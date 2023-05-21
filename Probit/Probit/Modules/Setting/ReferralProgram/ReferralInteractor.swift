//
//  ReferralInteractor.swift
//  Probit
//
//  Created by Thân Văn Thanh on 29/08/2022.
//  
//

import Foundation

class ReferralInteractor: PresenterToInteractorReferralProtocol {

    // MARK: Properties
    var presenter: InteractorToPresenterReferralProtocol?
    var entity: InteractorToEntityReferralProtocol?
    var referrerCount: String?
    var referrerCode: String?
    var commissionFee: String?
    var referrerEarned: [ReferrerEarnedModel]? = []
    
    private var productService = GatewayApiProductService()
    
    func getData() {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        entity?.membership(completionHandler: { [weak self] result in
            guard let self = self else { return }
            dispatchGroup.leave()
            switch result {
            case .success(let success):
                let referral = success.data.referralBonusAmount.toPercentage
                self.commissionFee = referral?.replacingOccurrences(of: "%", with: "",
                                                                    options: .literal,
                                                                    range:nil)
            case .failure:
                self.presenter?.loadApiError()
            }
        })
        
        dispatchGroup.enter()
        entity?.referrerCount(completionHandler: { [weak self] result in
            guard let self = self else { return }
            dispatchGroup.leave()
            switch result {
            case .success(let data):
                self.referrerCount = data.data.count
            case .failure:
                self.presenter?.loadApiError()
            }
        })
        
        dispatchGroup.enter()
        entity?.referrerCode(completionHandler: { [weak self] result in
            guard let self = self else { return }
            dispatchGroup.leave()
            switch result {
            case .success(let success):
                let id = success.data.referrerNo.string
            // https://staging.probitglobal.com/r/14276968
                self.referrerCode = Constant.Server.baseAPIURL + "r/\(id)"
            case .failure:
                self.presenter?.loadApiError()
            }
        })
        
        dispatchGroup.enter()
        entity?.referrerEarned(completionHandler: { [weak self] result in
            guard let self = self else { return }
            dispatchGroup.leave()
            switch result {
            case .success(let res):
                self.referrerEarned = res.model
            case .failure:
                self.presenter?.loadApiError()
            }
        })
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.presenter?.callingApiComplete()
        }
    }
}
