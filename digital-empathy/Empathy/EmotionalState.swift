//
//  EmotionalState.swift
//  digital-empathy
//
//  Created by Lee Irvine on 1/4/19.
//  Copyright © 2019 kezzi.co. All rights reserved.
//

import UIKit
import CoreBluetooth

class EmotionalState: NSObject {
    static var shared: EmotionalState = EmotionalState()
    static var emojis = ["😋","😁","😍",
                         "🧐","🙂","😔",
                         "😩","😡","😰"]
    
    var emojiIndex: Int = 0 {
        didSet {
            guard self.peripheral != nil else { return }
            guard let emojiCharacteristic = self.emojiCharacteristic else { return }
            
            if let data = "\(self.emojiIndex)".data(using: String.Encoding.utf8) {
                self.peripheral.updateValue(data, for: emojiCharacteristic, onSubscribedCentrals: nil)
            }
        }
    }
    

    private let serviceUUID = CBUUID(string: "110E4DE6-C596-4B39-8397-FF35B2AF79E7")
    private let characteristicUUID = CBUUID(string: "DA18")

    private var peripheral: CBPeripheralManager!
    private var emojiService: CBMutableService!
    private var emojiCharacteristic: CBMutableCharacteristic!
    
    override init() {
        super.init()
        
        self.peripheral = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }
    
    func stopBroadcasting() {
        NotificationCenter.default.post(name: NSNotification.Name("broadcast-off"), object: nil)
        
        guard peripheral.state == .poweredOn else { return }
        self.peripheral.stopAdvertising()
    }
    
    func startBroadcasting() {
        guard peripheral.state == .poweredOn else {
            NotificationCenter.default.post(name: NSNotification.Name("broadcast-off"), object: nil)
            return
        }
        
        let options: [String : Any] = [
            CBAdvertisementDataLocalNameKey: "emotional-state",
            CBAdvertisementDataServiceUUIDsKey: [self.serviceUUID]]
        
        self.peripheral.startAdvertising(options)
        
        NotificationCenter.default.post(name: NSNotification.Name("broadcast-on"), object: nil)
    }

}


// MARK: - PERIPHERAL DELEGATE
extension EmotionalState: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state != .poweredOn {
            NotificationCenter.default.post(name: NSNotification.Name("broadcast-off"), object: nil)
            return
        }

        self.emojiService = CBMutableService(type: serviceUUID, primary: true)

        self.emojiCharacteristic = CBMutableCharacteristic(
            type: CBUUID(string: "DA18"),
            properties: [.read, .notify],
            value: nil,
            permissions: .readable)
        
        self.emojiService.characteristics = [self.emojiCharacteristic]
        self.peripheral.add(self.emojiService)
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        self.startBroadcasting()
    }
}
