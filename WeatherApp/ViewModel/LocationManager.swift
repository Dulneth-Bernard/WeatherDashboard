//
//  LocationManager.swift
//  WeatherDashboardTemplate
//
//  Created by girish lukka on 18/10/2025.
//

import Foundation
import CoreLocation
@preconcurrency import MapKit


//@MainActor
//final class LocationManager {
//    
//    private let geocoder = CLGeocoder()
//
//    func geocodeAddress(_ address: String) async throws -> (name: String, lat: Double, lon: Double) {
//        // Uses `CLGeocoder` to convert a string address into geographic coordinates.
//        // Extracts the name, latitude, and longitude from the first resulting placemark.
//        // Throws a `WeatherMapError.geocodingFailed` if no valid location can be found.
//        
//        guard !address.isEmpty else { throw WeatherMapError.geocodingFailed("Address is empty") }
//        
//        let placemarks = try await geocoder.geocodeAddressString(address)
//        
//        guard let place = placemarks.first,
//              let location = place.location,
//              let name = place.locality ?? place.name else {
//            throw WeatherMapError.geocodingFailed(address)
//            
//            return (name, location.coordinate.latitude, location.coordinate.longitude)
//        }
//        
//
//        // DUMMY RETURN TO SATISFY COMPILER
//        preconditionFailure("Stubbed function not implemented. Requires a (name: String, lat: Double, lon: Double) return.")
//    }
//
//    func findPOIs(lat: Double, lon: Double, limit: Int = 5) async throws -> [AnnotationModel] {
//        // Uses `MKLocalSearch` to find Points of Interest (POIs), specifically "Tourist Attractions," within a small region around the given latitude and longitude.
//        // Executes the search request.
//        // Maps the `MKMapItem` results into an array of `AnnotationModel`s, filtering out any without a name.
//        // Limits the final array size to the specified `limit`.
//
//        // DUMMY RETURN TO SATISFY COMPILER
//        preconditionFailure("Stubbed function not implemented. Requires a [AnnotationModel] return.")
//    }
//}


@MainActor
final class LocationManager {

    private let geocoder = CLGeocoder()

    /// Converts a human-readable location name into coordinates.
    ///
    /// - Parameter address: City or place name (e.g. "London")
    /// - Returns: Tuple containing a resolved name and coordinates
    /// - Throws: WeatherMapError.geocodingFailed if no valid result is found
    func geocodeAddress(_ address: String) async throws -> (name: String, lat: Double, lon: Double) {

        do {
            let placemarks = try await geocoder.geocodeAddressString(address)

            guard let placemark = placemarks.first,
                  let location = placemark.location else {
                throw WeatherMapError.geocodingFailed(address)
            }

            let resolvedName =
                placemark.locality ??
                placemark.name ??
                address

            return (
                name: resolvedName,
                lat: location.coordinate.latitude,
                lon: location.coordinate.longitude
            )

        } catch {
            throw WeatherMapError.geocodingFailed(address)
        }
    }

    /// Finds nearby tourist attractions around a coordinate.
    ///
    /// - Parameters:
    ///   - lat: Latitude
    ///   - lon: Longitude
    ///   - limit: Maximum number of POIs to return (default = 5)
    /// - Returns: Array of AnnotationModel objects
    func findPOIs(
        lat: Double,
        lon: Double,
        limit: Int = 5
    ) async throws -> [AnnotationModel] {

        let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let region = MKCoordinateRegion(
            center: center,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Tourist Attraction"
        request.region = region
        request.resultTypes = .pointOfInterest

        let search = MKLocalSearch(request: request)

        let response = try await search.start()

        let annotations: [AnnotationModel] = response.mapItems
            .compactMap { item in
                guard
                    let name = item.name,
                    let coordinate = item.placemark.location?.coordinate
                else { return nil }

                return AnnotationModel(
                    name: name,
                    latitude: coordinate.latitude,
                    longitude: coordinate.longitude
                )
            }

        return Array(annotations.prefix(limit))
    }
}
