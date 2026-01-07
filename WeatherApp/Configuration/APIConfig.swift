//
//  ApiConfig.swift
//  WeatherApp
//
//  Created by Dulneth Bernard on 30/12/2025.
//

struct APIConfig {
    static let weatherBaseURL: String = "https://api.openweathermap.org/data/3.0/onecall"
    static let weatherAPIKey: String = "b9d7a17db9c57ef512795e4ff7a6c4ec"
    static func getWeatherURL(lat: Double, lon: Double) -> String {
        "\(weatherBaseURL)?lat=\(lat)&lon=\(lon)&appid=\(weatherAPIKey)&units=metric"
    }
}
