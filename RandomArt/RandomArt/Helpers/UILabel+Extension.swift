//
//  UILabel+Extension.swift
//  RandomArt
//
//  Created by Cora Jacobson on 6/17/21.
//

import UIKit

extension UILabel {
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
