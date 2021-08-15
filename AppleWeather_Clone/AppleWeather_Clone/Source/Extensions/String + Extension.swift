//
//  String + Extension.swift
//  AppleWeather_Clone
//
//  Created by Thisisme Hi on 2021/08/13.
//

import Foundation

extension String {
    func stringFromDate() -> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(Double(self)!))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a hh:mm"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date as Date)
    }
}
