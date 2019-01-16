//
//  Walkthrough1ViewController.swift
//  digital-empathy
//
//  Created by Lee Irvine on 1/15/19.
//  Copyright © 2019 kezzi.co. All rights reserved.
//

import UIKit

class Walkthrough1ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        EmpathyNotifier.shared.requestPermission()
    }
    
}
