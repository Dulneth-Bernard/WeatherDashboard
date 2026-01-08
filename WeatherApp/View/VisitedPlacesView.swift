//
//  VisitedPlacesView.swift
//  WeatherDashboardTemplate
//
//  Created by girish lukka on 18/10/2025.
//


import SwiftUI
import SwiftData

struct VisitedPlacesView: View {
    @EnvironmentObject var vm: MainAppViewModel
    
    
    var body: some View {
        ZStack {
            vm.weatherCategory.backgroundGradient.ignoresSafeArea()
            

            if vm.visited.isEmpty {
                ContentUnavailableView(
                    "No Places Saved",
                    
                    systemImage: "globe",
                    description: Text("Search and load a city to see it here.")
                )
            } else {
                VisitedPlacesList(
                    places: vm.visited,
                    onSelect: { place in
                        Task { await vm.loadLocation(from: place) }
                    },
                    onDelete: { indexSet in
                        indexSet.map { vm.visited[$0] }.forEach { vm.delete(place: $0) }
                    }
                )
            }
        }
        .navigationTitle("Visited Places")
    }
}

#Preview {
    let vm = PreviewDependencies.makePreviewViewModel()
    VisitedPlacesView()
        .environmentObject(vm)
}
