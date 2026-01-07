//
//  CurrentWeatherView.swift
//  WeatherDashboardTemplate
//
//  Created by girish lukka on 18/10/2025.
//



//struct CurrentWeatherView: View {
//    @EnvironmentObject var vm: MainAppViewModel
//
//    var body: some View {
//        ZStack {
//            // Background Gradient
//            LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
//                .ignoresSafeArea()
//            
//            if vm.isLoading {
//                ProgressView().tint(.white)
//            } else if let current = vm.currentConditions, let weather = current.weather.first {
//                ScrollView {
//                    VStack(spacing: 20) {
//                        // Header
//                        WeatherHeaderView(name: vm.activePlaceName, offset: vm.timezoneOffset)
//                        
//                        // Main Display (Use Daily forecast for High/Low if available)
//                        let high = vm.forecast.first?.temp.max ?? current.temp
//                        let low = vm.forecast.first?.temp.min ?? current.temp
//                        
//                        MainWeatherDisplayView(
//                            temp: current.temp,
//                            description: weather.description,
//                            icon: weather.icon,
//                            high: high,
//                            low: low
//                        )
//                        
//                        // Details Grid
//                        WeatherDetailsGrid(
//                            pressure: current.pressure,
//                            sunrise: current.sunrise,
//                            sunset: current.sunset,
//                            offset: vm.timezoneOffset
//                        )
//                        
//                        // Advice Box
//                        if let advice = WeatherAdviceCategory.from(temp: current.temp, description: weather.description) as? WeatherAdviceCategory {
//                            HStack {
//                                Image(systemName: advice.icon).font(.largeTitle).foregroundColor(advice.color)
//                                Text(advice.adviceText).foregroundColor(.black)
//                                Spacer()
//                            }
//                            .padding()
//                            .background(Color.white.opacity(0.9))
//                            .cornerRadius(12)
//                        }
//                    }
//                    .padding()
//                }
//            } else {
//                Text("Search for a city to begin").foregroundColor(.white)
//            }
//        }
//        .alert(item: $vm.appError) { error in
//            Alert(title: Text("Error"), message: Text(error.localizedDescription), dismissButton: .default(Text("OK")))
//        }
//                .padding()
//    }
//}

//#Preview {
//    let container = try! ModelContainer(for: , configurations: ModelConfiguration(isStoredInMemoryOnly: true))
//    let vm = MainAppViewModel(networkService: <#any NetworkService#>, context: ModelContext(container))
//    CurrentWeatherView()
//        .environmentObject(vm)
//}


import SwiftUI
import SwiftData

struct CurrentWeatherView: View {

    @EnvironmentObject var vm: MainAppViewModel

    // MARK: - Derived State (View-only)

    private var current: Current? {
        vm.weatherResponse?.current
    }

    private var today: Daily? {
        vm.weatherResponse?.daily.first
    }

    private var adviceCategory: WeatherAdviceCategory {
        guard let current else { return .unknown }
        return WeatherAdviceCategory.from(
            temp: current.temp,
            description: current.weather.first?.description ?? ""
        )
    }

    // MARK: - View

    var body: some View {
        ZStack {
            backgroundGradient
                .ignoresSafeArea()
            
            VStack{
                HStack(spacing: 4) {
                    Text(vm.activePlaceName)
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    Spacer()
                    if let timestamp = current?.dt {
                        Text(
                            DateFormatterUtils.formattedDateTime(
                                from: TimeInterval(timestamp)
                            )
                        )
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    }
                }
                .padding(.top)
            
            VStack(spacing: 20) {
                
                // MARK: - Location & Date
                
//                HStack(spacing: 4) {
//                    Text(vm.activePlaceName)
//                        .font(.largeTitle)
//                        .fontWeight(.semibold)
//                    Spacer()
//                    if let timestamp = current?.dt {
//                        Text(
//                            DateFormatterUtils.formattedDateTime(
//                                from: TimeInterval(timestamp)
//                            )
//                        )
//                        .font(.subheadline)
//                        .foregroundStyle(.secondary)
//                    }
//                }
//                .padding(.top)
                
                Spacer()
                
                // MARK: - Temperature (Hero Section)
                
                if let current {
                    VStack(spacing: 12) {
                        
                        VStack{}
                        
                        
                        HStack{
                            Text("\(Int(current.temp))°")
                                .font(.system(size: 108, weight: .medium))
                                //Avoid getting ttruncation
                                .minimumScaleFactor(0.5)
                            Spacer()
                            
                            Image(systemName: adviceCategory.icon)
                                .font(.system(size: 68))
                                .foregroundStyle(adviceCategory.color)
                            
                        }.padding(.horizontal, 48)
                        
                        
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text(current.weather.first?.description.capitalized ?? "Unknown")                                .font(.title3)             // <--- Bigger font
                                .foregroundStyle(.black)   // <--- Force Black
                            
                            HStack(spacing: 20) {
                                Label(
                                    "\(Int(today?.temp.max ?? 0))°",
                                    systemImage: "arrow.up"
                                )
                                Label(
                                    "\(Int(today?.temp.min ?? 0))°",
                                    systemImage: "arrow.down"
                                )
                                Spacer()
                            }
                            .font(.body.weight(.medium))   // <--- Bigger than subheadline, slightly bold
                            .foregroundStyle(.black)       // <--- Force Black
                        }
                        
                    }
                }
                
                Spacer()
                
                // MARK: - Details Card
                
                if current != nil {
                    detailsCard
                }
                
                // MARK: - Advisory Card
                
                AdvisoryCard(icon: adviceCategory.icon, advice: adviceCategory.adviceText, iconColor: adviceCategory.color)
                
                Spacer(minLength: 24)
            }  .padding()   .overlay {
                // 2. The "Glass Edge" Border (Critical for the look)
                RoundedRectangle(cornerRadius: 35, style: .continuous)
                
                    .stroke(.white.opacity(0.4), lineWidth: 1)
            }}
//            .background {
//                // 1. The Blur Layer (with reduced opacity to see more gradient)
//                RoundedRectangle(cornerRadius: 16)
//                    .fill(.ultraThinMaterial)
//                    .opacity(0.9) // Tweak this: Lower = More transparency, Higher = More blur
//            }
       
            .padding()
          
     
        }
    }
}

// MARK: - Subviews

private extension CurrentWeatherView {
    // Background Gradient (Custom RGB for premium feel)
        var backgroundGradient: LinearGradient {
            let colors: [Color]
            
            switch adviceCategory {
            case .freezing:
                // Icy White to Soft Lavender
                colors = [
                    Color(red: 0.90, green: 0.95, blue: 1.00),
                    Color(red: 0.75, green: 0.80, blue: 0.95)
                ]
            case .cold:
                // Soft Sky Blue to Cool Grey-Blue
                colors = [
                    Color(red: 0.80, green: 0.90, blue: 0.95),
                    Color(red: 0.60, green: 0.75, blue: 0.90)
                ]
            case .mild:
                // Mint Green to Fresh Teal
                colors = [
                    Color(red: 0.85, green: 0.98, blue: 0.90),
                    Color(red: 0.65, green: 0.90, blue: 0.85)
                ]
            case .warm:
                // Soft Sunshine Yellow to Warm Peach
                colors = [
                    Color(red: 1.00, green: 0.95, blue: 0.80),
                    Color(red: 1.00, green: 0.85, blue: 0.70)
                ]
            case .hot:
                // Warm Coral to Soft Orange
                colors = [
                    Color(red: 1.00, green: 0.80, blue: 0.75),
                    Color(red: 1.00, green: 0.65, blue: 0.60)
                ]
            case .unknown:
                // Your original beautiful pastel
                colors = [
                    Color(red: 0.74, green: 0.82, blue: 0.95),
                    Color(red: 0.98, green: 0.85, blue: 0.80)
                ]
            }

            return LinearGradient(
                colors: colors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    // Background Gradient (Apple-style ambient gradient)
//    var backgroundGradient: LinearGradient {
//        LinearGradient(
//            colors: [
//                Color(red: 0.74, green: 0.82, blue: 0.95),
//                Color(red: 0.98, green: 0.85, blue: 0.80)
//            ],
//            startPoint: .top,
//            endPoint: .bottom
//        )
//    }

    // Weather Details Card
    var detailsCard: some View {
        
        VStack(alignment: .leading,spacing: 12) {
            Text("Details")
                        .font(.headline) // or .title3
                        .foregroundStyle(.secondary) // Optional:
                        .padding(.bottom, 4) // Adds a little extra space under the title
            detailRow(
                
                "Pressure",
                "\(current?.pressure ?? 0) hPa",
                "barometer"
            )

            detailRow(
                "Sunrise",
                DateFormatterUtils.formattedDate12Hour(
                    from: TimeInterval(current?.sunrise ?? 0)
                ),"sunrise.fill"
                
            )

            detailRow(
                "Sunset",
                DateFormatterUtils.formattedDate12Hour(
                    from: TimeInterval(current?.sunset ?? 0)
                ),"sunset.fill"
                
            )
        }
        .padding()
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 16)
        )
    }

    // Advisory Card
    var advisoryCard: some View {
//        var iconColor: Color
        HStack(spacing: 12) {
            Image(systemName: adviceCategory.icon)
                .font(.title3)
                .foregroundStyle(.secondary)
                .foregroundColor(.blue)

            Text(adviceCategory.adviceText)
                .font(.callout)
                .multilineTextAlignment(.leading)
        }
        .padding()
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 14)
        )
    }

    // Detail Row Helper
    func detailRow(_ title: String, _ value: String, _ icon: String) -> some View {
        HStack {
           
            Image(systemName: icon)
           
            Text(title)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
        }
        .font(.subheadline)
    }
}

// MARK: - Preview

//#Preview {
//    let vm = MainAppViewModel(context: ModelContext(ModelContainer.preview))
//    CurrentWeatherView()
//        .environmentObject(vm)
//}


#Preview {
    let vm = PreviewDependencies.makePreviewViewModel()
    CurrentWeatherView()
        .environmentObject(vm)
}
