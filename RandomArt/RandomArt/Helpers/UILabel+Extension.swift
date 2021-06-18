//
//  UILabel+Extension.swift
//  RandomArt
//
//  Created by Cora Jacobson on 6/17/21.
//

import UIKit

extension UILabel {
    /// sets up a UILabel with text and style, and adds it the view with right and left constraints to center in view with 30 point margins
    /// - Parameters:
    ///   - textString: accepts an optional text String; default is ""
    ///   - fontName: accepts an optional  font name; default is Optima-Regular
    ///   - fontSize: accepts an optional font size; default is 18
    ///   - color: accepts an optional UIColor; default is .black
    ///   - view: accepts the UIView to which the label is being added
    func setUpLabel(textString: String = "", fontName: String = Fonts.optimaReg.rawValue, fontSize: CGFloat = 18, color: UIColor = .black, view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        text = textString
        numberOfLines = 0
        textAlignment = .center
        textColor = color
        font = UIFont(name: fontName, size: fontSize)
        view.addSubview(self)
        leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
    }
}
