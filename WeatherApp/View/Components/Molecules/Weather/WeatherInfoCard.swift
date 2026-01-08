import SwiftUI

struct WeatherInfoCard: View {
    let current: Current
    let today: Daily?
    let adviceCategory: WeatherAdviceCategory
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            TemperatureHeroView(
                temperature: current.temp,
                iconName: adviceCategory.icon,
                iconColor: adviceCategory.color
            )
            
            WeatherDescriptionView(
                description: current.weather.first?.description ?? "Unknown",
                maxTemp: today?.temp.max ?? 0,
                minTemp: today?.temp.min ?? 0
            )
            
            Spacer()
            
            DetailsViewCard(current: current)
            
            
            AdvisoryCard(
                icon: adviceCategory.icon,
                advice: adviceCategory.adviceText,
                iconColor: adviceCategory.color
            )
            
            Spacer(minLength: 24)
        }
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 35, style: .continuous)
                .stroke(.white.opacity(0.8), lineWidth: 1)
        }
        .background {
            RoundedRectangle(cornerRadius: 35)
                .fill(.ultraThinMaterial)
                .opacity(0.9)
        }
    }
}

#Preview {
    let mockCurrent = Current(
        dt: 123,
        sunrise: 123,
        sunset: 123,
        temp: 24.0,
        feelsLike: 22.0,
        pressure: 1013,
        humidity: 50,
        uvi: 3.0,
        clouds: 10,
        visibility: 1000,
        windSpeed: 5.0,
        weather: [Weather(id: 800, main: "Clear", description: "Clear Sky", icon: "01d")]
    )
    
    ZStack {
        Color.teal.ignoresSafeArea()
        WeatherInfoCard(
            current: mockCurrent,
            today: nil,
            adviceCategory: .warm
        )
        .padding()
    }
}
