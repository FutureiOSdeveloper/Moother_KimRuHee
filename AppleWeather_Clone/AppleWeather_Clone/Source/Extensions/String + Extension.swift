//
//  String + Extension.swift
//  AppleWeather_Clone
//
//  Created by Thisisme Hi on 2021/08/13.
//

import Foundation

extension String {
    func stringToTime(formatter: String) -> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(Double(self)!))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date as Date)
    }
}
