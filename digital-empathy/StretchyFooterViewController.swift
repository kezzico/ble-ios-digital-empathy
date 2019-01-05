//
//  StretchyFooterViewController.swift
//
//  Created by Lee Irvine on 11/21/17.
//  Copyright © 2017 kezzi.co. All rights reserved.
//

// USAGE:
//
// Built to support UITableViewController in storyboard
// Place two static cells in the tableView, and the bottom cell
// will stretch to fill the screen.
//
// Connect the non-stretchable header cell to outlet below
// Supports only 2 cells, a stretchy cell, and a header cell.

import UIKit

class StretchyFooterViewController: UITableViewController {
    
    @IBInspectable var enableStatusBarFix: Bool = false
    private var statusBarMaskView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if self.enableStatusBarFix, let superview = self.tableView.superview {
            self.statusBarMaskView = UIView(frame: CGRect.zero)
            superview.insertSubview(self.statusBarMaskView, aboveSubview: self.tableView)
            
            self.statusBarMaskView.pinTop(to: superview)
            self.statusBarMaskView.pinLeft(to: superview)
            self.statusBarMaskView.pinRight(to: superview)
            self.statusBarMaskView.addHeightConstraint(with: 22.0)
            self.statusBarMaskView.backgroundColor = self.tableView.backgroundColor
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.enableStatusBarFix {
            self.statusBarMaskView.removeFromSuperview()
            self.statusBarMaskView = nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let lastIndex = self.tableView(tableView, numberOfRowsInSection: indexPath.section) - 1

        if(indexPath.row == lastIndex) {

            return self.footerHeight(section: indexPath.section);
        } else {
            let fixedHeight = super.tableView(tableView, heightForRowAt: indexPath)
            return fixedHeight
        }

    }

    private func footerHeight(section: Int) -> CGFloat {
        let footerIndex = tableView(tableView, numberOfRowsInSection: section) - 1
        let tableInsetY = self.tableView.separatorInset.left - self.tableView.separatorInset.right
        
        // area of table between insets
        let tableHeightMinusPadding = self.tableView.frame.size.height - tableInsetY
        
        // height in points for all cells above footer
        let heightOfContentAboveFooter = self.contentHeight(section: section)
        
        // minimum footer height calculated from constraints
        let footerMinimumHeight = super.tableView(tableView, heightForRowAt: IndexPath(row: footerIndex, section: section))
        
        // height footer needs to stretch to the bottom of the table view
        let stretchedFooterHeight = tableHeightMinusPadding - heightOfContentAboveFooter

        return max(stretchedFooterHeight, footerMinimumHeight)
    }
    
    // returns the sum height of all cells in section, excluding the footer
    func contentHeight(section: Int) -> CGFloat {
        let footerIndex = tableView(tableView, numberOfRowsInSection: section) - 2
        var contentHeight: CGFloat = 0
        if footerIndex >= 0 {
            for index:Int in 0...footerIndex {
                
                let tbview = self.tableView!
                let indexPath = IndexPath(item: index, section: section)
                
                contentHeight += self.tableView(tbview, heightForRowAt: indexPath)
            }
        }
        
        return contentHeight
    }
}

