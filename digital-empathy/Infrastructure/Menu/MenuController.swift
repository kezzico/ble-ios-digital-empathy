
//
//  MenuController.swift
//  lendme
//
//  Created by Lee Irvine on 9/6/18.
//  Copyright © 2018 kezzi.co. All rights reserved.
//

import UIKit

enum MenuItem: String {
    case home = "Home"
    case about = "About"
}

class MenuController: NSObject {
    private let menuWidth:CGFloat = 280.0
    private var leftMenuConstraint: NSLayoutConstraint!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var view: UIView!
    private var shadowView: UIView!

    var isMenuOpen: Bool = false
    var onMenuItemSelected = { (_ :MenuItem) in }

    var menuItems:[MenuItem] = [ .home, .about ]

    init(superview: UIView) {
        super.init()
        let nib = UINib(nibName: "HamburgerMenu", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        
        // shadow view
        self.shadowView = UIView()
        superview.addSubview(self.shadowView)
        self.shadowView.pinEdges(to: superview)
        self.shadowView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.shadowView.isHidden = true

        // tableview
        let cellNib = UINib(nibName: "HamburgerMenuItem", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: "menu-item")

        // layout
        superview.addSubview(self.view)
        self.view.pinTop(to: superview)
        self.view.pinBottom(to: superview)
        self.view.addWidthConstraint(with: menuWidth)

        self.leftMenuConstraint = self.view.pinLeft(to: superview)
        self.leftMenuConstraint.constant = -menuWidth

        // gesture recognizers
        let menuGesture = UIPanGestureRecognizer(target: self, action: #selector(menuGesture(_: )))
        superview.addGestureRecognizer(menuGesture)
        
        let tapShadowGesture = UITapGestureRecognizer(target: self, action: #selector(didTapToggle(_: )))
        shadowView.addGestureRecognizer(tapShadowGesture)
    }

    func show() {
        guard let superview = self.view.superview else {
            return
        }

        self.leftMenuConstraint.constant = 0.0
        self.shadowView.isHidden = false

        UIView.animate(withDuration: 0.2) {
            self.shadowView.alpha = 1.0
            superview.layoutIfNeeded()
        }

        self.isMenuOpen = true
    }

    func hide() {
        guard let superview = self.view.superview else {
            return
        }

        self.leftMenuConstraint.constant = -menuWidth

        UIView.animate(withDuration: 0.2) {
            self.shadowView.alpha = 0.0
            superview.layoutIfNeeded()
        }
        
        self.shadowView.isHidden = true
        self.isMenuOpen = false
    }

    @IBAction func didTouchCloseMenu(_ sender: Any) {
        self.hide()
    }
    
    @objc private func didTapToggle(_ sender: Any) {
        if self.isMenuOpen {
            self.hide()
        } else {
            self.show()
        }
    }

// MARK: - MENU ANIMATIONS

    @objc private func menuGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        let slack:CGFloat = 100

        guard let superview = self.view.superview else {
            return
        }

        if gestureRecognizer.state == .began {
            return
        }

        if gestureRecognizer.state == .changed {
            let translation = gestureRecognizer.translation(in: superview)
            var offset: CGFloat = 0.0

            if isMenuOpen {
                offset = min(translation.x, slack)
            } else {
                offset = min(translation.x - self.menuWidth, slack)
            }

            self.leftMenuConstraint.constant = offset
        }

        if gestureRecognizer.state == .ended {
            let translation = gestureRecognizer.translation(in: superview)
            let offset = min(translation.x - self.menuWidth, slack)

            if offset > -100 {
                self.show()
            } else {
                self.hide()
            }
        }

    }

}

extension MenuController: UITableViewDataSource, UITableViewDelegate {
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItems.count
    }

    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)

        let menuItem = self.menuItems[indexPath.row]
        self.onMenuItemSelected(menuItem)
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "menu-item") as! HamburgerMenuItem
        let menuItem = menuItems[indexPath.row]
        cell.titleLabel.text = menuItem.rawValue

        return cell
    }

    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

}

