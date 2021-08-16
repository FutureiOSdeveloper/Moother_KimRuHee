//
//  UIView + Extenison.swift
//  AppleWeather_Clone
//
//  Created by Thisisme Hi on 2021/07/24.
//

import UIKit

import Lottie

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
}

