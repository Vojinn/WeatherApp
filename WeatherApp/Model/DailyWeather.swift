//
//  DailyWeather.swift
//  WeatherApp
//
//  Created by Dusan Vojinovic on 25.1.22..
//

import Foundation

struct DailyWeather: Codable {
    
    let list: [List]
}

struct List: Codable {
    let main: Main
    let weather: [Weather]
    let dt_txt: String
}


