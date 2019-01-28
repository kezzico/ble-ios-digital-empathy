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
    var emoji:String
    var name:String
    
    var signal:NSNumber
    var peripheral:CBPeripheral?
    var isInitialized: Bool { return self.emoji != "😑" }
    init(peripheral: CBPeripheral, RSSI: NSNumber) {
        self.peripheral = peripheral
        self.signal = RSSI
        
        self.name = String(peripheral.identifier.uuidString.prefix(Emotion.maxNameLength))
        self.emoji = "😑"
    }
    
    init(name: String?, emoji: String?) {
        self.signal = 0
        self.name = name ?? "unidentified"
        self.emoji = emoji ?? "😑"
    }
    
    static let maxNameLength = 12
    
    static var me: Emotion = {
        return MyEmotion(
            name: UserDefaults.standard.string(forKey: "name") ?? "Me",
           emoji: UserDefaults.standard.string(forKey: "emoji"))
    }()
    
    func encode() -> Data? {
        return "\(self.emoji)\(self.name)".data(using: String.Encoding.nonLossyASCII)
    }
    
    // returns false with bad data OR no changes
    func update(_ decode: Data) -> Bool {
        guard let str = String(bytes: decode, encoding: .nonLossyASCII) else { return false }
        
        let newEmoji = String(str.prefix(1))
        let newName = String(str.suffix(from: String.Index(encodedOffset: 2)))
        
        let didEmojiChange = self.emoji != newEmoji
        let didNameChange = self.name != newName
        
        self.name = newName
        self.emoji = newEmoji
        
        return didEmojiChange || didNameChange
    }
}


internal class MyEmotion: Emotion {
    override var name:String {
        didSet {
            UserDefaults.standard.set(name, forKey: "name")
        }
    }

    override var emoji:String {
        didSet {
            UserDefaults.standard.set(emoji, forKey: "emoji")
        }
    }

}
