//
//  WeatherHeaderView.swift
//  WeatherDashboardTemplate
//
//  Created by Dulneth Bernard on 06/01/2026.
//

import SwiftUI

// 1. Header (City Name + Date)
struct WeatherHeaderView: View {
    let name: String
    let offset: Int
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM"
        formatter.timeZone = TimeZone(secondsFromGMT: offset)
        return formatter.string(from: Date())
    }
    
    var body: some View {
        HStack {
            Text(name).font(.largeTitle).bold().foregroundColor(.white)
            Spacer()
            Text(dateString).font(.title3).foregroundColor(.white.opacity(0.8))
        }
    }
}

// 2. Main Temperature Display
struct MainWeatherDisplayView: View {
    let temp: Double
    let description: String
    let icon: String
    let high: Double
    let low: Double
    
    var body: some View {
        VStack(spacing: 5) {
            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(icon)@4x.png")) { img in
                img.resizable().scaledToFit()
            } placeholder: { ProgressView() }
            .frame(width: 120, height: 120)
            
            Text("\(Int(round(temp)))°C").font(.system(size: 70, weight: .bold)).foregroundColor(.white)
            Text(description.capitalized).font(.title2).foregroundColor(.white.opacity(0.9))
            HStack {
                Text("H: \(Int(round(high)))°")
                Text("L: \(Int(round(low)))°")
            }.font(.headline).foregroundColor(.white)
        }
    }
}

// 3. Grid Details
struct WeatherDetailsGrid: View {
    let pressure: Int
    let sunrise: Int
    let sunset: Int
    let offset: Int
    
    func time(_ ts: Int) -> String {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        f.timeZone = TimeZone(secondsFromGMT: offset)
        return f.string(from: Date(timeIntervalSince1970: TimeInterval(ts)))
    }
    
    var body: some View {
        HStack(spacing: 30) {
            DetailItem(icon: "gauge", title: "Pressure", value: "\(pressure) hPa")
            DetailItem(icon: "sunrise.fill", title: "Sunrise", value: time(sunrise))
            DetailItem(icon: "sunset.fill", title: "Sunset", value: time(sunset))
        }
        .padding().background(Color.white.opacity(0.2)).cornerRadius(15)
    }
}

struct DetailItem: View {
    let icon: String, title: String, value: String
    var body: some View {
        VStack {
            Image(systemName: icon).font(.title2)
            Text(title).font(.caption)
            Text(value).font(.headline)
        }.foregroundColor(.white)
    }
}
