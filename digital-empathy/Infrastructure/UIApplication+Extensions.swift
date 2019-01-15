//
//  UIApplication+Extensions.swift
//  digital-empathy
//
//  Created by Lee Irvine on 1/14/19.
//  Copyright © 2019 kezzi.co. All rights reserved.
//

import UIKit

extension UIApplication {
    var firstLaunch: Bool {
        if UserDefaults.standard.value(forKey: "first-launch-date") == nil {
            UserDefaults.standard.setValue(Date().iso8601, forKey: "first-launch-date")
            return true
        }
    
        return false
    }
}
