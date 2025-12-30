import Foundation
@MainActor
final class WeatherService {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherResponse {
        let response: WeatherResponse = try await networkService.fetch(urlString: APIConfig.getWeatherURL(lat: lat, lon: lon))
        return response
    }
}

