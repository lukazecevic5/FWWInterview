//
//  WeatherData.swift
//  weatherForecast
//
//  Created by Luka Zecevic on 3.11.21..
//

import Foundation

struct WeatherData: Decodable {
    let name:String
    let main:MainWeatherData
    let weather:[RealWeatherData]
}
struct MainWeatherData: Decodable {
    let temp:Double
}
struct RealWeatherData:Decodable {
    let id:Int
}
