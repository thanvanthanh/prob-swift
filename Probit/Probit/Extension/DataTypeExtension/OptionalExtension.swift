//
//  Optional.swift
//  Probit
//
//  Created by Thân Văn Thanh on 16/09/2022.
//

import Foundation

extension Optional where Wrapped: Collection {
    
    var isNilOrEmpty: Bool {
        switch self {
        case let collection?:
            return collection.isEmpty
        case nil:
            return true
        }
    }
    
    var isNotNilAndNotEmpty: Bool {
        return !isNilOrEmpty
    }
    
}

extension Optional where Wrapped == String {
    
    var isNilOrEmpty: Bool {
        switch self {
        case let string?:
            return string.isActuallyEmpty
        case nil:
            return true
        }
    }
    
    var isNotNilAndNotEmpty: Bool {
        return !isNilOrEmpty
    }
    
    var value: String {
      return (self == nil) ? "" : self!
    }
    
}

