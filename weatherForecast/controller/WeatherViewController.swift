//
//  ViewController.swift
//  weatherForecast
//
//  Created by Luka Zecevic on 3.11.21..
//

import UIKit

class WeatherViewController: UIViewController,UITextFieldDelegate,WeatherModelDelegate,UITableViewDataSource {
    
    
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    
    var forecast:[WeatherModel] = []
    var weatherManager = WeatherManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        weatherManager.delegate = self
        tableView.dataSource = self
        weatherManager.fetchWeather(city: "Belgrade")
    }

    @IBAction func searchPressed(_ sender: Any) {
        searchTextField.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text == ""{
            return false
        }
        return true
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(city: city)
        }
       
        searchTextField.text = ""
    }
    
    func didUpdateWeather(weather: WeatherModel) {
        DispatchQueue.main.async {
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = weather.temperatureString
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
    func didUpdateForecast(forecast: [WeatherModel]) {
        self.forecast = forecast
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        cell?.textLabel?.text = forecast[indexPath.row].date
        cell?.detailTextLabel?.text = forecast[indexPath.row].temperatureString + "°C"
        
        return cell!
    }
}

