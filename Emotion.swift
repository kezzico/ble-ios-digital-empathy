//
//  Emotion.swift
//  digital-empathy
//
//  Created by Lee Irvine on 1/15/19.
//  Copyright © 2019 kezzi.co. All rights reserved.
//

import UIKit
import CoreBluetooth

class Emotion {
    var emoji:String?
    var signal:NSNumber
    var peripheral:CBPeripheral
    
    init(peripheral: CBPeripheral, RSSI: NSNumber) {
        self.peripheral = peripheral
        self.signal = RSSI
    }
}
