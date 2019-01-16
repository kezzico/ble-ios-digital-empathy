//
//  HeaderViewController.swift
//  digital-empathy
//
//  Created by Lee Irvine on 1/14/19.
//  Copyright © 2019 kezzi.co. All rights reserved.
//

import UIKit

class HeaderViewController: UIViewController {

    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    @IBOutlet weak var rightButtonImage: BroadcastView!

    var menu: MenuController!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.menu = MenuController(superview: self.view)
        
        self.leftButton.addTarget(self, action: #selector(didTouchHamburger(_:)), for: .touchUpInside)
        self.rightButton.addTarget(self, action: #selector(didTouchBroadcast(_:)), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didStartBroadcasting), name: NSNotification.Name("broadcast-on"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didStopBroadcasting), name: NSNotification.Name("broadcast-off"), object: nil)
        // Do any additional setup after loading the view.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func didTouchHamburger(_ sender: Any) {
        self.menu.show()
    }

    @objc private func didTouchBroadcast(_ sender: Any) {
        if self.rightButtonImage.on {
            self.rightButtonImage.on = false
            EmpathyBroadcast.shared.stopBroadcasting()
        } else {
            self.rightButtonImage.on = true
            EmpathyBroadcast.shared.startBroadcasting()
        }
    }
    
    @objc func didStartBroadcasting() {
        self.rightButtonImage.on = true
    }
    
    @objc func didStopBroadcasting() {
        self.rightButtonImage.on = false
    }

}
