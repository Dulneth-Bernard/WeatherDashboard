//
//  VisitedPlacesList.swift
//  WeatherApp
//
//  Created by Dulneth Bernard on 05/01/2026.
//


import SwiftUI
import SwiftData

struct VisitedPlacesList: View {

    let places: [Place]
    let onSelect: (Place) -> Void
    let onDelete: (IndexSet) -> Void
    
    var body: some View {
        List {
            ForEach(places) { place in
                Button {
                    onSelect(place)
                } label: {
             
                    VisitedPlaceRow(
                        placeName: place.name,
                        lastVisited: place.lastUsedAt
                    )
                }
                .listRowBackground(Color.white.opacity(0.5))
            }
            .onDelete(perform: onDelete)
        }
        .scrollContentBackground(.hidden)
    }
}

#Preview {

    let mockPlaces = [
        Place(name: "Paris", latitude: 48.85, longitude: 2.35),
        Place(name: "London", latitude: 51.50, longitude: -0.12)
    ]
    
    ZStack {
        Color.blue.opacity(0.2).ignoresSafeArea()
        VisitedPlacesList(
            places: mockPlaces,
            onSelect: { _ in },
            onDelete: { _ in }
        )
    }
}
