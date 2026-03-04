//
//  AttractionsList.swift
//  WeatherApp
//
//  Created by Dulneth Bernard on 04/01/2026.
//


import SwiftUI

struct AttractionsList: View {
    let pois: [AnnotationModel] // ✅ Correct type
    let onSelect: (AnnotationModel) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Nearby Attractions")
                .font(.headline)
                .padding(.horizontal)
                .padding(.top, 10)
            
            if pois.isEmpty {
                ContentUnavailableView("No POIs Found", systemImage: "mappin.slash")
            } else {
                List(pois) { poi in
                    // Use Molecule
                    POIListRow(poi: poi)
                        .onTapGesture {
                            onSelect(poi)
                        }
                        .listRowBackground(Color.white.opacity(0.5))
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
        .background(Color.white.opacity(0.3))
    }
}
