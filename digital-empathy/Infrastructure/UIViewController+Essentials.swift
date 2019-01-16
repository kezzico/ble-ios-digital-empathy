//
//  UIViewController+Essentials.swift
//
//  Created by Lee Irvine on 8/30/18.
//  Copyright © 2018 kezzi.co. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func hideKeyboardOnTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc internal func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func alert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        
        self.present(alert, animated: true, completion: nil)
    }

    @objc internal func backButtonClicked(){
        self.navigationController?.popViewController(animated: true)
    }

}

