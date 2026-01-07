import SwiftUI
import SwiftData
import MapKit
import Combine

//@MainActor
//final class MainAppViewModel: ObservableObject {
//    @Published var query = ""
//    @Published var currentWeather: Weather?
//    @Published var forecast: [Weather] = []
//    @Published var pois: [AnnotationModel] = []
//    @Published var mapRegion = MKCoordinateRegion()
//    @Published var visited: [Place] = []
//    @Published var isLoading = false
//    @Published var appError: WeatherMapError?
//    @Published var activePlaceName: String = ""
//    private let defaultPlaceName = "London"
//    @Published var selectedTab: Int = 0
//    private let networkService: NetworkService
//    var appStatus: AppStatus = .idle
//    
//    @Published var currentConditions: Current?
//    
//    /// Create and use a WeatherService model (class) to manage fetching and decoding weather data
//    private lazy var weatherService = WeatherService(networkService: networkService)
//    
//    /// Create and use a LocationManager model (class) to manage address conversion and tourist places
//    private let locationManager = LocationManager()
//    
//    /// Use a context to manage database operations
//    private let context: ModelContext
//    
//    init(
//        networkService: NetworkService,
//        context: ModelContext) {
//            self.networkService = networkService
//            self.context = context
//            self.mapRegion = mapRegion
//            Task { await loadInitialData() }
//        }
//
//    
//    //    init(context: ModelContext) {
//    //        // Initialize the ModelContext and attempt to fetch previously visited places from SwiftData, sorted by most recent use.
//    //        // If no visited places exist (first launch), load the default location.
//    //        // Otherwise, load the most recently used place.
//    //        self.context = context
//    //
//    //        // Corrected FetchDescriptor to include sorting by 'lastUsedAt' in reverse order.
//    //        if let results = try? context.fetch(
//    //            FetchDescriptor<Place>(sortBy: [SortDescriptor(\Place.lastUsedAt, order: .reverse)])
//    //        ) {
//    //            self.visited = results
//    //        }
//    //
//    //        // First launch: no data → perform full London setup
//    //        if visited.isEmpty {
//    //            Task {
//    //                await loadDefaultLocation()
//    //            }
//    //        } else if let mostRecent = visited.first {
//    //            // Otherwise, load most recently used place
//    //            Task {
//    //                await loadLocation(fromPlace: mostRecent)
//    //            }
//    //        }
//    //    }
//    
//    func submitQuery() {
//        let city = query.trimmingCharacters(in: .whitespacesAndNewlines)
//        guard !city.isEmpty else {
//            appError = .missingData(message: "Please enter a valid location.")
//            return
//        }
//        Task {
//            do {
//                // MARK: call loadLocation(byName:)
//                try await loadLocation(byName: city)
//                query = ""
//            } catch {
//                appError = .networkError(error)
//            }
//        }
//    }
//    func loadDefaultLocation() async {
//        // Attempts to select and load the hardcoded default location name.
//        // If an error occurs during selection, sets an app error.
//        appStatus = .loading
//        do{
//            let defaultWeatherResponse = try await weatherService.fetchWeather(lat: 51.5072, lon: 0.1276)
//            forecast = defaultWeatherResponse.current.weather
//            currentConditions = defaultWeatherResponse.current
//            appStatus = .success
//        }catch{
//            appStatus = .failure
//            appError = .networkError(error)
//        }
//    }
//    
//    func search() async throws {
//        // If the query is not empty, calls `select(placeNamed:)` with the current query string.
//    }
//    
//    /// Validate weather before saving a new place; create POI children once.
//    func loadLocation(byName: String) async throws {
//        // Sets loading state, then attempts to load data for the given place name.
//        // 1. Checks if the place is already in `visited` and, if so, loads all data for the existing `Place` object, updates its `lastUsedAt`, and saves the context.
//        // 2. Otherwise, geocodes the fresh place name using `locationManager`.
//        // 3. Fetches weather data using `weatherService` as a fail-fast check.
//        // 4. Finds Points of Interest (POIs) using `locationManager`, converts them to `AnnotationModel`s, and associates them with the new `Place`.
//        // 5. Inserts the new `Place` into the `visited` array and saves the context.
//        // 6. Updates UI by setting `pois`, `activePlaceName`, and focusing the map.
//        // 7. If any step fails, logs the error and reverts to the default location with an alert.
//    }
//    
//    func loadLocation(fromPlace place: Place) async{
//        // Sets loading state, then attempts to load all data for an existing `Place` object.
//        // Updates the place's `lastUsedAt` and saves the context upon success.
//        // Catches and sets `appError` for any failure during the load process.
//    }
//    
//    private func revertToDefaultWithAlert(message: String) async {
//        // Sets an `appError` with the given message, then calls `loadDefaultLocation()` to switch back to the default.
//    }
//    
//    func focus(on coordinate: CLLocationCoordinate2D, zoom: Double = 0.02) {
//        // Animates the map region to center on the given coordinate with a specified zoom level (span).
//    }
//    
//    private func loadAll(for place: Place) async throws {
//        // Sets `activePlaceName` and prints a loading message.
//        // Always refreshes weather data from the API.
//        // Checks if the `Place` object has existing annotations (POIs).
//        // If annotations are empty, fetches new POIs via `MKLocalSearch`, converts them to `AnnotationModel`s, adds them to the `Place`, saves the context, and sets `self.pois`.
//        // If annotations exist, uses the cached list for `self.pois`.
//        // Calls `focus(on:zoom:)` to update the map view.
//        // Ensures the place is at the top of the `visited` list (if not already).
//    }
//    
//    func delete(place: Place) {
//        // Deletes the given `Place` object from the ModelContext and removes it from the `visited` array.
//        // Attempts to save the context.
//    }
//    
//}



//@MainActor
//final class MainAppViewModel: ObservableObject {
//
//    // MARK: - UI State
//
//    @Published var query: String = ""
//    @Published var isLoading: Bool = false
//    @Published var appError: WeatherMapError?
//    @Published var selectedTab: Int = 0
//
//    // MARK: - Domain State
//
//    @Published var activePlaceName: String = ""
//    @Published var mapRegion: MKCoordinateRegion = .init()
//    @Published var pois: [AnnotationModel] = []
//    @Published var visited: [Place] = []
//
//    // MARK: - Weather Data (bind views later)
//
//    @Published var weatherResponse: WeatherResponse?
//    
//    
//    private var didLoadDefault = false
//    private var isHandlingError = false
//
//    // MARK: - Constants
//
//    private let defaultPlaceName = "London"
//
//    // MARK: - Dependencies
//    private let networkService: NetworkService
//    private lazy var weatherService = WeatherService(networkService: networkService)
//    private let locationManager = LocationManager()
//    private let context: ModelContext
//
//    // MARK: - Init
//
//    init(context: ModelContext, networkService: NetworkService, skipAutoLoad: Bool = false) {
//        self.context = context
//        self.networkService = networkService
//
//        // Load previously visited places
////        loadVisitedPlaces()
//
//        // Load most recent or default
//        if !skipAutoLoad {
//            if let mostRecent = visited.first {
//                Task { await loadLocation(from: mostRecent) }
//            } else {
//                Task { await loadDefaultLocation() }
//            }
//        }
//    }
//
//    // MARK: - Public Actions
//
//    func submitQuery() {
//        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
//        guard !trimmed.isEmpty else {
//            appError = .missingData(message: "Please enter a valid location.")
//            return
//        }
//
//        Task {
//            await loadLocation(byName: trimmed)
//            query = ""
//        }
//    }
//
//    func delete(place: Place) {
//        context.delete(place)
//        visited.removeAll { $0.id == place.id }
//
//        do {
//            try context.save()
//        } catch {
//            appError = .networkError(error)
//        }
//    }
//
//    func focus(on coordinate: CLLocationCoordinate2D, zoom: Double = 0.02) {
//        withAnimation {
//            mapRegion = MKCoordinateRegion(
//                center: coordinate,
//                span: MKCoordinateSpan(latitudeDelta: zoom, longitudeDelta: zoom)
//            )
//        }
//    }
//
//    // MARK: - Core Load Logic
//
////    func loadDefaultLocation() async {
////        await loadLocation(byName: defaultPlaceName)
////    }
//    
//    func loadDefaultLocation() async {
//            // USE HARDCODED COORDINATES FOR LONDON
//            // This prevents the "Geocoding Rate Limit" crash on startup.
//            let londonName = "London"
//            let londonLat = 51.5074
//            let londonLon = -0.1278
//
//            isLoading = true
//            defer { isLoading = false }
//
//            do {
//                // 1. Check if we already have London saved to avoid duplicates
//                // We compare names case-insensitively
//                if let existing = visited.first(where: { $0.name.caseInsensitiveCompare(londonName) == .orderedSame }) {
//                    await loadLocation(from: existing)
//                    return
//                }
//
//                // 2. Skip Geocoding! Fetch Weather & POIs directly using Lat/Lon
//                let weather = try await weatherService.fetchWeather(lat: londonLat, lon: londonLon)
//                let pois = try await locationManager.findPOIs(lat: londonLat, lon: londonLon)
//
//                // 3. Create the Place object manually
//                let place = Place(
//                    name: londonName,
//                    latitude: londonLat,
//                    longitude: londonLon
//                )
//
//                // 4. Save to Database
//                context.insert(place)
//                visited.insert(place, at: 0)
//                try context.save()
//
//                // 5. Update the UI
//                applyLoadedData(
//                    placeName: londonName,
//                    coordinate: CLLocationCoordinate2D(latitude: londonLat, longitude: londonLon),
//                    weather: weather,
//                    pois: pois
//                )
//                
//                appError = .missingData(message: "Default location loaded.")
//
//            } catch {
//                // If even this fails (e.g. no internet), just show the error.
//                // DO NOT call loadDefaultLocation() recursively here.
//                appError = .missingData(message: "Failed to load default location: \(error.localizedDescription)")
//            }
//        }
//    func loadLocation(byName name: String) async {
//        isLoading = true
//        defer { isLoading = false }
//
//        do {
//            if let existing = visited.first(where: { $0.name.lowercased() == name.lowercased() }) {
//                await loadLocation(from: existing)
//                appError = .missingData(message: "Loaded saved location.")
//                return
//            }
//
//            let geo = try await locationManager.geocodeAddress(name)
//            let weather = try await weatherService.fetchWeather(lat: geo.lat, lon: geo.lon)
//            let pois = try await locationManager.findPOIs(lat: geo.lat, lon: geo.lon)
//
//            let place = Place(
//                name: geo.name,
//                latitude: geo.lat,
//                longitude: geo.lon
//            )
//
//            context.insert(place)
//            visited.insert(place, at: 0)
//            try context.save()
//
//            applyLoadedData(
//                placeName: geo.name,
//                coordinate: CLLocationCoordinate2D(latitude: geo.lat, longitude: geo.lon),
//                weather: weather,
//                pois: pois
//            )
//
//            appError = .missingData(message: "Location saved successfully.")
//
//        } catch let error as WeatherMapError {
//            await revertToDefaultWithAlert(message: error.localizedDescription)
//        } catch {
//            await revertToDefaultWithAlert(message: "Something went wrong.")
//        }
//    }
//
//    func loadLocation(from place: Place) async {
//        isLoading = true
//        defer { isLoading = false }
//
//        do {
//            let weather = try await weatherService.fetchWeather(
//                lat: place.latitude,
//                lon: place.longitude
//            )
//
//            place.lastUsedAt = .now
//            try context.save()
//
//            applyLoadedData(
//                placeName: place.name,
//                coordinate: CLLocationCoordinate2D(
//                    latitude: place.latitude,
//                    longitude: place.longitude
//                ),
//                weather: weather,
//                pois: pois
//            )
//
//            reorderVisited(place)
//
//        } catch {
//            appError = .networkError(error)
//        }
//    }
//
//    // MARK: - Helpers
//
//    private func loadVisitedPlaces() {
//        if let results = try? context.fetch(
//            FetchDescriptor<Place>(
//                sortBy: [SortDescriptor(\.lastUsedAt, order: .reverse)]
//            )
//        ) {
//            visited = results
//        }
//    }
//
//    private func reorderVisited(_ place: Place) {
//        visited.removeAll { $0.id == place.id }
//        visited.insert(place, at: 0)
//    }
//
//    private func applyLoadedData(
//        placeName: String,
//        coordinate: CLLocationCoordinate2D,
//        weather: WeatherResponse,
//        pois: [AnnotationModel]
//    ) {
//        self.activePlaceName = placeName
//        self.weatherResponse = weather
//        self.pois = pois
//        focus(on: coordinate)
//        selectedTab = 0
//    }
//
////    private func revertToDefaultWithAlert(message: String) async {
////        appError = .missingData(message: message)
////        await loadDefaultLocation()
////    }
//    
//    private func revertToDefaultWithAlert(message: String) async {
//        guard !isHandlingError else { return }
//        isHandlingError = true
//
//        appError = .missingData(message: message)
//
//        // Only load default if it has never been loaded
//        if !didLoadDefault {
//            await loadDefaultLocation()
//        }
//
//        isHandlingError = false
//    }
//}
//


//import SwiftUI
//import SwiftData
//import MapKit
//
//@MainActor
//final class MainAppViewModel: ObservableObject {
//
//    // MARK: - UI State
//    @Published var query: String = ""
//    @Published var isLoading: Bool = false
//    @Published var appError: WeatherMapError?
//    @Published var selectedTab: Int = 0
//    
//    // MARK: - NEW: Info Alert State
//    @Published var showInfoAlert: Bool = false
//    @Published var infoMessage: String = ""
//
//    // MARK: - Domain State
//    @Published var activePlaceName: String = ""
//    @Published var mapRegion: MKCoordinateRegion = .init()
//    @Published var pois: [AnnotationModel] = []
//    @Published var visited: [Place] = []
//
//    // MARK: - Weather Data
//    @Published var weatherResponse: WeatherResponse?
//    
//    private var didLoadDefault = false
//    private var isHandlingError = false
//    private let defaultPlaceName = "London"
//
//    // MARK: - Dependencies
//    private let networkService: NetworkService
//    private lazy var weatherService = WeatherService(networkService: networkService)
//    private let locationManager = LocationManager()
//    private let context: ModelContext
//
//    // MARK: - Init
//    init(context: ModelContext, networkService: NetworkService, skipAutoLoad: Bool = false) {
//        self.context = context
//        self.networkService = networkService
//        
//        // Fetch visited places immediately so the list isn't empty on launch
//        loadVisitedPlaces()
//
//        if !skipAutoLoad {
//            if let mostRecent = visited.first {
//                Task { await loadLocation(from: mostRecent) }
//            } else {
//                Task { await loadDefaultLocation() }
//            }
//        }
//    }
//
//    // MARK: - Actions
//
//    func submitQuery() {
//        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
//        guard !trimmed.isEmpty else {
//            appError = .missingData(message: "Please enter a valid location.")
//            return
//        }
//        
//        // Dismiss keyboard
//        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//
//        Task {
//            await loadLocation(byName: trimmed)
//            query = ""
//        }
//    }
//
//    func loadDefaultLocation() async {
//        let londonName = "London"
//        let londonLat = 51.5074
//        let londonLon = -0.1278
//
//        isLoading = true
//        defer { isLoading = false }
//
//        do {
//            if let existing = visited.first(where: { $0.name.caseInsensitiveCompare(londonName) == .orderedSame }) {
//                await loadLocation(from: existing)
//                return
//            }
//
//            let weather = try await weatherService.fetchWeather(lat: londonLat, lon: londonLon)
//            let pois = try await locationManager.findPOIs(lat: londonLat, lon: londonLon)
//
//            let place = Place(name: londonName, latitude: londonLat, longitude: londonLon)
//            
//            // Save and Insert
//            context.insert(place)
//            try context.save()
//            
//            // Insert at top of local array immediately to update UI
//            reorderVisited(place)
//
//            applyLoadedData(
//                placeName: londonName,
//                coordinate: CLLocationCoordinate2D(latitude: londonLat, longitude: londonLon),
//                weather: weather,
//                pois: pois
//            )
//
//        } catch {
//            appError = .missingData(message: "Failed to load default location.")
//        }
//    }
//
//    func loadLocation(byName name: String) async {
//        isLoading = true
//        defer { isLoading = false }
//
//        do {
//            // 1. Check local storage first
//            if let existing = visited.first(where: { $0.name.caseInsensitiveCompare(name) == .orderedSame }) {
//                await loadLocation(from: existing)
//                
//                // MARK: - Requirement: Alert when loaded from storage
//                self.infoMessage = "Location loaded from local storage."
//                self.showInfoAlert = true
//                return
//            }
//
//            // 2. Fetch fresh
//            let geo = try await locationManager.geocodeAddress(name)
//            let weather = try await weatherService.fetchWeather(lat: geo.lat, lon: geo.lon)
//            let pois = try await locationManager.findPOIs(lat: geo.lat, lon: geo.lon)
//
//            let place = Place(name: geo.name, latitude: geo.lat, longitude: geo.lon)
//
//            context.insert(place)
//            try context.save()
//            reorderVisited(place)
//
//            applyLoadedData(
//                placeName: geo.name,
//                coordinate: CLLocationCoordinate2D(latitude: geo.lat, longitude: geo.lon),
//                weather: weather,
//                pois: pois
//            )
//
//        } catch let error as WeatherMapError {
//            await revertToDefaultWithAlert(message: error.localizedDescription)
//        } catch {
//            await revertToDefaultWithAlert(message: "Could not find location.")
//        }
//    }
//
//    func loadLocation(from place: Place) async {
//        isLoading = true
//        defer { isLoading = false }
//
//        do {
//            let weather = try await weatherService.fetchWeather(lat: place.latitude, lon: place.longitude)
//
//            place.lastUsedAt = .now
//            try context.save()
//            reorderVisited(place) // Move to top of list
//
//            // If POIs are missing in the DB, try to fetch them again
//            var finalPOIs = pois // Default to current
//            // You might want to store POIs in the Place relationship,
//            // but for now, we can re-fetch if needed or use what's in VM if managing separately.
//            // Assuming we fetch fresh POIs for simplicity or usage of API:
//            finalPOIs = try await locationManager.findPOIs(lat: place.latitude, lon: place.longitude)
//
//            applyLoadedData(
//                placeName: place.name,
//                coordinate: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude),
//                weather: weather,
//                pois: finalPOIs
//            )
//
//        } catch {
//            appError = .networkError(error)
//        }
//    }
//    
//    func delete(place: Place) {
//        context.delete(place)
//        visited.removeAll { $0.id == place.id }
//        do { try context.save() } catch { print("Delete failed") }
//    }
//
//    func focus(on coordinate: CLLocationCoordinate2D, zoom: Double = 0.05) { // Adjusted zoom for better view
//        withAnimation {
//            mapRegion = MKCoordinateRegion(
//                center: coordinate,
//                span: MKCoordinateSpan(latitudeDelta: zoom, longitudeDelta: zoom)
//            )
//        }
//    }
//
//    // MARK: - Private Helpers
//
//    private func loadVisitedPlaces() {
//        if let results = try? context.fetch(FetchDescriptor<Place>(sortBy: [SortDescriptor(\.lastUsedAt, order: .reverse)])) {
//            visited = results
//        }
//    }
//    
//    private func reorderVisited(_ place: Place) {
//        visited.removeAll { $0.id == place.id }
//        visited.insert(place, at: 0)
//    }
//
//    private func applyLoadedData(placeName: String, coordinate: CLLocationCoordinate2D, weather: WeatherResponse, pois: [AnnotationModel]) {
//        self.activePlaceName = placeName
//        self.weatherResponse = weather
//        self.pois = pois
//        self.focus(on: coordinate)
//        self.selectedTab = 0 // Switch to Now tab
//    }
//
//    private func revertToDefaultWithAlert(message: String) async {
//        guard !isHandlingError else { return }
//        isHandlingError = true
//        appError = .missingData(message: message)
//        if !didLoadDefault { await loadDefaultLocation() }
//        isHandlingError = false
//    }
//}


// WeatherApp/ViewModel/MainAppViewModel.swift

import SwiftUI
import SwiftData
import MapKit

@MainActor
final class MainAppViewModel: ObservableObject {

    // MARK: - UI State
    @Published var query: String = ""
    @Published var isLoading: Bool = false
    @Published var appError: WeatherMapError?
    @Published var selectedTab: Int = 0
    
    @Published var showInfoAlert: Bool = false
    @Published var infoMessage: String = ""

    // MARK: - Domain State
    @Published var activePlaceName: String = ""
    @Published var mapRegion: MKCoordinateRegion = .init()
    @Published var pois: [AnnotationModel] = []
    @Published var visited: [Place] = []

    // MARK: - Weather Data
    @Published var weatherResponse: WeatherResponse?
    
    private var isHandlingError = false
    
    // MARK: - Dependencies
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

    // MARK: - Actions

    func submitQuery() {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            appError = .missingData(message: "Please enter a valid location.")
            return
        }
        
        // Dismiss keyboard
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

        Task {
            await loadLocation(byName: trimmed)
            query = ""
        }
    }

    func loadDefaultLocation() async {
        let londonName = "London"
        let londonLat = 51.5074
        let londonLon = -0.1278

        isLoading = true
        defer { isLoading = false }

        do {
            // Check if London is already saved to avoid duplicates
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
            // 1. Check local storage first
            // FIX: Ensure we match case-insensitively
            if let existing = visited.first(where: { $0.name.caseInsensitiveCompare(name) == .orderedSame }) {
                await loadLocation(from: existing)
                
                // FIX: Show Alert for local storage load
                self.infoMessage = "Location loaded from local storage."
                self.showInfoAlert = true
                return
            }

            // 2. Fetch fresh if not found
            let geo = try await locationManager.geocodeAddress(name)
            let weather = try await weatherService.fetchWeather(lat: geo.lat, lon: geo.lon)
            let pois = try await locationManager.findPOIs(lat: geo.lat, lon: geo.lon)

            // FIX: Pass 'pois' into the Place init so they are saved to the DB
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

        } catch {
            // FIX: Revert to default with "Invalid Location" message
            await revertToDefaultWithAlert(message: "Invalid Location")
        }
    }

    func loadLocation(from place: Place) async {
        isLoading = true
        defer { isLoading = false }

        do {
            // 1. Fetch Fresh Weather
            let weather = try await weatherService.fetchWeather(lat: place.latitude, lon: place.longitude)

            // 2. Load POIs from Database (DO NOT call findPOIs again)
            // FIX: Use the annotations already saved in the Place object
            let savedPOIs = place.annotations

            // 3. Update Last Used
            place.lastUsedAt = .now
            try context.save()
            reorderVisited(place)

            applyLoadedData(
                placeName: place.name,
                coordinate: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude),
                weather: weather,
                pois: savedPOIs // FIX: Pass the saved POIs, not fresh ones
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

    // MARK: - Private Helpers

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
        
        // FIX: Always load default if search failed (Requirement)
        await loadDefaultLocation()
        
        isHandlingError = false
    }
}
