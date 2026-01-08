import SwiftUI
import SwiftData
import MapKit
import Combine

@MainActor
final class MainAppViewModel: ObservableObject {
    

    @Published var query: String = ""
    @Published var isLoading: Bool = false
    @Published var appError: WeatherMapError?
    @Published var selectedTab: Int = 0
    
    @Published var showInfoAlert: Bool = false
    @Published var infoMessage: String = ""
    

    @Published var activePlaceName: String = ""
    @Published var mapRegion: MKCoordinateRegion = .init()
    @Published var pois: [AnnotationModel] = []
    @Published var visited: [Place] = []
    
    
    @Published var weatherResponse: WeatherResponse?
    
    private var isHandlingError = false
    

    private let networkService: NetworkService
    private lazy var weatherService = WeatherService(networkService: networkService)
    private let locationManager = LocationManager()
    private let context: ModelContext
    
    init(context: ModelContext, networkService: NetworkService, skipAutoLoad: Bool = false) {
        self.context = context
        self.networkService = networkService
        
        loadVisitedPlaces()
        
        if !skipAutoLoad {
            if let mostRecent = visited.first {
                Task { await loadLocation(from: mostRecent) }
            } else {
                Task { await loadDefaultLocation() }
            }
        }
    }
    

    
    func submitQuery() {
        let city = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !city.isEmpty else {
            appError = .missingData(message: "Please enter a valid location.")
            return
        }
     
        Task {
            do {

                 await loadLocation(byName: city)
                query = ""
            } catch {
                appError = .networkError(error)
            }
        }
    }
    
    func loadDefaultLocation() async {
        let londonName = "London"
        let londonLat = 51.5074
        let londonLon = -0.1278
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            // Checkingif London is already saved to avoid duplicates
            if let existing = visited.first(where: { $0.name.caseInsensitiveCompare(londonName) == .orderedSame }) {
                await loadLocation(from: existing)
                return
            }
            
            let weather = try await weatherService.fetchWeather(lat: londonLat, lon: londonLon)
            let pois = try await locationManager.findPOIs(lat: londonLat, lon: londonLon)
            
            let place = Place(name: londonName, latitude: londonLat, longitude: londonLon, annotations: pois)
            
            context.insert(place)
            try context.save()
            reorderVisited(place)
            
            applyLoadedData(
                placeName: londonName,
                coordinate: CLLocationCoordinate2D(latitude: londonLat, longitude: londonLon),
                weather: weather,
                pois: pois
            )
            
        } catch {
            appError = .missingData(message: "Failed to load default location.")
        }
    }
    
    func loadLocation(byName name: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            // Ensure we match case-insensitively
            if let existing = visited.first(where: { $0.name.caseInsensitiveCompare(name) == .orderedSame }) {
                await loadLocation(from: existing)
                
                // Show Alert for local storage load
                self.infoMessage = "Location loaded from storage."
                self.showInfoAlert = true
                return
            }
            
            //  Fetch fresh if not found
            let geo = try await locationManager.geocodeAddress(name)
            let weather = try await weatherService.fetchWeather(lat: geo.lat, lon: geo.lon)
            let pois = try await locationManager.findPOIs(lat: geo.lat, lon: geo.lon)
            

            let place = Place(name: geo.name, latitude: geo.lat, longitude: geo.lon, annotations: pois)
            
            context.insert(place)
            try context.save()
            reorderVisited(place)
            
            applyLoadedData(
                placeName: geo.name,
                coordinate: CLLocationCoordinate2D(latitude: geo.lat, longitude: geo.lon),
                weather: weather,
                pois: pois
            )
            
            self.infoMessage = "Location saved successfully!"
            self.showInfoAlert = true
            
        } catch {
      
            await revertToDefaultWithAlert(message: "Invalid Location")
        }
    }
    
    func loadLocation(from place: Place) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            // Fetch Fresh Weather
            let weather = try await weatherService.fetchWeather(lat: place.latitude, lon: place.longitude)
            
    
            let savedPOIs = place.annotations
            
            place.lastUsedAt = .now
            try context.save()
            reorderVisited(place)
            
            applyLoadedData(
                placeName: place.name,
                coordinate: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude),
                weather: weather,
                pois: savedPOIs
            )
            
           
            
        } catch {
            appError = .networkError(error)
        }
    }
    
    func delete(place: Place) {
        context.delete(place)
        visited.removeAll { $0.id == place.id }
        do { try context.save() } catch { print("Delete failed") }
    }
    
    func focus(on coordinate: CLLocationCoordinate2D, zoom: Double = 0.05) {
        withAnimation {
            mapRegion = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: zoom, longitudeDelta: zoom)
            )
        }
    }
    
  
    private func loadVisitedPlaces() {
        if let results = try? context.fetch(FetchDescriptor<Place>(sortBy: [SortDescriptor(\.lastUsedAt, order: .reverse)])) {
            visited = results
        }
    }
    
    private func reorderVisited(_ place: Place) {
        visited.removeAll { $0.id == place.id }
        visited.insert(place, at: 0)
    }
    
    private func applyLoadedData(placeName: String, coordinate: CLLocationCoordinate2D, weather: WeatherResponse, pois: [AnnotationModel]) {
        self.activePlaceName = placeName
        self.weatherResponse = weather
        self.pois = pois
        self.focus(on: coordinate)
        self.selectedTab = 0
    }
    
    private func revertToDefaultWithAlert(message: String) async {
        guard !isHandlingError else { return }
        isHandlingError = true
        
        appError = .missingData(message: message)
        
        // Always load default if search failed
        await loadDefaultLocation()
        
        isHandlingError = false
    }
    
    var weatherCategory: WeatherAdviceCategory {
        //  If we have weather data, calculate the category
        if let current = weatherResponse?.current {
            return WeatherAdviceCategory.from(
                temp: current.temp,
                description: current.weather.first?.description ?? ""
            )
        }
        //  Default to unknown 
        return .unknown
    }
}
