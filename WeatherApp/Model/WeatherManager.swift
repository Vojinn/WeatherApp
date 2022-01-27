//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Dusan Vojinovic on 25.1.22..
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

protocol DailyWeatherManagerDelegate {
    func didUpdateDailyWeather(_ weatherManager: WeatherManager, weather: [DailyWeatherModel])
    func didFailWithErrorDaily(error: Error)
}


struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=d92073ab352d40c0d6b0a20e9aaf6f36&units=metric"
    let dailyWeatherURL = "https://api.openweathermap.org/data/2.5/forecast?&appid=d92073ab352d40c0d6b0a20e9aaf6f36&units=metric"
    
    var delegate: WeatherManagerDelegate?
    var dailyDelegate: DailyWeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        let urlString2 = "\(dailyWeatherURL)&q=\(cityName)"
        performRequest(with: urlString)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            performDailyRequest(with: urlString2)
        }
    }
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        let urlString2 = "\(dailyWeatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            performDailyRequest(with: urlString2)
        }
        
    }
    
    func performRequest(with urlString: String) {
        
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func performDailyRequest(with urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.dailyDelegate?.didFailWithErrorDaily(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSONDaily(safeData){
                        self.dailyDelegate?.didUpdateDailyWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }

    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    func parseJSONDaily(_ weatherData: Data) -> [DailyWeatherModel]? {
        let decoder = JSONDecoder()
        var arrayOfDailyWeather = [DailyWeatherModel]()
        do {
            let decodedData = try decoder.decode(DailyWeather.self, from: weatherData)
            for index in stride(from: 0, to: 40, by: 8) {
                let id = decodedData.list[index].weather[0].id
                let min = decodedData.list[index].main.temp_min
                let max = decodedData.list[index].main.temp_max
                let danUNedelji = decodedData.list[index].dt_txt
                
                let weather = DailyWeatherModel(dayOfWeek: danUNedelji, conditionId: id, temperatureMin: min, temperatureMax: max)
                arrayOfDailyWeather.append(weather)
            }
            return arrayOfDailyWeather
        }catch {
            dailyDelegate?.didFailWithErrorDaily(error: error)
            return nil
        }
    }
    
}
