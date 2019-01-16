//
//  CoreBluetooth+Extensions.swift
//  digital-empathy
//
//  Created by Lee Irvine on 1/15/19.
//  Copyright © 2019 kezzi.co. All rights reserved.
//

import CoreBluetooth

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
