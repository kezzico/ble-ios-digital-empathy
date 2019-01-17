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
        
        guard let emotion = peripheralMap[peripheral.identifier.uuidString] else { return }
        print("BLE: got charactreristic value \(String(bytes: data, encoding: .nonLossyASCII))")

        guard emotion.update(data) else { return }
        
        NotificationCenter.default.post(name: NSNotification.Name("empathy-update"), object: nil)
    }
}

extension EmpathyListener: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("BLE: update state \(self.centralManager.state)")
        guard self.centralManager.state == .poweredOn else {
            return
        }
        
        self.centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
    }
    
    internal func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("BLE: peripheral found \(peripheral.identifier.uuidString.prefix(4))")
        peripheral.delegate = self

        self.peripheralMap[peripheral.identifier.uuidString] = Emotion(peripheral: peripheral, RSSI: RSSI)

        self.centralManager.connect(peripheral, options: nil)
    }
    
    internal func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("BLE: peripheral connected \(peripheral.identifier.uuidString.prefix(4))")
        peripheral.discoverServices([serviceUUID])
    }

    internal func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("BLE: peripheral failed to connect \(peripheral.identifier.uuidString.prefix(4))")
        if let err = error {
            print("\(err.localizedDescription)")
        }
        
        // Q: will core-bluetooth try to reconnect automatically?
    }
    
    internal func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("BLE: peripheral did disconnect \(peripheral.identifier.uuidString.prefix(4))")
        
        if let err = error {
            print("BLE: \(err.localizedDescription)")
            return
        }
        
        let uuid = peripheral.identifier.uuidString
        
        self.peripheralMap.removeValue(forKey: uuid)

        NotificationCenter.default.post(name: NSNotification.Name("empathy-update"), object: nil)
    }
    
    //
    // called when connected phone closes out the app
    internal func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        print("BLE: peripheral services modified \(peripheral.identifier.uuidString.prefix(4))")
        
        let uuid = peripheral.identifier.uuidString

        guard let emotion = self.peripheralMap[uuid] else { return }
        
        guard let peripheral = emotion.peripheral else { return }

        self.peripheralMap.removeValue(forKey: uuid)
        self.centralManager.cancelPeripheralConnection(peripheral)
        
        NotificationCenter.default.post(name: NSNotification.Name("empathy-update"), object: nil)

    }
}

// MARK: - PERIPHERAL DELEGATE
extension EmpathyListener: CBPeripheralDelegate {
    
    internal func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("BLE: discovered peripheral service \(peripheral.identifier.uuidString.prefix(4))")

        if let err = error {
            print("BLE: \(err.localizedDescription)")
            return
        }

        guard let service = peripheral.service(self.serviceUUID) else { return }
        
        peripheral.discoverCharacteristics([self.characteristicUUID], for: service)
    }
    
    internal func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("BLE: discovered peripheral characteristic \(peripheral.identifier.uuidString.prefix(4))")

        if let err = error {
            print("BLE: \(err.localizedDescription)")
            return
        }
        
        guard let characteristic = service.characteristic(self.characteristicUUID) else { return }
        
        peripheral.setNotifyValue(true, for: characteristic)
        
        update(peripheral)
    }
    
    internal func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let err = error {
            print("BLE: \(err.localizedDescription)")
            return
        }
        
        update(peripheral)
    }
}

