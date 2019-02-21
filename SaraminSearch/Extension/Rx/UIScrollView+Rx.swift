//
//  UIScrollView+Rx.swift
//  SaraminSearch
//
//  Created by 1 on 21/02/2019.
//  Copyright © 2019 Sung Hyun. All rights reserved.
//

import RxCocoa
import RxSwift
import Foundation
extension Reactive where Base: UIScrollView {
    
    var isReachedBottom: ControlEvent<Void> {
        let source = self.contentOffset
            .filter { [weak base = self.base] offset in
                guard let base = base else { return false }
                return base.isReachedBottom(withTolerance: base.frame.height / 2)
            }
            .map { _ in Void() }
        return ControlEvent(events: source)
    }
    
}
