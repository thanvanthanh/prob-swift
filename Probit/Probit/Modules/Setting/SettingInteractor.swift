//
//  SettingInteractor.swift
//  Probit
//
//  Created by Thân Văn Thanh on 29/08/2022.
//  
//

import Foundation
import UIKit

class SettingInteractor: PresenterToInteractorSettingProtocol {

    // MARK: Properties
    var presenter: InteractorToPresenterSettingProtocol?
    var entity: InteractorToEntitySettingProtocol?
    var kycStatusData: UserKycStatusModel? = nil
    var profileInfo: ProfileInfo?
    var referrerCount: String?
    var feesDiscount: String?
    var currentKyc: String?
    var iconColor: UIColor?
    var kycWarning: String?
    var kycButtonTitle: String?
    
    var membershipData: MembershipModel? = nil
    var getPayInProbData: GetPayInProbModel? = nil
    var kycStatusModel: UserKycStatusDetailModel?
    var hasProbToken: Bool = false

    func getData() {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        entity?.membership(completionHandler: { [weak self] result in
            dispatchGroup.leave()
            guard let self = self else { return }
            switch result {
            case .success(let success):
                self.membershipData = success
                self.getFeesDiscount(model: success)
            case .failure(let failure):
                print(failure)
            }
        })
        
        dispatchGroup.enter()
        entity?.referrerCount(completionHandler: { [weak self] result in
            dispatchGroup.leave()
            guard let self = self else { return }
            switch result {
            case .success(let success):
                self.referrerCount = success.data.count
            case .failure(let failure):
                print(failure)
            }
        })
        
        dispatchGroup.enter()
        entity?.getPayInProb(completionHandler: { [weak self] result in
            dispatchGroup.leave()
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.getPayInProbData = data
            case .failure(let failure):
                print(failure.message)
            }
        })
        
        dispatchGroup.enter()
        entity?.getBalance(){ [weak self] result in
            dispatchGroup.leave()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.hasProbToken = response.data.first(where: {$0.currencyID.lowercased() == "prob"})?.available.asDouble() ?? 0 > 0
            case .failure(_):
                break
            }
        }
        
        dispatchGroup.enter()
        entity?.checkStep(completionHandler: { [weak self] result in
            dispatchGroup.leave()
            guard let self = self else { return }
            switch result {
            case .success(let success):
                self.currentKyc = success.data?.string
            case .failure(let failure):
                print(failure)
            }
        })
        
        dispatchGroup.enter()
        entity?.userKycStatus(completionHandler: { [weak self] result in
            dispatchGroup.leave()
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.checkStatusKyc(model: data)
                self.kycStatusData = data
            case .failure(let failure):
                print(failure)
            }
        })
        
        dispatchGroup.enter()
        SettingAPI.shared.userKycStatus { [weak self] result in
            dispatchGroup.leave()
            guard let self = self else { return }
            switch result {
            case let .success(data):
                self.kycStatusModel = data.data
            case .failure:
                break
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.presenter?.callingApiComplete()
        }
    }
        
    func getProfile() {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        entity?.getProfileInfo(completionHandler: { [weak self] result in
            dispatchGroup.leave()
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.profileInfo = data
                AppConstant.profileInfo = data
            case .failure: break
                self.presenter?.loadApiError()
            }
        })
        
        dispatchGroup.enter()
        entity?.getPhoneNumber(completion: { result in
            dispatchGroup.leave()
            switch result {
            case .success(let data):
                AppConstant.phoneNumber = data.result
            case .failure: break
            }
        })
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.presenter?.callingApiComplete()
        }
    }
    
    func getFeesDiscount(model: MembershipModel) {
        let tradeFee = model.data.tradeFeeRateByProb.asDouble()
        let tradeFeeRate = model.data.tradeFeeRate.asDouble()
        let tradeFeeDiscount = 1 - (tradeFee / tradeFeeRate)
        self.feesDiscount = tradeFeeDiscount.string.percent(withDigit: 1)
    }
    
    func postPayInProb(param: Bool) {
        entity?.postPayInProb(param: param,
                              completionHandler: { result in
            switch result {
            case .success(let data):
                self.presenter?.postFeesSwitchComplete(msg: data.result)
            case .failure(let failure):
                print(failure)
            }
        })
    }
    
    func checkStatusKyc(model: UserKycStatusModel) {
        switch model.data.statusType {
        case .new:
            self.kycButtonTitle = "globalkyc_infopanel_button_begin".Localizable()
            self.iconColor = UIColor.Basic.red
            self.kycWarning = String.init(format: "globalkyc_infopanel_title_begin".Localizable(),
                                  "globalkyc_step2".Localizable())
        case .begin:
            self.kycButtonTitle = "globalkyc_infopanel_button_begin".Localizable()
            self.iconColor = UIColor.Basic.grayText
            self.kycWarning = String.init(format: "globalkyc_infopanel_title_begin".Localizable(),
                                  "globalkyc_step2".Localizable())
        case .pending:
            self.kycButtonTitle = "globalkyc_infopanel_button_begin".Localizable()
            self.iconColor = UIColor.Basic.grayText
            self.kycWarning = String.init(format: "globalkyc_infopanel_title_begin".Localizable(),
                                  "globalkyc_step2".Localizable())
        case .done:
            self.kycButtonTitle = "globalkyc_infopanel_button_pending".Localizable()
            self.iconColor = UIColor.Basic.blue
            self.kycWarning = String.init(format: "globalkyc_infopanel_title_done".Localizable(),
                                  "globalkyc_step2".Localizable())
        case .rejected:
            self.kycButtonTitle = "globalkyc_infopanel_button_begin".Localizable()
            self.iconColor = UIColor.Basic.red
            self.kycWarning = String.init(format: "globalkyc_infopanel_title_rejected".Localizable(),
                                  "globalkyc_step2".Localizable())
            if let pageTypeKyc = kycStatusModel?.pageType {
                switch pageTypeKyc {
                case .country, .personalInfo, .selfieImage, .idType, .idImage, .loading, .checkData:
                    self.kycButtonTitle = "globalkyc_infopanel_button_begin".Localizable()
                    self.iconColor = UIColor.Basic.grayText
                    self.kycWarning = String.init(format: "globalkyc_infopanel_title_begin".Localizable(),
                                          "globalkyc_step2".Localizable())
                default:
                    break
                }
            }
        case .none:
            break
        }
    }
}
