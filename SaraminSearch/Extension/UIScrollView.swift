//
//  UIScrollView.swift
//  SaraminSearch
//
//  Created by 1 on 21/02/2019.
//  Copyright © 2019 Sung Hyun. All rights reserved.
//

import UIKit

extension UIScrollView {
    var isOverflowVertical: Bool {
        return self.contentSize.height > self.frame.height && self.frame.height > 0
    }
    
    func isReachedBottom(withTolerance tolerance: CGFloat = 0) -> Bool {
        guard self.isOverflowVertical else { return false }
        let contentOffsetBottom = self.contentOffset.y + self.frame.height
        return contentOffsetBottom >= self.contentSize.height - tolerance
    }
}
