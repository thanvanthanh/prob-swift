//
//  TransactionHistoryModel.swift
//  Probit
//
//  Created by Dang Nguyen on 23/12/2022.
//

import Foundation

struct TransactionHistory: Decodable {
    var id, type, amount, payment_service_name, crypto: String?
    var status: TransactionStatus?
    var address, time, currency_id, fee: String?
    var hash, destination_tag, platform_id, fee_currency_id: String?
    var confirmations: Int?
    var date: Date? {
        time?.toDate("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", timeZone: TimeZone(secondsFromGMT: 0))
    }
    
    func copyWith(status: TransactionStatus?, confirmations: Int?) -> TransactionHistory {
        
        let item = TransactionHistory(
            id: self.id,
            type: self.type,
            amount: self.amount,
            payment_service_name: self.payment_service_name,
            crypto: self.crypto,
            status: status ?? self.status,
            address: self.address,
            time: self.time,
            currency_id: self.currency_id,
            fee: self.fee,
            hash: "5428B2F6A69E0DDD3067E770467DD710F6E29FEF024F41823ED5AFD77A1D7759",
            destination_tag: self.destination_tag,
            platform_id: self.platform_id,
            fee_currency_id: self.fee_currency_id,
            confirmations: confirmations ?? self.confirmations
        )
        return item
    }
    
    enum CodingKeys: String, CodingKey {
        case id, type, status, amount, payment_service_name, crypto
        case address, time, currency_id, fee
        case hash, destination_tag, platform_id, fee_currency_id
        case confirmations
    }
    
    func exportStatus(isDetail: Bool = false) -> (String, UIColor) {
        let transactionStatus = status ?? .done
        var statusString = "transferdistributionhistoryadapter_requested".Localizable()
        let isDeposit = (type == TransactionType.deposit.rawValue)
        var statusColor = isDeposit ? UIColor.color_12c479 : UIColor.color_f25d4e

        switch transactionStatus {
            case TransactionStatus.done:
                statusString = "transferdistributionhistoryadapter_done".Localizable()
                statusColor = isDeposit ? UIColor.color_green500 : UIColor.color_orange500
            case TransactionStatus.canceled:
                statusString = "transferdistributionhistoryadapter_cancelled".Localizable()
                statusColor = UIColor.color_gray500
            case .cancelling:
                statusString = "transferdistributionhistoryadapter_cancelled".Localizable()
                statusColor = UIColor.color_gray500
            case .requested:
                if !isDetail {
                    statusString = "transferdistributionhistoryadapter_withdrawalcancel".Localizable()
                }
                statusColor = isDeposit ? UIColor.color_green300 : UIColor.color_orange300
                break
            case .pending, .applying, .confirmed, .confirming:
                statusString = "transferdistributionhistoryadapter_processing".Localizable()
                statusColor = isDeposit ? UIColor.color_green300 : UIColor.color_orange300
                break
            case .failed:
                statusString = "transferdistributionhistoryadapter_failed".Localizable()
                statusColor = UIColor.color_gray500
                break
        }
        return (statusString, statusColor)
    }
    
    mutating func updateStatus(newStatus: TransactionStatus) {
        status = newStatus
    }
}

struct TransactionResonse: Decodable {
    let data: [TransactionHistory]?
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

struct TransactionDetailResonse: Decodable {
    let data: String?
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

struct CancelTransactionResonse: Decodable {
    let data: String?
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}
