//
//  MapView.swift
//  WeatherDashboardTemplate
//
//  Created by girish lukka on 18/10/2025.
//

import SwiftUI
import SwiftData

import MapKit

struct MapView: View {

    @EnvironmentObject var vm: MainAppViewModel
    @State private var cameraPosition: MapCameraPosition = .automatic

    var body: some View {
        ZStack {
            Map(position: $cameraPosition) {
                ForEach(vm.pois) { poi in
                    Marker(
                        poi.name,
                        coordinate: CLLocationCoordinate2D(
                            latitude: poi.latitude,
                            longitude: poi.longitude
                        )
                    )
                }
            }
            // 👇 Observe Equatable values instead of MapKit types
            .onChange(of: vm.mapRegion.center.latitude) { _, _ in
                updateCamera()
            }
            .onChange(of: vm.mapRegion.center.longitude) { _, _ in
                updateCamera()
            }
            .edgesIgnoringSafeArea(.all)

            VStack {
                if !vm.activePlaceName.isEmpty {
                    Text(vm.activePlaceName)
                        .font(.headline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.ultraThinMaterial, in: Capsule())
                        .padding(.top, 12)
                }
                Spacer()
            }
        }
        .navigationTitle("Map")
        .onAppear {
            updateCamera()
        }
    }

    private func updateCamera() {
        cameraPosition = .region(vm.mapRegion)
    }
}

//#Preview {
//    let vm = MainAppViewModel(context: ModelContext(ModelContainer.preview))
//    MapView()
//        .environmentObject(vm)
//}
