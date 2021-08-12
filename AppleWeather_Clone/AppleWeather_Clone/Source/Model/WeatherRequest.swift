//
//  WeatherRequest.swift
//  AppleWeather_Clone
//
//  Created by Thisisme Hi on 2021/08/12.
//

import Foundation

struct WeatherRequest: Codable {
    var latitude: Double
    var longtitude: Double
    var exclude: String
    
    init(_ latitude: Double, _ longtitude: Double, _ exclude: String) {
        self.latitude = latitude
        self.longtitude = longtitude
        self.exclude = exclude
    }
}
