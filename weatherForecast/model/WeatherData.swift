//
//  WeatherData.swift
//  weatherForecast
//
//  Created by Luka Zecevic on 3.11.21..
//

import Foundation

struct Forecast: Decodable {
    let list:[WeatherData]
}

struct WeatherData: Decodable {
    let name:String?
    let main:MainWeatherData
    let weather:[RealWeatherData]
    let dt_txt:String?
}
struct MainWeatherData: Decodable {
    let temp:Double
}
struct RealWeatherData:Decodable {
    let id:Int
}
