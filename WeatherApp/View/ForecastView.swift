//
//  ForecastView.swift
//  WeatherDashboardTemplate
//
//  Created by girish lukka on 18/10/2025.
//

import SwiftData

//
//
import SwiftUI
import Charts   // Include if you plan to show a chart later
//
//// MARK: - Temperature Category
///// Example of how to categorize temperatures for display.
///// Add more cases or adjust logic as needed.
//enum TempCategory: String, CaseIterable {
//    case cold = "Cold"   // Example category
//    
//    /// Choose a color to represent this category.
//    var color: Color {
//        switch self {
//        case .cold:
//            return .blue
//            // TODO: add more cases (e.g., .cool, .warm, .hot) with colors as needed
//        }
//    }
//    
//    /// Convert a Celsius temperature into a category.
//    static func from(tempC: Double) -> TempCategory {
//        if tempC <= 0 {
//            return .cold
//        }
//        // TODO: add more logic for other ranges (cool, warm, hot)
//        return .cold
//    }
//}
//
//// MARK: - Temperature Data Model
///// A single temperature reading for the chart or list.
//private struct TempData: Identifiable {
//    let id = UUID()
//    let time: Date          // e.g., forecast date
//    let type: String        // e.g., "High" or "Low"
//    let value: Double       // numeric value
//    let category: TempCategory
//}
//
//// MARK: - Forecast View
///// Stubbed Forecast View that includes an image placeholder to show
///// what the final view will look like. Replace the image once real data and charts are added.
//struct ForecastView: View {
//    @EnvironmentObject var vm: MainAppViewModel
//    
//    /// Converts forecast data into chart-friendly entries.
//    private var chartData: [TempData] {
//        vm.forecast.flatMap { day in
//            [
//                // These are hard-wired data, real data will come from weather data fetched by your api
//                
//                TempData(
//                    time: Date(),
//                    type: "High",
//                    value: 24.5,
//                    category: .from(tempC: 24.5)
//                ),
//                TempData(
//                    time: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
//                    type: "High",
//                    value: 19.0,
//                    category: .from(tempC: 19.0)
//                ),
//                TempData(
//                    time: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
//                    type: "High",
//                    value: 5.5,
//                    category: .from(tempC: 5.5)
//                )
//                // TODO: add a "Low" entry or other data points if needed
//            ]
//        }
//    }
//    
//    var body: some View {
//        VStack {
//            // MARK: - Header Text
//            Text("Image shows the information to be presented in this view")
//                .font(.headline)
//                .multilineTextAlignment(.center)
//                .padding(.top)
//            
//            Spacer()
//            
//            // MARK: - Placeholder Image
//            // Replace "forecast" with the name of your image asset.
//            // You can add your actual design or a wireframe image in Assets.xcassets.
//            Image("forecast")
//                .resizable()
//                .scaledToFit()
//                .frame(maxWidth: .infinity)
//                .cornerRadius(12)
//                .shadow(radius: 5)
//                .padding()
//            
//            Spacer()
//        }
//        .frame(height: 600)
//        .background(
//            LinearGradient(
//                gradient: Gradient(colors: [.indigo.opacity(0.1), .blue.opacity(0.05)]),
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            )
//        )
//        .clipShape(RoundedRectangle(cornerRadius: 20))
//        .padding()
//        .navigationTitle("Forecast")
//    }
//}

//#Preview {
//    let vm = MainAppViewModel(context: ModelContext(ModelContainer.preview))
//    ForecastView()
//        .environmentObject(vm)
//}


// MARK: - Temperature Category
//enum TempCategory: String, CaseIterable {
//    case freezing
//    case cold
//    case mild
//    case warm
//    case hot
//
//    var color: Color {
//        switch self {
//        case .freezing: return .blue
//        case .cold:     return .cyan
//        case .mild:     return .green
//        case .warm:     return .orange
//        case .hot:      return .red
//        }
//    }
//
//    static func from(tempC: Double) -> TempCategory {
//        switch tempC {
//        case ..<0: return .freezing
//        case 0..<10: return .cold
//        case 10..<20: return .mild
//        case 20..<28: return .warm
//        default: return .hot
//        }
//    }
//}
//
//// MARK: - Temperature Data Model
//private struct TempData: Identifiable {
//    let id = UUID()
//    let date: Date
//    let minTemp: Double
//    let maxTemp: Double
//    let category: TempCategory
//}
//
//// MARK: - Forecast View
//struct ForecastView: View {
//
//    @EnvironmentObject var vm: MainAppViewModel
//
//    /// Converts real forecast data into chart-friendly entries
//    private var chartData: [TempData] {
//        guard let daily = vm.weatherResponse?.daily else { return [] }
//
//        return daily.prefix(8).map { day in
//            TempData(
//                date: Date(timeIntervalSince1970: TimeInterval(day.dt)),
//                minTemp: day.temp.min,
//                maxTemp: day.temp.max,
//                category: TempCategory.from(tempC: day.temp.max)
//            )
//        }
//    }
//
//    var body: some View {
//        VStack(spacing: 16) {
//
//            // Header
//            Text("8-Day Weather Forecast")
//                .font(.headline)
//                .multilineTextAlignment(.center)
//                .padding(.top)
//
//            // MARK: - Chart
//            Chart(chartData) { item in
//                BarMark(
//                    x: .value("Day", item.date, unit: .day),
//                    y: .value("Max Temp", item.maxTemp)
//                )
//                .foregroundStyle(item.category.color)
//
//                BarMark(
//                    x: .value("Day", item.date, unit: .day),
//                    y: .value("Min Temp", item.minTemp)
//                )
//                .foregroundStyle(item.category.color.opacity(0.5))
//            }
//            .frame(height: 220)
//            .padding(.horizontal)
//
//            // MARK: - Forecast List
//            List(chartData) { item in
//                HStack {
//                    Text(
//                        DateFormatterUtils.formattedDateWithWeekdayAndDay(
//                            from: item.date.timeIntervalSince1970
//                        )
//                    )
//
//                    Spacer()
//
//                    Text("\(Int(item.minTemp))° / \(Int(item.maxTemp))°")
//                        .fontWeight(.medium)
//                }
//            }
//        }
//        .background(
//            LinearGradient(
//                colors: [.indigo.opacity(0.1), .blue.opacity(0.05)],
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            )
//        )
//        .navigationTitle("Forecast")
//    }
//}

// MARK: - Preview
//#Preview {
//    let vm = MainAppViewModel(context: ModelContext(ModelContainer.preview), networkService: new NetworkService())
//    ForecastView()
//        .environmentObject(vm)
//}


import SwiftUI
import Charts
import SwiftData

struct ForecastView: View {
    @EnvironmentObject var vm: MainAppViewModel

    // Reusable Gradient
    var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [Color(red: 0.74, green: 0.82, blue: 0.95), Color(red: 0.98, green: 0.85, blue: 0.80)],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    var body: some View {
        ZStack {
            // 1. Global Gradient Background
            backgroundGradient.ignoresSafeArea()

            VStack(spacing: 16) {
                Text("8-Day Forecast")
                    .font(.headline)
                    .padding(.top)

                // Chart Container
                if let daily = vm.weatherResponse?.daily {
                    Chart {
                        ForEach(daily.prefix(8), id: \.dt) { day in
                            let date = Date(timeIntervalSince1970: TimeInterval(day.dt))
                            BarMark(
                                x: .value("Day", date, unit: .day),
                                yStart: .value("Min", day.temp.min),
                                yEnd: .value("Max", day.temp.max)
                            )
                            .foregroundStyle(gradientFor(temp: day.temp.max))
                            .cornerRadius(4)
                        }
                    }
                    .chartYAxis { AxisMarks(position: .leading) }
                    .frame(height: 220)
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)
                }

                // Scrollable List
                List {
                    if let daily = vm.weatherResponse?.daily {
                        ForEach(daily.prefix(8), id: \.dt) { day in
                            HStack {
                                Text(DateFormatterUtils.formattedDateWithWeekdayAndDay(from: TimeInterval(day.dt)))
                                    .fontWeight(.medium)
                                Spacer()
                                if let icon = day.weather.first?.icon {
                                    AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(icon).png"))
                                        .frame(width: 30, height: 30)
                                }
                                Text("\(Int(day.temp.min))° - \(Int(day.temp.max))°")
                                    .foregroundStyle(.secondary)
                            }
                            .listRowBackground(Color.clear) // IMPORTANT: Transparent row
                            .listRowSeparator(.visible)
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden) // IMPORTANT: Transparent List
            }
        }
        .navigationTitle("Forecast")
    }

    func gradientFor(temp: Double) -> LinearGradient {
        let color: Color = temp < 10 ? .blue : (temp > 25 ? .orange : .green)
        return LinearGradient(colors: [color.opacity(0.8), color.opacity(0.3)], startPoint: .bottom, endPoint: .top)
    }
}
