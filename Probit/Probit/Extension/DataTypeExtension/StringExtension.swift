//
//  StringExtension.swift
//  Probit
//
//  Created by Beacon on 10/08/2022.
//

import UIKit

extension String {
    
    var firstUppercased: String { prefix(1).uppercased() + dropFirst() }
    
    var toPercentage: String? {
        guard let rawValue = Double(self) else {
            return nil
        }
        
        if (floor(rawValue * 100) == rawValue * 100) {
            return "\(Int(rawValue * 100))%"
        } else {
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 0
            formatter.numberStyle = .decimal
            
            let value = (Double(rawValue*100)/100) * 100
            let percent = (formatter.string(for: value))
            return "\(percent ?? "")%"
        }
    }
    
    func percent(withDigit digits: Int = 2) -> String? {
        guard let rawValue = Double(self) else {
            return nil
        }
        
        if (floor(rawValue * 100) == rawValue * 100) {
            return "\(Int(rawValue * 100))%"
        } else {
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = digits
            formatter.minimumFractionDigits = 0
            formatter.numberStyle = .decimal
            
            let value = (Double(rawValue*100)/100) * 100
            let percent = (formatter.string(for: value))
            return "\(percent ?? "")%"
        }
    }
    
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    
    func removing(charactersOf string: String) -> String {
        let characterSet = CharacterSet(charactersIn: string)
        let components = self.components(separatedBy: characterSet)
        return components.joined(separator: "")
    }
    
    func isSecureText() -> String {
        var result = String()
        for _ in 1...self.count {
            result += "*"
        }
        return result
    }
    
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    
    func separate(every stride: Int = 4, with separator: Character = " ") -> String {
        return String(enumerated().map { $0 > 0 && $0 % stride == 0 ? [separator, $1] : [$1]}.joined())
    }
    
    func escape() -> String {
        let allowedCharacters = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return allowedCharacters
    }
    
    var isActuallyEmpty: Bool {
        return trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).isEmpty
    }
    
    // MARK: - Validation
    var containsEmoji: Bool { contains { $0.isEmoji } }
    
    var isValidEmail: Bool {
        if isEmpty { return false }
        let emailRegex = "(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}" +
        "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
        "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-" +
        "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5" +
        "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
        "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let pred = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return pred.evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        // Password must contain at least 6 characters and not contain emoji characters
        if self.count < 6 || self.containsEmoji {
            return false
        }
        return true
    }
    
    var isValidCode: String {
        !self.isEmpty ? "" : "dialog_email_content".Localizable()
    }
    
    var isNumber: Bool {
        return Double(self) != nil
    }
    
    func isOnlyDigits() -> Bool {
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
        
    }
    
    func isValidPhone() -> Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{2,}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: self)
    }
    
    func toDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                return nil
            }
        }
        return nil
    }
    
    // MARK: - Handle URL
    func openUrl() {
        guard let url = URL(string: self) else { return }
        UIApplication.shared.open(url)
    }
    
    func toDate(_ format: String? = nil, timeZone: TimeZone? = nil) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.timeZone = timeZone == nil ? .current : timeZone
        if let format = format, !format.isEmpty {
            dateFormatter.dateFormat = format
        } else {
            dateFormatter.dateFormat = AppConstant.formatDate
        }
        let date = dateFormatter.date(from: self)
        return date
    }
    
    func toDouble() -> Double {
        let numberArray = self.components(separatedBy: ".")
        let decimal = (numberArray.last ?? "0").removeTrailingZero()
        let doubleValue = Double(self) ?? 0
        let exponentiation = NSDecimalNumber(decimal: pow(10, decimal.count)).doubleValue
        let newValue = round(exponentiation * doubleValue) / exponentiation
        return newValue
    }
    
    func getDecimalCount() -> Int {
        let numberArray = self.components(separatedBy: ".")
        let decimal = (numberArray.last ?? "").removeTrailingZero()
        return numberArray.count > 1 ? decimal.count : 0
    }
    
    func getRawCount() -> Int {
        let numberArray = self.components(separatedBy: ".")
        let raw = (numberArray.first ?? "")
        return raw.count
    }
    
    func removeTrailingZero() -> String {
        let count = self.count
        guard count > 0 else { return "" }
        var newString: NSString = self as NSString
        for index in 0...count {
            let newLastIndex = count - index - 1
            if newString.substring(to: count - index) == "0", newLastIndex >= 0 {
                newString = newString.substring(to: newLastIndex) as NSString
            } else {
                break
            }
        }
        return newString as String
    }
    
    func doubleValue() -> Double? {
        return Double(self)
    }

    // MARK: - Plist
    func getPlistString(resourceName: String) -> Any? {
        guard let infoPlistPath = Bundle.main.url(forResource: resourceName, withExtension: "plist") else {
            return nil
        }
        var resources: [String: Any]?
        do {
            let infoPlistData = try Data(contentsOf: infoPlistPath)
            
            if let dict = try PropertyListSerialization.propertyList(from: infoPlistData, options: [], format: nil) as? [String: Any] {
                resources = dict
            }
        } catch {
            print(error)
        }
        return resources?[self]
    }
    
    func Localizable(langCode: String = AppConstant.localeId) -> String {
        guard let path = Bundle.main.path(forResource: langCode, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return ""
        }
        let text = NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
        let textRtl = AppConstant.isLanguageRightToLeft ? text.forceUnicodeRTL() : text
        return text.isActuallyEmpty ? Localizable(langCode: "en-US") : textRtl
    }
    
    func LocalizableRtl() -> String {
        guard let path = Bundle.main.path(forResource: AppConstant.localeId, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return ""
        }
        let text = NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
        let textRtl = AppConstant.isLanguageRightToLeft ? "\u{2068}\(text)\u{2069}" : text
        return text.isActuallyEmpty ? Localizable(langCode: "en-US") : textRtl
    }
    
    func forceUnicodeRTL() -> String {
        return "\u{200F}\(self)\u{200E}"
    }
    
    func addStrikethroughLineLocalizable(langCode: String = AppConstant.localeId) -> String {
        guard let path = Bundle.main.path(forResource: langCode, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return ""
        }
        let text = NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
        if text.isActuallyEmpty {
            return AppConstant.isLanguageRightToLeft ? Localizable(langCode: "en-US") + " -" :  "- " + Localizable(langCode: "en-US")
        } else {
            return "- " + text
        }
    }
    
    func rankLocalizableWhenRemoveBullet(langCode: String = AppConstant.localeId) -> NSRange {
        if self.count > 2 {
            return AppConstant.isLanguageRightToLeft ? NSRange(location: 0, length: (self.count - 2)) : NSRange(location: 2, length: (self.count - 2))
        }
        return NSRange(location: 0, length: 0)
    }
    
    var asData: Data? {
        data(using: .utf8)
    }
    
    var asInt: Int {
        Int(self) ?? 0
    }
    
    var asPrice: String {
        self.components(separatedBy: ".").first ?? ""
    }
    
    // MARK: Formatting text for currency
    func currencyFormatting() -> String {
        if let value = Double(self) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            if let str = formatter.string(for: value) {
                return str
            }
        }
        return ""
    }
    
    func matchesForRegexInText(regex: String, text: String?) -> String? {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = text as? NSString
            
            let results = regex.matches(in: text ?? "",
                                        options: [], range: NSMakeRange(0, nsString?.length ?? 0))
            return results.map { nsString?.substring(with: $0.range) ?? ""}.first
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return [].first
        }
    }
    
    var asTrimmed: String {
        trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func shorted(to symbols: Int) -> String {
        guard self.count > symbols else {
            return self
        }
        return self.prefix(symbols) + " ..."
    }
    
    func containsWhitespaceAndNewlines() -> Bool {
        return rangeOfCharacter(from: .whitespacesAndNewlines) != nil
    }
    
    func getSizeText(font: UIFont) -> CGSize {
        return self.size(withAttributes: [NSAttributedString.Key.font: font])
    }
    
  
}

// MARK: - Buy Crypto
extension String {
    func replaceComma() -> String {
        return self.replacingOccurrences(of: ",", with: "")
    }
    
    func replaceComaByDot() -> String {
        return self.replacingOccurrences(of: ",", with: ".")
    }
    
    func asDouble() -> Double {
        return Double(self) ?? 0.0
    }
    
    func convertExchangeWidthRound() -> String {
        return (1 / self.replaceComma().asDouble()).roundToDecimal()
    }
    
    func convertExchange() -> String {
        return (1 / self.replaceComma().asDouble()).asString()
    }
    
    func multiplyPriceToCrypto(_ price: String) -> String {
        let total = (self.asDouble() * (price.convertExchange().asDouble()))
        return String(total.roundToDecimal())
    }
    
    func multiplyCryptoToPrice(_ price: String) -> String {
        let total = (price.asDouble() * self.asDouble())
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.roundingMode = .down
        nf.decimalSeparator = ","
        nf.groupingSeparator = ""
        let string = nf.string(from: total as NSNumber) ?? ""
        let response = string.components(separatedBy: ",").first ?? ""
        return response
    }
    
    func replaceCurrency() -> String {
        let asstring = self.asDouble()
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.decimalSeparator = "."
        nf.groupingSeparator = ","
        nf.maximumFractionDigits = 8
        nf.roundingMode = .ceiling
        return nf.string(from: asstring as NSNumber) ?? ""
    }
    
    func setUnderLine(text: String, underLineFont: UIFont, stringFont: UIFont) -> NSAttributedString {
        let underLineRange = NSString(string: self).range(of: text, options: String.CompareOptions.caseInsensitive)
        let fullRange = NSString(string: self).range(of: self, options: String.CompareOptions.caseInsensitive)
        let attrStr = NSMutableAttributedString.init(string:self)
        attrStr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.white,
                               NSAttributedString.Key.font : stringFont as Any],range: fullRange)
        attrStr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.white,
                               NSAttributedString.Key.font : underLineFont,
                               NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue as Any],range: underLineRange) // for swift 4 -> Change thick to styleThick
        return attrStr
    }
    
    func setUnderline(textList: [String],
                      attributes: [NSAttributedString.Key : Any],
                      underlineAttributes: [NSAttributedString.Key : Any]) -> NSAttributedString {
        let rangeFull = NSString(string: self).range(of: self, options: String.CompareOptions.caseInsensitive)
        let attrStr = NSMutableAttributedString.init(string:self)
        attrStr.addAttributes(attributes, range: rangeFull)
        
        for text in textList {
            let rangeUnderlineText = NSString(string: self).range(of: text, options: String.CompareOptions.caseInsensitive)
            var underlineAttributes = underlineAttributes
            underlineAttributes[NSAttributedString.Key.underlineStyle] = NSUnderlineStyle.single.rawValue
            attrStr.addAttributes(underlineAttributes, range: rangeUnderlineText)
        }
        return attrStr
    }
    
    var latinCharactersOnly: Bool {
            return self.range(of: "\\P{Latin}", options: .regularExpression) == nil
    }
}

extension String {
    
    func format(_ arguments: CVarArg...) -> String {
        let args = arguments.map {
            if let arg = $0 as? Int { return String(arg) }
            if let arg = $0 as? Float { return String(arg) }
            if let arg = $0 as? Double { return String(arg) }
            if let arg = $0 as? Int64 { return String(arg) }
            if let arg = $0 as? String { return String(arg) }
            return "(null)"
        } as [CVarArg]
        return String.init(format: self, arguments: args)
    }
    
    var digitNumber: Int? {
        let pr = self.split(separator: ".").compactMap({String($0)})
        if pr.count > 1, let lenght = pr.last?.count {
            return lenght
        } else {
            return nil
        }
    }
    
}

extension Character {
    /// A simple emoji is one scalar and presented to the user as an Emoji
    var isSimpleEmoji: Bool {
        guard let firstScalar = unicodeScalars.first else { return false }
        return firstScalar.properties.isEmoji && firstScalar.value > 0x238C
    }
    
    /// Checks if the scalars will be merged into an emoji
    var isCombinedIntoEmoji: Bool { unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmoji ?? false }
    
    var isEmoji: Bool { isSimpleEmoji || isCombinedIntoEmoji }
}

extension Data {
    var asString: String {
        return String(data: self, encoding: .utf8) ?? ""
    }
}

extension NSAttributedString {
    func trimmedAttributedString() -> NSAttributedString {
        let invertedSet = CharacterSet.whitespacesAndNewlines.inverted
        let startRange = string.rangeOfCharacter(from: invertedSet)
        let endRange = string.rangeOfCharacter(from: invertedSet, options: .backwards)
        guard let startLocation = startRange?.upperBound, let endLocation = endRange?.lowerBound else {
            return NSAttributedString(string: string)
        }
        let location = string.distance(from: string.startIndex, to: startLocation) - 1
        let length = string.distance(from: startLocation, to: endLocation) + 2
        let range = NSRange(location: location, length: length)
        return attributedSubstring(from: range)
    }
}

extension NSAttributedString {
    func uppercased() -> NSAttributedString {
        let result = NSMutableAttributedString(attributedString: self)
        
        result.enumerateAttributes(in: NSRange(location: 0, length: length), options: []) {_, range, _ in
            result.replaceCharacters(in: range, with: (string as NSString).substring(with: range).uppercased())
        }
        
        return result
    }
}

extension NSMutableAttributedString {
    class func getAttributedString(fromString string: String) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: string)
    }
    
    func apply(attribute: [NSAttributedString.Key: Any], subString: String) {
        if let range = self.string.range(of: subString) {
            self.apply(attribute: attribute, onRange: NSRange(range, in: self.string))
        }
    }
    
    func apply(attribute: [NSAttributedString.Key: Any], onRange range: NSRange) {
        if range.location != NSNotFound {
            self.setAttributes(attribute, range: range)
        }
    }
    
    // Apply color on substring
    func apply(color: UIColor, subString: String) {
        if let range = self.string.range(of: subString) {
            self.apply(color: color, onRange: NSRange(range, in:self.string))
        }
    }
    
    // Apply color on given range
    func apply(color: UIColor, onRange: NSRange) {
        self.addAttributes([NSAttributedString.Key.foregroundColor: color],
                           range: onRange)
    }
    
    // Apply font on substring
    func apply(font: UIFont, subString: String) {
        if let range = self.string.range(of: subString) {
            self.apply(font: font, onRange: NSRange(range, in: self.string))
        }
    }
    
    // Apply font on given range
    func apply(font: UIFont, onRange: NSRange) {
        self.addAttributes([NSAttributedString.Key.font: font], range: onRange)
    }
    
    // Apply background color on substring
    func apply(backgroundColor: UIColor, subString: String) {
        if let range = self.string.range(of: subString) {
            self.apply(backgroundColor: backgroundColor, onRange: NSRange(range, in: self.string))
        }
    }
    
    // Apply background color on given range
    func apply(backgroundColor: UIColor, onRange: NSRange) {
        self.addAttributes([NSAttributedString.Key.backgroundColor: backgroundColor],
                           range: onRange)
    }
    
    
    // Apply paragraph style on substring
    func alignment(alignment: NSTextAlignment, subString: String) {
        if let range = self.string.range(of: subString) {
            self.alignment(alignment: alignment, onRange: NSRange(range, in: self.string))
        }
    }
    
    // Apply paragraph style on give range
    func alignment(alignment: NSTextAlignment, onRange: NSRange) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        self.addAttributes([NSAttributedString.Key.paragraphStyle : paragraphStyle], range: onRange)
    }
    
    // Underline string
    func underLine(subString: String) {
        if let range = self.string.range(of: subString) {
            self.underLine(onRange: NSRange(range, in: self.string))
        }
    }
    
    // Underline string on given range
    func underLine(onRange: NSRange) {
        self.addAttributes([NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue],
                           range: onRange)
    }
    
    func strikethrough(subString: String) {
        if let range = self.string.range(of: subString) {
            self.addAttributes([NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue],
                               range: NSRange(range, in: self.string))
        }
    }
}

extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
}

extension String {
    func toHtml() -> String {
        return """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
        <style> body { margin: 0 } </style>
        </head>
        <body>
        \(self)
        </body>
        </html>
        """
    }
}

extension Dictionary {
    var jsonStringRepresentation: String? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self,
                                                            options: [.prettyPrinted]) else {
            return nil
        }

        return String(data: theJSONData, encoding: .ascii)
    }
}

extension Decimal {
    var significantFractionalDecimalDigits: Int {
        return max(-exponent, 0)
    }
}

extension String {
    func levenshteinDistanceScore(to string: String, ignoreCase: Bool = true, trimWhiteSpacesAndNewLines: Bool = true) -> Double {

        var firstString = self
        var secondString = string

        if ignoreCase {
            firstString = firstString.lowercased()
            secondString = secondString.lowercased()
        }
        if trimWhiteSpacesAndNewLines {
            firstString = firstString.trimmingCharacters(in: .whitespacesAndNewlines)
            secondString = secondString.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        let empty = [Int](repeating:0, count: secondString.count)
        var last = [Int](0...secondString.count)

        for (i, tLett) in firstString.enumerated() {
            var cur = [i + 1] + empty
            for (j, sLett) in secondString.enumerated() {
                cur[j + 1] = tLett == sLett ? last[j] : Swift.min(last[j], last[j + 1], cur[j])+1
            }
            last = cur
        }

        // maximum string length between the two
        let lowestScore = max(firstString.count, secondString.count)

        if let validDistance = last.last {
            return  1 - (Double(validDistance) / Double(lowestScore))
        }

        return 0.0
    }
}

