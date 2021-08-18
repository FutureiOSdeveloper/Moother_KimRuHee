//
//  WeatherRequest.swift
//  AppleWeather_Clone
//
//  Created by Thisisme Hi on 2021/08/12.
//

import Foundation

struct WeatherRequest: Codable {
    var lat: Double
    var lon: Double
    var appid: String
    var exclude: String
    var units: String
    var lang: String
    
    init(_ lat: Double, _ lon: Double, _ exclude: String) {
        self.lat = lat
        self.lon = lon
        self.appid = GeneralAPI.appid
        self.exclude = exclude
        self.units = "metric"
        self.lang = "kr"
    }
}
