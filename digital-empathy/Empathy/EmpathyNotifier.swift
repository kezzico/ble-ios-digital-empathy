//
//  EmpathyNotifier.swift
//  digital-empathy
//
//  Created by Lee Irvine on 1/15/19.
//  Copyright © 2019 kezzi.co. All rights reserved.
//

import UIKit
import UserNotifications

class EmpathyNotifier: NSObject {
    static let shared = EmpathyNotifier()

    func requestPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted,_ in }
    }
    
    func send(_ title: String = "Digital Empathy", message: String) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        
        content.title = title
        content.body = message
        content.sound = UNNotificationSound.default
        
        let identifier = UUID().uuidString
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: nil)
        
        center.add(request) { err in }
    }
}
