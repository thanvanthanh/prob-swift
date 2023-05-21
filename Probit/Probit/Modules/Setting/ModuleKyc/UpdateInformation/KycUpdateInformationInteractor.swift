//
//  KycUpdateInformationInteractor.swift
//  Probit
//
//  Created by Bradley Hoang on 10/11/2022.
//  
//

import Foundation

class KycUpdateInformationInteractor: PresenterToInteractorKycUpdateInformationProtocol {
    var pageType = UserKycStatusDetailModel.PageType.checkData
    var checkData: CheckDataModel?
    func getData() {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        validatePage(page: pageType) {
            dispatchGroup.leave()
        }      
        dispatchGroup.notify(queue: .main) { [weak self]  in
            guard let self = self else { return }
            self.getDataKyc(page: self.pageType) {
                self.presenter?.getDataCompleted()
            }
        }
    }
    
    // MARK: Properties
    var presenter: InteractorToPresenterKycUpdateInformationProtocol?
    
    var isValidDateOfBirth: Bool = false
    
    func validateDateOfBirth(_ dateOfBirth: Date) {
        let currentDate = Date()
        let dateComponents = Calendar.current.dateComponents([.year, .day],
                                                             from: dateOfBirth,
                                                             to: currentDate)
        let yearOld = dateComponents.year ?? 0
        let dayOld = dateComponents.day ?? 0
        
        if (yearOld < 18) || (yearOld == 18 && dayOld <= 0) {
            isValidDateOfBirth = false
        } else {
            isValidDateOfBirth = true
        }
        presenter?.validateDateOfBirthCompleted()
    }
    
    func updatePersionalDataKyc(_ data: [String: String]) {
        self.updateDataKyc(data: data)
    }
}

private extension KycUpdateInformationInteractor {
    
    func nextProcessAnyWay() {
        nextStep(stepName: "step2") { [weak self] in
            guard let `self` = self else { return }
            self.presenter?.updateDataSuccess()
        }
    }
    
    func validatePage(page: UserKycStatusDetailModel.PageType, completion: @escaping () -> Void) {
        SettingAPI.shared.validatePageKyc(page: page) { [weak self] result in
            defer { completion() }
            guard let self = self else { return }
            switch result {
            case .success(_ ):
                return
            case .failure(let error):
                self.presenter?.getDataFailed(error)
            }
        }
    }
    
    func getDataKyc(page: UserKycStatusDetailModel.PageType,
                    completion: @escaping () -> Void) {
        SettingAPI.shared.getCheckDataData(page: page) { [weak self] result in
            defer { completion() }
            guard let self = self else { return }
            switch result {
            case let .success(res):
                self.checkData = res.data
            case let .failure(error):
                self.presenter?.getDataFailed(error)
            }
        }
    }
    
    func updateDataKyc(data: [String: String]) {
        SettingAPI.shared.updateDataKyc(data: data) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_ ):
                self.nextProcessAnyWay()
            case .failure(let error):
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
