//
//  DoubleExtension.swift
//  Probit
//
//  Created by Thân Văn Thanh on 09/09/2022.
//

import Foundation

extension Double {
    func roundToEightDecimal() -> Double {
        return ceil(1000000000 * self) / 1000000000
    }
    
    func roundToDecimal() -> String {
        let dataString = String(format: "%.8f", self)
        return dataString
    }
    
    func roundToDecimal(max: Int = 4) -> String {
        let dataString = String(format: "%.\(max)f", self)
        return dataString
    }
    
    func asString() -> String {
        return String(self)
    }
    
    var toPercentage: String? {
        return "\(Int(self * 100))%"
    }
    
    func toPercent(total: Double) -> String {
        let percent = ((self/total) * 100)
        return Int((percent.isNaN ? 0 : percent)).asString()
    }
    
    func forTrailingZero(min: Int = 0, max: Int = 8) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = min
        formatter.maximumFractionDigits = max
        formatter.minimumIntegerDigits = 1
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = "."
        formatter.locale = Locale(identifier: "en-us")
        formatter.roundingMode = .down
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
        /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }

}

extension FloatingPoint {
    func fractionDigits(min: Int = 8, max: Int = 8, roundingMode: NumberFormatter.RoundingMode = .down) -> String {
        Formatter.number.minimumFractionDigits = min
        Formatter.number.maximumFractionDigits = max
        Formatter.number.minimumIntegerDigits = 1
        Formatter.number.roundingMode = roundingMode
        Formatter.number.generatesDecimalNumbers = true
        Formatter.number.numberStyle = .decimal
        Formatter.number.decimalSeparator = "."
        Formatter.number.groupingSeparator = ","
        Formatter.number.locale = Locale(identifier: "en-us")
        return Formatter.number.string(for: self) ?? ""
    }
}

extension Formatter {
    static let number = NumberFormatter()
}

extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
           let multiplier = pow(10, Double(fractionDigits))
           return Darwin.round(self * multiplier) / multiplier
       }
}
