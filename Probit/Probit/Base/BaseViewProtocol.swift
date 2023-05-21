//
//  BaseViewProtocol.swift
//  Probit
//
//  Created by Nguyen Quang on 14/09/2022.
//

import Foundation

protocol BaseViewProtocol: AnyObject {
    func hideLoading()
    func showLoading()
    func showError(error: ServiceError)
    func showSuccess(message: String)
    func showErrorWarningPopup(_ acceptAction: (() -> Void)?,
                               _ cancelAction: (() -> Void)?)
}
