//
//  EmpathyTableViewController.swift
//  digital-empathy
//
//  Created by Lee Irvine on 1/14/19.
//  Copyright © 2019 kezzi.co. All rights reserved.
//

import UIKit

class EmpathyTableViewController: UITableViewController {

    var selectingEmotion: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(didDetectEmotion), name: NSNotification.Name("empathy-update"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(didStopBroadcasting), name: NSNotification.Name("broadcast-off"), object: nil)

    }

    @objc func didDetectEmotion() {
        self.tableView.reloadData()
    }
    
    @objc func didStopBroadcasting() {
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && self.selectingEmotion == false {
            return 1
        }
        
        if section == 0 && self.selectingEmotion == true {
            return 1 + EmotionalState.emojis.count
        }

        
        if section == 1 {
            return EmpathyListener.shared.emotions.count
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
            
            cell.emojiLabel.text = EmotionalState.emojis[EmotionalState.shared.emojiIndex]
            cell.nameLabel.text = ""
            
            return cell
        }
 	       
        if indexPath.section == 0 && indexPath.row > 0 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "emotion-cell") as! EmotionCell
            
            cell.emojiLabel.text = EmotionalState.emojis[indexPath.row - 1]
            cell.nameLabel.text = ""
            
            return cell
            
        }
        
        if indexPath.section == 1 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "emotion-cell") as! EmotionCell
            
            let index = Int((EmpathyListener.shared.emotions.map { $1 })[indexPath.row])
            cell.emojiLabel.text = EmotionalState.emojis[index ?? 0]
            cell.nameLabel.text = ""
            cell.selectionStyle = .none
            
            return cell
        }
        
        return UITableViewCell(style: .default, reuseIdentifier: "default")
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 && indexPath.section == 0 {
            self.selectingEmotion = true
            self.tableView.reloadData()
        }

        if indexPath.row > 0 && indexPath.section == 0 {
            self.selectingEmotion = false
            EmotionalState.shared.emojiIndex = indexPath.row - 1
            
            self.tableView.reloadData()
        }

//        EmotionalState.shared.startBroadcasting()
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
