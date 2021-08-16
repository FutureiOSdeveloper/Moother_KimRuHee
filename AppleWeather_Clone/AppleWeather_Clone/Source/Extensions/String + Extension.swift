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
    
    func convertIcon() -> String {
        switch self {
        case "01d":
            return "sun.max.fill"
        case "01n":
            return "moon.stars.fill"
        case "02d":
            return "cloud.sun.fill"
        case "02n":
            return "cloud.moon.fill"
        case "03d":
            return "cloud.fill"
        case "03n":
            return "cloud.fill"
        case "04d":
            return "smoke.fill"
        case "04n":
            return "smoke.fill"
        case "09d":
            return "cloud.rain.fill"
        case "09n":
            return "cloud.rain.fill"
        case "10d":
            return "cloud.sun.rain.fill"
        case "10n":
            return "cloud.moon.rain.fill"
        case "11d":
            return "cloud.bolt.fill"
        case "11n":
            return "cloud.bolt.fill"
        case "13d":
            return "cloud.snow.fill"
        case "13n":
            return "cloud.snow.fill"
        case "50d":
            return "cloud.fog.fill"
        case "50n":
            return "cloud.fog.fill"
        default:
            return "sun.max.fill"
        }
    }
    
    func convertLottie() -> String {
        switch self {
        case "맑음":
            return "4804-weather-sunny"
        case "보통 비":
            return "4803-weather-storm"
        case "실 비":
            return "4803-weather-storm"
        case "온흐림":
            return "4806-weather-windy"
        case "튼구름":
            return "4806-weather-windy"
        default:
            return "4800-weather-partly-cloudy"
        }
    }
}
