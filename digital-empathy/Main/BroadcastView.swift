//
//  BroadcastView.swift
//  digital-empathy
//
//  Created by Lee Irvine on 1/14/19.
//  Copyright © 2019 kezzi.co. All rights reserved.
//

import UIKit

class BroadcastView: UIImageView {

    private var timer: Timer!

    @IBInspectable
    var on: Bool = false {
        didSet {
            if on {
                guard oldValue != on else { return }
                
                self.startAnimating()
            } else {
                self.stopAnimating()
                self.image = UIImage(named: "broadcast-off")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didStartBroadcasting), name: NSNotification.Name("broadcast-on"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didStopBroadcasting), name: NSNotification.Name("broadcast-off"), object: nil)
    }
    
    deinit {
        self.stopAnimating()
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func didStartBroadcasting() {
        self.on = true
    }
    
    @objc private func didStopBroadcasting() {
        self.on = false
    }

    override func startAnimating() {
        var animIndex = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.image = UIImage(named: "broadcast-on-\(animIndex)")
            animIndex = (animIndex + 1) % 3
        }
    }
    
    override func stopAnimating() {
        guard timer != nil else { return }
        timer.invalidate()
    }

}
