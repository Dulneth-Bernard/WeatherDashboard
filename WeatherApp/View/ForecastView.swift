//
//  ForecastView.swift
//  WeatherDashboardTemplate
//
//  Created by girish lukka on 18/10/2025.
//


import SwiftUI
import Charts
import SwiftData

enum TempCategory: String, CaseIterable {
    case cold = "Cold"
    case mild = "Mild"
    case warm = "Warm"
    case hot  = "Hot"
    
    var color: Color {
        switch self {
        case .cold: return .blue
        case .mild: return .cyan
        case .warm: return .orange
        case .hot:  return .red
        }
    }
    
    static func from(tempC: Double) -> TempCategory {
        switch tempC {
        case ..<10: return .cold
        case 10..<20: return .mild
        case 20..<30: return .warm
        default: return .hot
        }
    }
}

// MARK: - Temperature Data Model
struct TempData: Identifiable {
    let id = UUID()
    let dayName: String
    let min: Double
    let max: Double
    let category: TempCategory
}

struct ForecastView: View {
    @EnvironmentObject var vm: MainAppViewModel
  

    private var chartData: [TempData] {
        guard let daily = vm.weatherResponse?.daily else { return [] }
        
        return daily.prefix(8).map { day in
            // Create a short day label
            let date = Date(timeIntervalSince1970: TimeInterval(day.dt))
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE"
            let dayName = formatter.string(from: date)
            
            return TempData(
                dayName: dayName,
                min: day.temp.min,
                max: day.temp.max,
                category: TempCategory.from(tempC: day.temp.max)
            )
        }
    }
    
    var body: some View {
        ZStack {

            
            vm.weatherCategory.backgroundGradient.ignoresSafeArea()
            VStack(spacing: 0) {
                
                // Chart Molecule
                if !chartData.isEmpty {
                    ForecastChart(data: chartData)
                        .padding(.top)
                        .padding(.bottom, 10)
                }
                
                //  List Section
                if let daily = vm.weatherResponse?.daily {
                    List {
                        ForEach(daily.prefix(8), id: \.dt) { day in
                            DailyForecastRow(day: day)
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                } else {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
        }
        .navigationTitle("Forecast")
    }
}

#Preview {
    let vm = PreviewDependencies.makePreviewViewModel()
    ForecastView()
        .environmentObject(vm)
}
