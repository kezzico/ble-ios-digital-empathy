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
    
    var selectionView: SelectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.selectionView = SelectionView(frame: CGRect.zero)
        self.selectionView.isHidden = true

        self.contentView.addSubview(selectionView)
        
        self.selectionView.centerXToSuperview()
        self.selectionView.centerYToSuperview()
        self.selectionView.addWidthConstraint(with: 80)
        self.selectionView.addHeightConstraint(with: 80)
    }
    
    
    override var isSelected: Bool {
        didSet {
            self.selectionView.isHidden = !isSelected
        }
    }
}

class SelectionView: UIView {
    override func layoutSubviews() {
        self.layer.cornerRadius = self.bounds.size.width * 0.5

        self.layer.borderColor = UIColor(displayP3Red: 15/255.0, green:  64/255.0, blue: 163/255.0, alpha: 1.0).cgColor
        self.layer.borderWidth = 6
        self.backgroundColor = .clear
        
        self.clipsToBounds = true

    }
}
