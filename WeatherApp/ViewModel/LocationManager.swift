//
//  LocationManager.swift
//  WeatherDashboardTemplate
//
//  Created by girish lukka on 18/10/2025.
//

import Foundation
import CoreLocation
@preconcurrency import MapKit


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
