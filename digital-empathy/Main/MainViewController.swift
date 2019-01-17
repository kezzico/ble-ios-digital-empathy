//
//  EmpathyTableViewController.swift
//  digital-empathy
//
//  Created by Lee Irvine on 1/14/19.
//  Copyright © 2019 kezzi.co. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {

    private var hiddenTextField = UITextField(frame: CGRect.zero)

    var selectingEmotion: Bool = false
    var emotions: [Emotion] = []

    var emojis = ["😋","😁","😍",
                  "🧐","🙂","😔",
                  "😩","😡","😰"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didDetectEmotion), name: NSNotification.Name("empathy-update"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didStopBroadcasting), name: NSNotification.Name("broadcast-off"), object: nil)
        EmpathyBroadcast.shared.startBroadcasting()

        // setup keyboard events
        self.view.addSubview(self.hiddenTextField)
        self.hideKeyboardOnTap()
        self.hiddenTextField.addTarget(self, action: #selector(didEditName), for: .editingChanged)
        self.hiddenTextField.addTarget(self, action: #selector(didChangeName), for: .editingDidEnd)
        self.hiddenTextField.addTarget(self, action: #selector(willChangeName), for: .editingDidBegin)
        self.hiddenTextField.returnKeyType = .done
        self.hiddenTextField.delegate = self
        //
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

    @objc func willChangeName() {
        self.hiddenTextField.text = Emotion.me.name
    }
    
    @objc func didEditName() {
        var name = self.hiddenTextField.text ?? ""
        
        if name.count > Emotion.maxNameLength {
            let index = name.index(name.startIndex, offsetBy: Emotion.maxNameLength)
            name = String(name[..<index])
            self.hiddenTextField.text = name
        }
        
        Emotion.me.name = name

        self.update()
    }
    
    @objc func didChangeName() {
        EmpathyBroadcast.shared.updateValue(Emotion.me)
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
        /// My Emotion Cell
        if indexPath.section == 0 && indexPath.row == 0 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "emotion-cell") as! EmotionCell
            
            cell.emotion = Emotion.me
            
            return cell
        }
        
        // Select Emotion Cell
        if indexPath.section == 0 && indexPath.row > 0 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "emotion-cell") as! EmotionCell
            
            cell.emojiLabel.text = self.emojis[indexPath.row - 1]
            cell.nameLabel.text = ""
            
            return cell
            
        }
        
        // Other Emotion Cell
        if indexPath.section == 1 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "emotion-cell") as! EmotionCell
            
            cell.emotion = self.emotions[indexPath.row]
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
            
            Emotion.me.emoji = self.emojis[ indexPath.row - 1 ]
            EmpathyBroadcast.shared.updateValue( Emotion.me )

            self.update()
        }
    }
    
}

extension MainViewController: UITextFieldDelegate {
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return false
    }
}
