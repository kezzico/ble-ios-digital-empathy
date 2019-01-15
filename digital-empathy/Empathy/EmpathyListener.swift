//
//  EmpathyListener.swift
//  digital-empathy
//
//  Created by Lee Irvine on 1/4/19.
//  Copyright © 2019 kezzi.co. All rights reserved.
//

import UIKit
import UserNotifications
import CoreBluetooth
class EmpathyListener: NSObject {
    static var shared = EmpathyListener()
    
    var emotions:[ String : String ] = [:]
    var peripherals:[ CBPeripheral ] = []
    
    private var centralManager: CBCentralManager!
    private let serviceUUID = CBUUID(string: "110E4DE6-C596-4B39-8397-FF35B2AF79E7")
    private let characteristicUUID = CBUUID(string: "DA18")

    func listen() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted,_ in }

        self.centralManager = CBCentralManager(delegate: self, queue: nil, options: nil)
    }
    
    func notify(_ identifier: UUID, _ emojiIndex: String) {
        guard emotions[identifier.uuidString] != emojiIndex else {
            return
        }
        
        let emoji = EmotionalState.emojis[Int(emojiIndex) ?? 0]
        
        emotions[identifier.uuidString] = emojiIndex
        
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        
        content.title = "\(emoji)"
        content.body = "\(emoji)\(emoji)\(emoji)"
        content.sound = UNNotificationSound.default
        
        let identifier = UUID().uuidString
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: nil)
        
        center.add(request) { err in }
        
        NotificationCenter.default.post(name: NSNotification.Name("empathy-update"), object: nil)

    }
    
}

extension EmpathyListener: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        guard self.centralManager.state == .poweredOn else {
            return
        }
        
        self.centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
    }
    
    internal func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        peripheral.delegate = self
        self.centralManager.connect(peripheral, options: nil)
        self.peripherals.append(peripheral)
    }
    
    internal func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices([serviceUUID])
    }

    /////// error handling
    internal func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        if let err = error {
            print("\(err.localizedDescription)")
        }
    }
    ////
    
    internal func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if let err = error {
            print("\(err.localizedDescription)")
            return
        }
        
        self.emotions.removeValue(forKey: peripheral.identifier.uuidString)
        NotificationCenter.default.post(name: NSNotification.Name("empathy-update"), object: nil)
    }

}

// MARK: - PERIPHERAL DELEGATE
extension EmpathyListener: CBPeripheralDelegate {
    
    internal func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let err = error {
            print("\(err.localizedDescription)")
            return
        }

        // discover services available from peripheral
        guard let service = peripheral.service(self.serviceUUID) else {
            peripheral.discoverServices([self.serviceUUID])
            return
        }
        
        peripheral.discoverCharacteristics([self.characteristicUUID], for: service)
    }
    
    internal func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let err = error {
            print("\(err.localizedDescription)")
            return
        }
        
        guard let characteristic = service.characteristic(self.characteristicUUID) else {
            peripheral.discoverCharacteristics([self.characteristicUUID], for: service)
            return
        }

        if let data = characteristic.value, let emojiIndex = String(bytes: data, encoding: .utf8) {
            self.notify(peripheral.identifier, emojiIndex)
        }
        
        peripheral.setNotifyValue(true, for: characteristic)
    }
    
    internal func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let err = error {
            print("\(err.localizedDescription)")
            return
        }
        
        guard let data = characteristic.value else {
            print("no data for characteristic: \(characteristic.uuid)")
            return
        }
        
        if let emojiIndex = String(bytes: data, encoding: .utf8) {
            self.notify(peripheral.identifier, emojiIndex)
        }
    }
    
    
}

extension CBPeripheral {
    func service(_ uuid: CBUUID) -> CBService? {
        guard let services = self.services else {
            return nil
        }
        
        for service in services {
            if service.uuid == uuid {
                return service
            }
        }
        
        return nil
    }
    
}

extension CBService {
    func characteristic(_ uuid: CBUUID) -> CBCharacteristic? {
        guard let characteristics = self.characteristics else {
            return nil
        }
        
        for cstic in characteristics {
            if cstic.uuid == uuid {
                return cstic
            }
        }
        
        return nil
    }
}
