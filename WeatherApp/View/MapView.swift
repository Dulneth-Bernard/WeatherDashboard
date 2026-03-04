//
//  MapView.swift
//  WeatherDashboardTemplate
//
//  Created by girish lukka on 18/10/2025.
//


import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var vm: MainAppViewModel
    @State private var cameraPosition: MapCameraPosition = .automatic

    var body: some View {
        ZStack {
            vm.weatherCategory.backgroundGradient
            .ignoresSafeArea()
            VStack(spacing: 0) {
                // The Map
                AttractionsMap(
                    position: $cameraPosition,
                    pois: vm.pois
                )
                
                // l The List
                AttractionsList(
                    pois: vm.pois,
                    onSelect: { poi in
                        withAnimation {
                            let center = CLLocationCoordinate2D(latitude: poi.latitude, longitude: poi.longitude)
                            cameraPosition = .region(MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000))
                        }
                    }
                )
            }
        }

        .onChange(of: vm.mapRegion.center.latitude) { _, _ in updateCamera() }
        .onAppear { updateCamera() }
    }

    private func updateCamera() {
        if vm.mapRegion.span.latitudeDelta > 0 {
            cameraPosition = .region(vm.mapRegion)
        }
    }
}

#Preview {
    let vm = PreviewDependencies.makePreviewViewModel()
    MapView()
        .environmentObject(vm)
}
