//
//  WeatherManager.swift
//  weatherForecast
//
//  Created by Luka Zecevic on 3.11.21..
//

import UIKit

protocol WeatherModelDelegate {
    func didUpdateWeather(weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager{
    
    let baseUrl = "https://api.openweathermap.org/data/2.5/weather?units=metric&"
    
    static var token = "b97e74f1fb80ce02aeec74f5f0614f04"
    
    var delegate:WeatherModelDelegate?
    
    
    func fetchWeather(city: String)  {
        let url = baseUrl + "appid=" + WeatherManager.token + "&q=" + city
        performRequest(urlString: url)
    }
    
    func performRequest(urlString: String)  {
       
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{
                    if let weather = self.parseJson(data: safeData) {
                        self.delegate?.didUpdateWeather(weather: weather)
                    }
                }
            }
            task.resume()
        
        }
    }
    
    func parseJson(data:Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: data)
           return WeatherModel(conditionId: decodedData.weather[0].id, cityName: decodedData.name, temperature: decodedData.main.temp)
        }catch{
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
}
