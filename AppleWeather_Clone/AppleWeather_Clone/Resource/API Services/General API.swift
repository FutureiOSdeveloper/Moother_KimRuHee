//
//  General API.swift
//  AppleWeather_Clone
//
//  Created by Thisisme Hi on 2021/08/05.
//

import Foundation

struct GeneralAPI {
    static let shared = GeneralAPI()
    
    let baseURL = "https://api.openweathermap.org/data/2.5/weather?appid=cea1d8866a0ca2c205c2b5e2a30f160c&units=metric"
    
    func getMyWeather(lat: Double, lon: Double) {
        _ = "\(baseURL)&lat=\(lat)&lon=\(lon)"
    }
    
    func getCityWeather(cityName: String) {
        _ = "\(baseURL)&q=\(cityName)"
    }
}
