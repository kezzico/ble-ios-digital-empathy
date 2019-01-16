//
//  Walkthrough2ViewController.swift
//  digital-empathy
//
//  Created by Lee Irvine on 1/15/19.
//  Copyright © 2019 kezzi.co. All rights reserved.
//

import UIKit

class Walkthrough2ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        EmpathyBroadcast.shared.requestPermission()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
