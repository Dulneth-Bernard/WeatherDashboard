import Foundation
import SwiftData

// MARK: - Mock Network for Previews
struct MockNetworkService: NetworkService {
    func fetch<T>(urlString: String) async throws -> T where T : Decodable {
        // Provide minimal, deterministic fake data for types we know about.
        // If an unknown type is requested, crash loudly in previews to catch misuse.
        if T.self == WeatherResponse.self {
            let now = Int(Date().timeIntervalSince1970)

            let current = Current(
                dt: now,
                sunrise: now - 3600,
                sunset: now + 8 * 3600,
                temp: 18.0,
                feelsLike: 18.0,
                pressure: 1012,
                humidity: 60,
                dewPoint: 10.0,
                uvi: 1,
                clouds: 10,
                visibility: 10000,
                windSpeed: 3.4,
                windDeg: 200,
                weather: [Weather(id: 800, main: "Clear", description: "clear sky", icon: "01d")]
            )

            let daily = Daily(
                dt: now,
                sunrise: now - 3600,
                sunset: now + 8 * 3600,
                moonrise: now - 7200,
                moonset: now + 6 * 3600,
                moonPhase: 0.5,
                summary: "Sunny with light breeze",
                temp: Temp(day: 18, min: 12, max: 20, night: 14, eve: 17, morn: 13),
                feelsLike: FeelsLike(day: 18, night: 14, eve: 17, morn: 13),
                pressure: 1012,
                humidity: 55,
                dewPoint: 10,
                windSpeed: 3.4,
                windDeg: 200,
                windGust: 5.1,
                weather: [Weather(id: 800, main: "Clear", description: "clear sky", icon: "01d")],
                clouds: 5,
                pop: 0.0,
                uvi: 3.2,
                rain: nil
            )

            let stub = WeatherResponse(
                lat: 51.5074,
                lon: -0.1278,
                timezone: "Europe/London",
                timezoneOffset: 0,
                current: current,
                daily: [daily]
            )

            return stub as! T
        }
        preconditionFailure("MockNetworkService has no stub for type: \(T.self)")
    }
}

// MARK: - Preview ViewModel Factory
enum PreviewDependencies {
    static func makePreviewViewModel() -> MainAppViewModel {
        // Build an in-memory SwiftData container for previews
        let schema = Schema([Place.self, AnnotationModel.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [config])
        
        let context = ModelContext(container)
        let mock = MockNetworkService()
        return MainAppViewModel(context: context, networkService: mock, skipAutoLoad: true)
    }
}

