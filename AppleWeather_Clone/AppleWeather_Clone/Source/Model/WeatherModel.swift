//
//  WeatherModel.swift
//  AppleWeather_Clone
//
//  Created by Thisisme Hi on 2021/08/04.
//

import Foundation

// MARK: - WeatherModel
struct WeatherModel: Codable {
    let lat, lon: Double
    let timezone: String
    let timezoneOffset: Int
    let current: Current
    let minutely: [Minutely]
    let hourly: [Current]
    let daily: [Daily]
    let alerts: Alert?

    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset = "timezone_offset"
        case current, minutely, hourly, daily, alerts
    }
    
    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        lat = (try? value.decode(Double.self, forKey: .lat)) ?? 0
        lon = (try? value.decode(Double.self, forKey: .lon)) ?? 0
        timezone = (try? value.decode(String.self, forKey: .timezone)) ?? ""
        timezoneOffset = (try? value.decode(Int.self, forKey: .timezoneOffset)) ?? 0
        current = (try value.decode(Current.self, forKey: .current))
        minutely = (try? value.decode([Minutely].self, forKey: .minutely)) ?? []
        hourly = (try? value.decode([Current].self, forKey: .hourly)) ?? []
        daily = (try? value.decode([Daily].self, forKey: .daily)) ?? []
        alerts = (try? value.decode(Alert.self, forKey: .alerts))
    }
}

// MARK: - WeatherModel
struct Current: Codable {
    let dt: Int
    let sunrise, sunset: Int?
    let temp, feelsLike: Double
    let pressure, humidity: Int
    let dewPoint, uvi: Double
    let clouds, visibility: Int
    let windSpeed: Double
    let windDeg: Int
    let windGust: Double
    let weather: [Weather]
    let rain: Rain?
    let pop: Double?
    
    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi, clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather, rain, pop
    }
    
    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        dt = (try? value.decode(Int.self, forKey: .dt)) ?? 0
        sunrise = (try? value.decode(Int.self, forKey: .sunrise)) ?? 0
        sunset = (try? value.decode(Int.self, forKey: .sunset)) ?? 0
        temp = (try? value.decode(Double.self, forKey: .temp)) ?? 0
        feelsLike = (try? value.decode(Double.self, forKey: .feelsLike)) ?? 0
        pressure = (try? value.decode(Int.self, forKey: .pressure)) ?? 0
        humidity = (try? value.decode(Int.self, forKey: .humidity)) ?? 0
        dewPoint = (try? value.decode(Double.self, forKey: .dewPoint)) ?? 0
        uvi = (try? value.decode(Double.self, forKey: .uvi)) ?? 0
        clouds = (try? value.decode(Int.self, forKey: .clouds)) ?? 0
        visibility = (try? value.decode(Int.self, forKey: .visibility)) ?? 0
        windSpeed = (try? value.decode(Double.self, forKey: .windSpeed)) ?? 0
        windDeg = (try? value.decode(Int.self, forKey: .windDeg)) ?? 0
        windGust = (try? value.decode(Double.self, forKey: .windGust)) ?? 0
        weather = (try value.decode([Weather].self, forKey: .weather))
        rain = (try? value.decode(Rain.self, forKey: .rain))
        pop = (try? value.decode(Double.self, forKey: .pop)) ?? 0
    }
}

// MARK: - Rain
struct Rain: Codable {
    let the1H: Double

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
    
    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        the1H = (try? value.decode(Double.self, forKey: .the1H)) ?? 0
    }
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main: String
    let weatherDescription: String
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
    
    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        id = (try? value.decode(Int.self, forKey: .id)) ?? 0
        main = (try? value.decode(String.self, forKey: .main)) ?? "Clear"
        weatherDescription = (try? value.decode(String.self, forKey: .weatherDescription)) ?? "맑음"
        icon = (try? value.decode(String.self, forKey: .icon)) ?? ""
    }
}

enum Icon: String, Codable {
    case the01D = "01d"
    case the04D = "04d"
    case the04N = "04n"
    case the10D = "10d"
    case the10N = "10n"
}

enum Main: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
}

enum Description: String, Codable {
    case 맑음 = "맑음"
    case 보통비 = "보통 비"
    case 실비 = "실 비"
    case 온흐림 = "온흐림"
    case 튼구름 = "튼구름"
}

// MARK: - Daily
struct Daily: Codable {
    let dt, sunrise, sunset, moonrise: Int
    let moonset: Int
    let moonPhase: Double
    let temp: Temp
    let feelsLike: FeelsLike
    let pressure, humidity: Int
    let dewPoint, windSpeed: Double
    let windDeg: Int
    let windGust: Double
    let weather: [Weather]
    let clouds: Int
    let pop: Double
    let rain: Double?
    let uvi: Double
    
    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, moonrise, moonset
        case moonPhase = "moon_phase"
        case temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather, clouds, pop, rain, uvi
    }
    
    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        dt = (try? value.decode(Int.self, forKey: .dt)) ?? 0
        sunrise = (try? value.decode(Int.self, forKey: .sunrise)) ?? 0
        sunset = (try? value.decode(Int.self, forKey: .sunset)) ?? 0
        moonrise = (try? value.decode(Int.self, forKey: .moonrise)) ?? 0
        moonset = (try? value.decode(Int.self, forKey: .moonset)) ?? 0
        moonPhase = (try? value.decode(Double.self, forKey: .moonPhase)) ?? 0
        temp = (try value.decode(Temp.self, forKey: .temp))
        pressure = (try? value.decode(Int.self, forKey: .pressure)) ?? 0
        humidity = (try? value.decode(Int.self, forKey: .humidity)) ?? 0
        dewPoint = (try? value.decode(Double.self, forKey: .dewPoint)) ?? 0
        uvi = (try? value.decode(Double.self, forKey: .uvi)) ?? 0
        clouds = (try? value.decode(Int.self, forKey: .clouds)) ?? 0
        windSpeed = (try? value.decode(Double.self, forKey: .windSpeed)) ?? 0
        windDeg = (try? value.decode(Int.self, forKey: .windDeg)) ?? 0
        windGust = (try? value.decode(Double.self, forKey: .windGust)) ?? 0
        weather = (try value.decode([Weather].self, forKey: .weather))
        pop = (try? value.decode(Double.self, forKey: .pop)) ?? 0
        feelsLike = (try value.decode(FeelsLike.self, forKey: .feelsLike))
        rain = (try? value.decode(Double.self, forKey: .rain)) ?? 0
    }
}

// MARK: - FeelsLike
struct FeelsLike: Codable {
    let day, night, eve, morn: Double
    
    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        day = (try? value.decode(Double.self, forKey: .day)) ?? 0
        night = (try? value.decode(Double.self, forKey: .night)) ?? 0
        eve = (try? value.decode(Double.self, forKey: .eve)) ?? 0
        morn = (try? value.decode(Double.self, forKey: .morn)) ?? 0
    }
}

// MARK: - Temp
struct Temp: Codable {
    let day, min, max, night: Double
    let eve, morn: Double
    
    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        day = (try? value.decode(Double.self, forKey: .day)) ?? 0
        min = (try? value.decode(Double.self, forKey: .min)) ?? 0
        max = (try? value.decode(Double.self, forKey: .max)) ?? 0
        night = (try? value.decode(Double.self, forKey: .night)) ?? 0
        eve = (try? value.decode(Double.self, forKey: .eve)) ?? 0
        morn = (try? value.decode(Double.self, forKey: .morn)) ?? 0
    }
}

// MARK: - Minutely
struct Minutely: Codable {
    let dt: Int
    let precipitation: Double
    
    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        dt = (try? value.decode(Int.self, forKey: .dt)) ?? 0
        precipitation = (try? value.decode(Double.self, forKey: .precipitation)) ?? 0
    }
}

// MARK: - Alert
struct Alert: Codable {
    let senderName, event: String
    let start, end: Int
    let alertDescription: String
    let tags: [String]

    enum CodingKeys: String, CodingKey {
        case senderName = "sender_name"
        case event, start, end
        case alertDescription = "description"
        case tags
    }
    
    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        senderName = (try? value.decode(String.self, forKey: .senderName)) ?? ""
        event = (try? value.decode(String.self, forKey: .event)) ?? ""
        start = (try? value.decode(Int.self, forKey: .start)) ?? 0
        end = (try? value.decode(Int.self, forKey: .end)) ?? 0
        alertDescription = (try? value.decode(String.self, forKey: .alertDescription)) ?? ""
        tags = (try? value.decode([String].self, forKey: .tags)) ?? []
    }
}

