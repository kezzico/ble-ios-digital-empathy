//
//  HomeIndicatorConstraint.swift
//
//  Created by Lee Irvine on 1/7/19.
//  Copyright © 2019 kezzi.co. All rights reserved.
//

import UIKit

class HomeIndicatorConstraint: NSLayoutConstraint {
    private var constantInitialValue: CGFloat = 0.0
    
    override func awakeFromNib() {
        self.constantInitialValue = self.constant
        let height = Int(UIScreen.main.nativeBounds.height)

        if height >= 2436 || height == 1792 {
            self.constant = self.constantInitialValue + 34
        }
    }
}
