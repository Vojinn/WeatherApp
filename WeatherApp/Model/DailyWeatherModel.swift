//
//  DailyWeatherModel.swift
//  WeatherApp
//
//  Created by Dusan Vojinovic on 26.1.22..
//

import Foundation

struct DailyWeatherModel {
    let dayOfWeek: String
    let conditionId: Int
    let temperatureMin: Double
    let temperatureMax: Double
    
    var temperatureStringMin: String {
        return String(format: "%.1f", temperatureMin)
    }
    var temperatureStringMax: String {
        return String(format: "%.1f", temperatureMax)
    }
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}
