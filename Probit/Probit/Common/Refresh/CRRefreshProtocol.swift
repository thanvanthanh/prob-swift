

import UIKit

public protocol CRRefreshProtocol {
    var view: UIView {get}
    var insets: UIEdgeInsets {set get}
    var trigger: CGFloat {set get}
    var execute: CGFloat {set get}
    var endDelay: CGFloat {set get}
    var hold: CGFloat {set get}
    
    mutating func refreshBegin(view: CRRefreshComponent)
    mutating func refreshWillEnd(view: CRRefreshComponent)
    mutating func refreshEnd(view: CRRefreshComponent, finish: Bool)
    mutating func refresh(view: CRRefreshComponent, progressDidChange progress: CGFloat)
    mutating func refresh(view: CRRefreshComponent, stateDidChange state: CRRefreshState)
}
