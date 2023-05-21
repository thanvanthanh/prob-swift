//
//  ArrayExtension.swift
//  Probit
//
//  Created by Thân Văn Thanh on 20/09/2022.
//

import Foundation

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
    
    func at(_ index: Int) -> Element? {
        if index < 0 || index > self.count - 1 {
            return nil
        }
        return self[index]
    }
    
    mutating func rearrange(fromIndex: Int, toIndex: Int) {
        let element = self.remove(at: fromIndex)
        self.insert(element, at: toIndex)
    }
}

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
