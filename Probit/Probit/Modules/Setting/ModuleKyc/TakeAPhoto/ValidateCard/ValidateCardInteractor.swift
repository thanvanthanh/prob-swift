//
//  ValidateCardInteractor.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 16/11/2565 BE.
//  
//

import Foundation

class ValidateCardInteractor: PresenterToInteractorValidateCardProtocol {
    var pageType = UserKycStatusDetailModel.PageType.loading
    var dataOcr: ValidOCRModel?
    var loadingData: LoadingKycModel?
    func getData() {
        self.validatePage(page: self.pageType) { [weak self] in
            guard let self = self else { return }
            self.getDataKyc(page: self.pageType) { [weak self] in
                guard let self = self else { return }
                self.getDataOrcKyc { [weak self] in
                    guard let self = self else { return }
                    self.presenter?.getDataCompleted()
                }
            }
        }
    }
    // MARK: Properties
    var presenter: InteractorToPresenterValidateCardProtocol?
    
    func nextProcessAnyWay() {
        nextStep(stepName: "step2") { [weak self] in
            guard let `self` = self else { return }
            self.presenter?.nextStepSuccess()
        }
    }
}

private extension ValidateCardInteractor {
    func validatePage(page: UserKycStatusDetailModel.PageType, completion: @escaping () -> Void) {
        SettingAPI.shared.validatePageKyc(page: page) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_ ):
                completion()
            case .failure(let error):
                self.presenter?.getDataFailed(error)
            }
        }
    }
    
    func getDataKyc(page: UserKycStatusDetailModel.PageType,
                    completion: @escaping () -> Void) {
        SettingAPI.shared.getGlobalKycData(page: page) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(res):
                let data = res.data
                guard let statusStr = data["status"],
                   let status = LoadingStatus(rawValue: statusStr),
                      status == .STEP1_DONE else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 60.0) { 
                        self.getDataKyc(page: self.pageType) {
                            completion()
                        }
                    }
                    return
                }
                guard let resultStr = data["result"],
                      let result = LoadingResult(rawValue: resultStr) else { return }
                self.loadingData = LoadingKycModel(status: status,
                                                   result: result)
                completion()
            case let .failure(error):
                self.presenter?.getDataFailed(error)
            }
        }
    }
    
    func getDataOrcKyc(completion: @escaping () -> Void) {
        SettingAPI.shared.getOcrConfirmData(page: .ocrConfirm) { [weak self] result in
            defer { completion() }
            guard let self = self else { return }
            switch result {
            case let .success(res):
                self.dataOcr = ValidOCRModel(res.data)
            case let .failure(error):
                self.presenter?.getDataFailed(error)
            }
        }
    }
    
    func nextStep(stepName: String, completion: @escaping () -> Void) {
        SettingAPI.shared.nextStep(stepName: stepName) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                completion()
            case let .failure(error):
                self.presenter?.getDataFailed(error)
            }
        }
    }
}
