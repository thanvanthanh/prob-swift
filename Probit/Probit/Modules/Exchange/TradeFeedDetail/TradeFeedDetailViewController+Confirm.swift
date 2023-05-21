//
//  TradeFeedDetailViewController+Confirm.swift
//  Probit
//
//  Created by Nguyen Quang on 14/03/2023.
//
import UIKit

extension TradeFeedDetailViewController {
    public func showPopUpConfirm(orderSide: OrderSide) {
        let messError = getErrorValidateInput(orderSide: orderSide)
        guard messError == "" else {
            let message = "\("activity_order_invalidinput".Localizable())\n\(messError)"
            showFloatsMessage(title: nil, message: message, type: .error)
            return
        }
        var confirmTradeFeed: ConfirmTradeFeed
        if presenter?.reportTrade == .limit {
            let amount = getAmount().asDouble()
            let price = getPrice().asDouble()
            let total = getTotal().asDouble()
            
            if let minPrice = presenter?.exchange?.minPrice,
               let maxPrice = presenter?.exchange?.maxPrice,
               !(minPrice.asDouble()...maxPrice.asDouble()).contains(price) {
                let message = String(format: "activity_order_wrongminmax".Localizable(),
                                     "orderform_price".Localizable(),
                                     minPrice,
                                     maxPrice)
                showFloatsMessage(title: nil, message: message, type: .error)
                return
            }
            
            if let minQuantity = presenter?.exchange?.minQuantity,
               let maxQuantity = presenter?.exchange?.maxQuantity,
               !(minQuantity.asDouble()...maxQuantity.asDouble()).contains(amount) {
                let message = String(format: "activity_order_wrongminmax".Localizable(),
                                     "orderform_amount".Localizable(),
                                     minQuantity,
                                     maxQuantity)
                showFloatsMessage(title: nil, message: message, type: .error)
                return
            }
            
            if let minCost = presenter?.exchange?.minCost,
               let maxCost = presenter?.exchange?.maxCost,
               !(minCost.asDouble()...maxCost.asDouble()).contains(total){
                let message = String(format: "activity_order_wrongminmax".Localizable(),
                                     "orderform_total".Localizable(),
                                     minCost,
                                     maxCost)
                showFloatsMessage(title: nil, message: message, type: .error)
                return
            }
            
            if let availableBalanceQuoteCurrency = presenter?.availableBalanceQuoteCurrency,
               orderSide == .BUY,
               availableBalanceQuoteCurrency < total {
                showFloatsMessage(title: nil, message: "alert_order_failed_notenoughbalance".Localizable(), type: .error)
                return
            }
            
            if let availableBalanceBaseCurrency = presenter?.availableBalanceBaseCurrency,
               orderSide == .SELL,
               availableBalanceBaseCurrency < amount {
                showFloatsMessage(title: nil, message: "alert_order_failed_notenoughbalance".Localizable(), type: .error)
                return
            }
            
            confirmTradeFeed = ConfirmTradeFeed(marketId: presenter?.subTitle,
                                                orderPrice: getPrice(),
                                                orderAmount: getAmount(),
                                                totalOrder: getTotal())
        } else {
            let total = getTotal().asDouble()
            let amount = getAmount().asDouble()
            if let availableBalanceQuoteCurrency = presenter?.availableBalanceQuoteCurrency,
               orderSide == .BUY, availableBalanceQuoteCurrency < total {
                showFloatsMessage(title: nil, message: "alert_order_failed_notenoughbalance".Localizable(), type: .error)
                return
            }
            
            if  let availableBalanceBaseCurrency = presenter?.availableBalanceBaseCurrency,
                orderSide == .SELL, availableBalanceBaseCurrency < amount {
                showFloatsMessage(title: nil, message: "alert_order_failed_notenoughbalance".Localizable(), type: .error)
                return
            }
            
            if orderSide == .BUY,
               let minCost = presenter?.exchange?.minCost,
               let maxCost = presenter?.exchange?.maxCost,
               !(minCost.asDouble()...maxCost.asDouble()).contains(total){
                let message = String(format: "activity_order_wrongminmax".Localizable(),
                                     "orderform_total".Localizable(),
                                     minCost,
                                     maxCost)
                showFloatsMessage(title: nil, message: message, type: .error)
                return
            }
            
            if orderSide == .SELL,
               let minQuantity = presenter?.exchange?.minQuantity,
               let maxQuantity = presenter?.exchange?.maxQuantity,
               !(minQuantity.asDouble()...maxQuantity.asDouble()).contains(total){
                let message = String(format: "activity_order_wrongminmax".Localizable(),
                                     "orderform_amount".Localizable(),
                                     minQuantity,
                                     maxQuantity)
                showFloatsMessage(title: nil, message: message, type: .error)
                return
            }
            
            confirmTradeFeed = ConfirmTradeFeed(marketId: presenter?.subTitle,
                                                orderPrice: getPricePopup(),
                                                orderAmount: orderSide == .BUY ? nil : getAmount(),
                                                totalOrder: orderSide == .BUY ? getTotal() : nil)
        }
        presenter?.showPopUpConfirm(orderSide: orderSide, data: confirmTradeFeed)
    }
    
    public func getErrorValidateInput(orderSide: OrderSide) -> String {
        var messError: String = ""
        let emptyMess: String = "alert_order_failed_invalidinput_reason_empty".Localizable()
        if getPrice().isEmpty {
            messError += "\(emptyMess.format("orderform_price".Localizable())) "
        }
        if getAmount().isEmpty, !amountStack.isHidden {
            messError += "\(emptyMess.format("orderform_amount".Localizable())) "
        }
        if getTotal().isEmpty, !mainTotalStackView.isHidden {
            messError += emptyMess.format("orderform_total".Localizable())
        }
        return messError
    }
}

// MARK: - UITextfield Delegate
extension TradeFeedDetailViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let updatedString = (textField.text as NSString?)?
            .replacingCharacters(in: range, with: string) else { return true }
        if updatedString == "" { return true }
        guard let oldText = textField.text,
              let r = Range(range, in: oldText),
              let quantityPrecision = presenter?.exchange?.quantityPrecision,
              let costPrecision = presenter?.exchange?.costPrecision,
              let priceIncrement = presenter?.exchange?.priceIncrement,
              let maxPrice = presenter?.exchange?.maxPrice,
              let maxCost = presenter?.exchange?.maxCost,
              let maxQuantity = presenter?.exchange?.maxQuantity else { return true }
        
        let newText = oldText.replacingCharacters(in: r, with: string)
        let isNumeric = newText.isEmpty || (Double(newText) != nil)
        let countZero = newText.prefix(while: { $0 == "0" }).count
        let numberOfDecimalDigits: Int
        if string == "," {
            if newText.contains(find: ".") {
                return false
            } else {
                let text = textField.text.value + "."
                if let dotIndex = text.firstIndex(of: ".") {
                    let isDecimalFirst = newText.distance(from: newText.startIndex, to: dotIndex) == 0
                    if !isDecimalFirst { textField.text = text }
                }
                return false
            }
        }
        if countZero > 1 { return false }
        if let dotIndex = newText.firstIndex(of: ".") {
            numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
            let isDecimalFirst = newText.distance(from: newText.startIndex, to: dotIndex) == 0
            if isDecimalFirst { return false }
        } else {
            numberOfDecimalDigits = 0
        }
        
        if textField == amountTextField {
            let validateMax = newText.asDouble() <= maxQuantity.asDouble()
            return isNumeric && numberOfDecimalDigits <= quantityPrecision && validateMax
        } else if textField == totalTextField {
            let validateMax = newText.asDouble() <= maxCost.asDouble()
            return isNumeric && numberOfDecimalDigits <= costPrecision && validateMax
        } else if textField == priceTextField{
            let decimal = Decimal(string: priceIncrement)?.significantFractionalDecimalDigits ?? 1
            let validateMax = newText.asDouble() <= maxPrice.asDouble()
            return isNumeric && numberOfDecimalDigits <= decimal && validateMax
        }
        return true
    }
}
