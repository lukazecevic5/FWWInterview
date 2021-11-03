//
//  WeatherModel.swift
//  weatherForecast
//
//  Created by Luka Zecevic on 3.11.21..
//

import Foundation

struct WeatherModel{
    let conditionId: Int
    let cityName:String
    let temperature:Double
    let dateTxt:String
    
    var date:String{
        if dateTxt=="" {
            return ""
        }else{
            let dateFormatterOld = DateFormatter()
            dateFormatterOld.dateFormat = "yyyy-MM-dd HH:mm:ss"

            let dateFormatterNew = DateFormatter()
            dateFormatterNew.dateFormat = "MMM dd"

            if let date = dateFormatterOld.date(from: dateTxt) {
                return dateFormatterNew.string(from: date)
            } else {
               return ""
            }
        }
    }
    
    var temperatureString: String {
            return String(format: "%.1f", temperature)
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
