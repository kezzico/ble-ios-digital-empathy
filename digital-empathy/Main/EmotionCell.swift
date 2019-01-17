//
//  EmotionCell.swift
//  digital-empathy
//
//  Created by Lee Irvine on 1/14/19.
//  Copyright © 2019 kezzi.co. All rights reserved.
//

import UIKit

class EmotionCell: UITableViewCell {

    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var emotion:Emotion? {
        didSet {
            self.emojiLabel.text = emotion?.emoji ?? "😑"
            self.nameLabel.text = emotion?.name ?? "offline"
        }
    }

}
