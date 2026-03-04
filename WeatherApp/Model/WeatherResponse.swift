//import Foundation
//
//struct WeatherResponse: Codable {
//    let lat, lon: Double
//    let timezone: String
//    let timezoneOffset: Int
//    let current: Current
//    let daily: [Daily]
//    
//    enum CodingKeys: String, CodingKey {
//        case lat, lon, timezone
//        case timezoneOffset = "timezone_offset"
//        case current, daily
//    }
//}
//
//struct Current: Codable {
//    let dt, sunrise, sunset: Int
//    let temp, feelsLike: Double
//    let pressure, humidity: Int
//    let dewPoint: Double
//    let uvi, clouds, visibility: Int
//    let windSpeed: Double
//    let windDeg: Int
//    let weather: [Weather]
//    
//    enum CodingKeys: String, CodingKey {
//        case dt, sunrise, sunset, temp
//        case feelsLike = "feels_like"
//        case pressure, humidity
//        case dewPoint = "dew_point"
//        case uvi, clouds, visibility
//        case windSpeed = "wind_speed"
//        case windDeg = "wind_deg"
//        case weather
//    }
//}
//
//struct Weather: Codable {
//    let id: Int
//    let main, description, icon: String
//}
//
//struct Daily: Codable {
//    let dt, sunrise, sunset, moonrise: Int
//    let moonset: Int
//    let moonPhase: Double
//    let summary: String
//    let temp: Temp
//    let feelsLike: FeelsLike
//    let pressure, humidity: Int
//    let dewPoint, windSpeed: Double
//    let windDeg: Int
//    let windGust: Double
//    let weather: [Weather]
//    let clouds: Int
//    let pop, uvi: Double
//    let rain: Double?
//    
//    enum CodingKeys: String, CodingKey {
//        case dt, sunrise, sunset, moonrise, moonset
//        case moonPhase = "moon_phase"
//        case summary, temp
//        case feelsLike = "feels_like"
//        case pressure, humidity
//        case dewPoint = "dew_point"
//        case windSpeed = "wind_speed"
//        case windDeg = "wind_deg"
//        case windGust = "wind_gust"
//        case weather, clouds, pop, uvi, rain
//    }
//}
//
//
//struct FeelsLike: Codable {
//    let day, night, eve, morn: Double
//}
//
//struct Temp: Codable {
//    let day, min, max, night: Double
//    let eve, morn: Double
//}
//

import Foundation

// MARK: - WeatherResponse
struct WeatherResponse: Codable {
    let lat, lon: Double
    let timezone: String
    let timezoneOffset: Int
    let current: Current
    let daily: [Daily]

    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset = "timezone_offset"
        case current, daily
    }
}

// MARK: - Current
struct Current: Codable {
    let dt: Int
    let sunrise, sunset: Int?
    let temp, feelsLike: Double
    let pressure, humidity: Int
    let uvi: Double // Changed to Double to match API decimal values
    let clouds, visibility: Int
    let windSpeed: Double
    let weather: [Weather]

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity, uvi, clouds, visibility
        case windSpeed = "wind_speed"
        case weather
    }
}

// MARK: - Daily
struct Daily: Codable {
    let dt, sunrise, sunset: Int
    let summary: String? // Optional: API might not always return this
    let temp: Temp
    let pressure, humidity: Int
    let weather: [Weather]
    let pop: Double // Probability of precipitation
    let uvi: Double
    let rain: Double? // Optional: Only present if it is raining

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, summary, temp, pressure, humidity, weather, pop, uvi, rain
    }
}

// MARK: - Temp
struct Temp: Codable {
    let day, min, max, night, eve, morn: Double
}

// MARK: - Weather
struct Weather: Codable, Identifiable {
    let id: Int
    let main, description, icon: String
}
