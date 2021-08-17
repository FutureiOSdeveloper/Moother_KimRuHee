//
//  UILabel + Extension.swift
//  AppleWeather_Clone
//
//  Created by Thisisme Hi on 2021/07/30.
//

import UIKit

extension UILabel {
    func getShadow() {
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.masksToBounds = false
    }

    func setHighlighted(_ text: String, with search: String) {
        let attributedText = NSMutableAttributedString(string: text)
        let range = NSString(string: text).range(of: search, options: .caseInsensitive)
        let highlightFont = UIFont.systemFont(ofSize: 14)
        let highlightColor = UIColor.white
        let highlightedAttributes: [NSAttributedString.Key: Any] = [ NSAttributedString.Key.font: highlightFont, NSAttributedString.Key.foregroundColor: highlightColor]
        
        attributedText.addAttributes(highlightedAttributes, range: range)
        self.attributedText = attributedText
    }
}
