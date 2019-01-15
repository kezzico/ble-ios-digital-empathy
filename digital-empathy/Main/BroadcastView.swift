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
    
    deinit {
        self.stopAnimating()
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
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
