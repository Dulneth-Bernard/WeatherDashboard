



import SwiftUI
import SwiftData

struct CurrentWeatherView: View {
    
    @EnvironmentObject var vm: MainAppViewModel
    
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
    
    var body: some View {
        ZStack {
            
            adviceCategory.getWeatherBackGroundGradient(adviceCategory: adviceCategory).ignoresSafeArea()
            
            VStack {
                
                WeatherHeaderView(
                    placeName: vm.activePlaceName,
                    timestamp: current?.dt
                )
                
                
                if let current = current {
                    WeatherInfoCard(
                        current: current,
                        today: today,
                        adviceCategory: adviceCategory
                    )
                    
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                } else {
                    
                    Spacer()
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(1.5)
                    Spacer()
                }
            }
            .padding()
        }
    }
}

#Preview {
    let vm = PreviewDependencies.makePreviewViewModel()
    CurrentWeatherView()
        .environmentObject(vm)
}
