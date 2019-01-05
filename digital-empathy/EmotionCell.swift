//
//  EmotionCell.swift
//  digital-empathy
//
//  Created by Lee Irvine on 1/4/19.
//  Copyright © 2019 kezzi.co. All rights reserved.
//

import UIKit

class EmotionCell: UICollectionViewCell {
    @IBOutlet private var emojiLabel:UILabel!

    var emoji:String = "😑" {
        didSet {
            guard let label = self.emojiLabel else { return }
            label.text = self.emoji
        }
    }
}
