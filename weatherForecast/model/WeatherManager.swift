//
//  WeatherManager.swift
//  weatherForecast
//
//  Created by Luka Zecevic on 3.11.21..
//

import UIKit

protocol WeatherModelDelegate {
    func didUpdateWeather(weather: WeatherModel)
    func didUpdateForecast(forecast: [WeatherModel])
    func didFailWithError(error: Error)
}

struct WeatherManager{
    
    let baseUrlWeather = "https://api.openweathermap.org/data/2.5/weather?units=metric&"
    let baseUrlForecast = "https://api.openweathermap.org/data/2.5/forecast?units=metric&"
    
    //this is my token, you can use your own
    static var token = ""
    
    var delegate:WeatherModelDelegate?
    
    
    func fetchWeather(city: String)  {
        let url = baseUrlWeather + "appid=" + WeatherManager.token + "&q=" + city
        performRequestWeather(urlString: url)
        let urlForecast = baseUrlForecast + "appid=" + WeatherManager.token + "&q=" + city
        performRequestForecast(urlString: urlForecast)
    }
    
    
    func performRequestWeather(urlString: String)  {
       
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{
                    if let weather = self.parseJsonWeather(data: safeData) {
                        self.delegate?.didUpdateWeather(weather: weather)
                    }
                }
            }
            task.resume()
        
        }
    }
    
    func performRequestForecast(urlString: String)  {
       
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{
                    if let forecast = self.parseJsonForecast(data: safeData) {
                        self.delegate?.didUpdateForecast(forecast: forecast)
                    }
                }
            }
            task.resume()
        
        }
    }
    
    
    func parseJsonWeather(data:Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: data)
            return WeatherModel(conditionId: decodedData.weather[0].id, cityName: decodedData.name!, temperature: decodedData.main.temp,dateTxt: "")
        }catch{
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    func parseJsonForecast(data:Data) -> [WeatherModel]? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(Forecast.self, from: data)
            var dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            var weathers:[WeatherModel] = []
            var lastOne:WeatherData?
            for weather in decodedData.list {
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let date = dateFormatter.date(from: weather.dt_txt!)!
                var dateLast=Date()
                var dayLast = ""
                if lastOne != nil {
                    dateLast = dateFormatter.date(from: lastOne!.dt_txt!)!
                    dateFormatter.dateFormat = "dd"
                    dayLast = dateFormatter.string(from: dateLast)
                }
                dateFormatter.dateFormat = "dd"
                let day = dateFormatter.string(from: date)
                let calendar = Calendar.current
                let dayToday = calendar.component(.day, from: date)
                if lastOne == nil || (day != String(dayToday) && lastOne != nil && dayLast != day) {
                    weathers.append(WeatherModel(conditionId: weather.weather[0].id, cityName: "", temperature: weather.main.temp,dateTxt: weather.dt_txt!))
                }
                lastOne = weather
               
            }
            
            return weathers
        }catch{
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
