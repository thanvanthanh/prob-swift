import Security
import UIKit

class KeychainService {
    
    static let shared = KeychainService()
    
    /// Save data to keychain of iOS system
    /// - Parameters:
    ///   - key: key want to save
    ///   - data: data want to save
    /// - Returns: status of save action
    func saveData(key: String, data: Data) -> OSStatus {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key,
            kSecValueData as String: data] as [String: Any]
        
        SecItemDelete(query as CFDictionary)
        
        return SecItemAdd(query as CFDictionary, nil)
    }
    
    ///  Save text to keychain of iOS system
    /// - Parameters:
    ///   - key: key want to save
    ///   - string: text want to save
    /// - Returns: status of save action
    func saveString(key: String, string: String) -> OSStatus {
        let data = string.asData ?? Data()
        return self.saveData(key: key, data: data)
    }
    
    /// Get data from ketchain
    /// - Parameter key: key want to get data
    /// - Returns: data want to get
    func loadData(key: String) -> Data? {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne ] as [String: Any]
        
        var dataTypeRef: AnyObject?
        
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == noErr {
            return dataTypeRef as? Data
        } else {
            return nil
        }
    }
    
    /// Get text from keychain
    /// - Parameter key: key want to get data
    /// - Returns: text want to get
    func loadString(key: String) -> String {
        if let data = self.loadData(key: key) {
            return data.asString
        } else {
            return ""
        }
    }
    
    /// Delete value of keychain
    /// - Parameter key: key want to delete value
    /// - Returns: status of delete action
    func delete(key: String) -> OSStatus {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne ] as [String: Any]
        return SecItemDelete(query as CFDictionary)
    }
}
