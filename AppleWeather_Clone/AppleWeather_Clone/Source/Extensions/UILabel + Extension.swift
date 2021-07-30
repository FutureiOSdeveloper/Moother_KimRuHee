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
}
