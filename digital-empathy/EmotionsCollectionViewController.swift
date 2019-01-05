//
//  EmotionsCollectionViewController.swift
//  digital-empathy
//
//  Created by Lee Irvine on 1/4/19.
//  Copyright © 2019 kezzi.co. All rights reserved.
//

import UIKit

class EmotionsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var emotion: EmotionalState = EmotionalState()
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return EmotionalState.emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.size.width - 20) / 3 //some width
        let height = width * 1.0
        
        return CGSize(width: width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emotion-cell", for: indexPath) as! EmotionCell
        
        cell.emoji = EmotionalState.emojis[indexPath.row]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView .selectItem(at: indexPath, animated: true, scrollPosition: .top)
        
        emotion.emojiIndex = indexPath.row
    }
}
