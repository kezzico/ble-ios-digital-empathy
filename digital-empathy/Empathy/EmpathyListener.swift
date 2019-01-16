//
//  EmpathyListener.swift
//  digital-empathy
//
//  Created by Lee Irvine on 1/4/19.
//  Copyright © 2019 kezzi.co. All rights reserved.
//

import UIKit
import CoreBluetooth

class EmpathyListener: NSObject {
    static var shared = EmpathyListener()
    
    private var peripheralMap:[ String : Emotion ] = [:]
    
    private var centralManager: CBCentralManager!
    private let serviceUUID = CBUUID(string: "110E4DE6-C596-4B39-8397-FF35B2AF79E7")
    private let characteristicUUID = CBUUID(string: "DA18")

    func listen() {
        self.centralManager = CBCentralManager(delegate: self, queue: nil, options: nil)
    }
    
    func emotions() -> [Emotion] {
        return self.peripheralMap
        .sorted {
            return $0.value.signal.floatValue > $1.value.signal.floatValue
        }
        .map {
            return $0.value
        }
    }
    
    private func update(_ peripheral: CBPeripheral) {

        guard let service = peripheral.service(self.serviceUUID) else { return }

        guard let characteristic = service.characteristic(self.characteristicUUID) else { return }
        
        guard let data = characteristic.value else { return }
        
        guard let emoji = String(bytes: data, encoding: .nonLossyASCII) else { return }
        
        guard let emotion = peripheralMap[peripheral.identifier.uuidString] else { return }
        
        guard emotion.emoji != emoji else { return }
        
        emotion.emoji = emoji
        
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

        self.peripheralMap[peripheral.identifier.uuidString] = Emotion(peripheral: peripheral, RSSI: RSSI)

        self.centralManager.connect(peripheral, options: nil)
    }
    
    internal func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices([serviceUUID])
    }

    internal func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        if let err = error {
            print("\(err.localizedDescription)")
        }
    }
    
    internal func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if let err = error {
            print("\(err.localizedDescription)")
            return
        }
        
        self.peripheralMap.removeValue(forKey: peripheral.identifier.uuidString)

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

        guard let service = peripheral.service(self.serviceUUID) else { return }
        
        peripheral.discoverCharacteristics([self.characteristicUUID], for: service)
    }
    
    internal func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let err = error {
            print("\(err.localizedDescription)")
            return
        }
        
        guard let characteristic = service.characteristic(self.characteristicUUID) else { return }

        peripheral.setNotifyValue(true, for: characteristic)

        update(peripheral)
    }
    
    internal func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let err = error {
            print("\(err.localizedDescription)")
            return
        }
        
        update(peripheral)
    }
}
