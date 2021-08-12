//
//  WeatherService.swift
//  AppleWeather_Clone
//
//  Created by Thisisme Hi on 2021/08/12.
//

import Foundation
import Moya

enum WeatherService {
    case weather(param: WeatherRequest)
}

extension WeatherService: TargetType {
    public var baseURL: URL {
        return URL(string: GeneralAPI.baseURL)!
    }

    var path: String {
        switch self {
        case .weather:
            return "/onecall"
        }
    }

    var method: Moya.Method {
        switch self {
        case .weather:
            return .get
        }
    }

    var sampleData: Data {
        return "@@".data(using: .utf8)!
    }

    var task: Task {
        switch self {
        case .weather(let param):
            return .requestParameters(parameters: try! param.asDictionary(), encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        switch self {
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
