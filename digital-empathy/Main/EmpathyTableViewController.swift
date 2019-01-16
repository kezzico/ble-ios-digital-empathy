//
//  EmpathyTableViewController.swift
//  digital-empathy
//
//  Created by Lee Irvine on 1/14/19.
//  Copyright © 2019 kezzi.co. All rights reserved.
//

import UIKit

class EmpathyTableViewController: UITableViewController {

    private var hiddenTextField = UITextField(frame: CGRect.zero)

    var selectingEmotion: Bool = false
    var emotions: [Emotion] = []
    var name = "Me"

    var emojis = ["😋","😁","😍",
                  "🧐","🙂","😔",
                  "😩","😡","😰"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didDetectEmotion), name: NSNotification.Name("empathy-update"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(didStopBroadcasting), name: NSNotification.Name("broadcast-off"), object: nil)

        // setup keyboard events
        self.view.addSubview(self.hiddenTextField)
        self.hideKeyboardOnTap()
        self.hiddenTextField.addTarget(self, action: #selector(didEditName), for: .editingChanged)
        self.hiddenTextField.returnKeyType = .done
        self.hiddenTextField.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.update()
    }
    
    func update() {
        self.emotions = EmpathyListener.shared.emotions()
        
        self.tableView.reloadData()
    }

    @objc func didDetectEmotion() {
        self.update()
    }
    
    @objc func didStopBroadcasting() {
        self.update()
    }
    
    @objc func didEditName() {
        let str = self.hiddenTextField.text ?? "Me"
        
        if str.count > 12 {
            let index = str.index(str.startIndex, offsetBy: 12)
            self.name = String(str[..<index])
            self.hiddenTextField.text = self.name
        } else {
            self.name = str
        }
        
        self.update()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && self.selectingEmotion == false {
            return 1
        }
        
        if section == 0 && self.selectingEmotion == true {
            return 1 + self.emojis.count
        }

        
        if section == 1 {
            return self.emotions.count
        }
        
        return 0
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "HOW ARE YOU FEELING?"
        }
        
        if section == 1 {
            return "HOW OTHERS AROUND YOU FEEL"
        }
        
        return ""
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == 0 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "emotion-cell") as! EmotionCell
            
            cell.emojiLabel.text = EmpathyBroadcast.shared.emoji ?? "😑"
            cell.nameLabel.text = self.name
            
            return cell
        }
 	       
        if indexPath.section == 0 && indexPath.row > 0 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "emotion-cell") as! EmotionCell
            
            cell.emojiLabel.text = self.emojis[indexPath.row - 1]
            cell.nameLabel.text = ""
            
            return cell
            
        }
        
        if indexPath.section == 1 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "emotion-cell") as! EmotionCell
            
            cell.emojiLabel.text = self.emotions[indexPath.row].emoji
            cell.nameLabel.text = self.emotions[indexPath.row].peripheral.identifier.uuidString

            cell.selectionStyle = .none
            
            return cell
        }
        
        return UITableViewCell(style: .default, reuseIdentifier: "default")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 && indexPath.section == 0 && self.selectingEmotion == false {
            self.selectingEmotion = true
            self.update()
        }
        
        else if indexPath.row == 0 && indexPath.section == 0 && self.selectingEmotion == true {
            self.hiddenTextField.becomeFirstResponder()
        }

        else if indexPath.row > 0 && indexPath.section == 0 {
            self.selectingEmotion = false
            
            EmpathyBroadcast.shared.updateValue( self.emojis[ indexPath.row - 1 ] )
            EmpathyBroadcast.shared.startBroadcasting()

            self.update()
        }
    }
    
}

extension EmpathyTableViewController: UITextFieldDelegate {
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return false
    }
}
