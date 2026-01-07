//
//  MapView.swift
//  WeatherDashboardTemplate
//
//  Created by girish lukka on 18/10/2025.
//

//import SwiftUI
//import SwiftData
//
//import MapKit

//struct MapView: View {
//
//    @EnvironmentObject var vm: MainAppViewModel
//    @State private var cameraPosition: MapCameraPosition = .automatic
//
//    var body: some View {
//        ZStack {
//            Map(position: $cameraPosition) {
//                ForEach(vm.pois) { poi in
//                    Marker(
//                        poi.name,
//                        coordinate: CLLocationCoordinate2D(
//                            latitude: poi.latitude,
//                            longitude: poi.longitude
//                        )
//                    )
//                }
//            }
//            // 👇 Observe Equatable values instead of MapKit types
//            .onChange(of: vm.mapRegion.center.latitude) { _, _ in
//                updateCamera()
//            }
//            .onChange(of: vm.mapRegion.center.longitude) { _, _ in
//                updateCamera()
//            }
//            .edgesIgnoringSafeArea(.all)
//
//            VStack {
//                if !vm.activePlaceName.isEmpty {
//                    Text(vm.activePlaceName)
//                        .font(.headline)
//                        .padding(.horizontal, 12)
//                        .padding(.vertical, 6)
//                        .background(.ultraThinMaterial, in: Capsule())
//                        .padding(.top, 12)
//                }
//                Spacer()
//            }
//        }
//        .navigationTitle("Map")
//        .onAppear {
//            updateCamera()
//        }
//    }
//
//    private func updateCamera() {
//        cameraPosition = .region(vm.mapRegion)
//    }
//}

//#Preview {
//    let vm = MainAppViewModel(context: ModelContext(ModelContainer.preview))
//    MapView()
//        .environmentObject(vm)
//}


import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var vm: MainAppViewModel
    @State private var cameraPosition: MapCameraPosition = .automatic

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // 1. MAP SECTION
                Map(position: $cameraPosition) {
                    ForEach(vm.pois) { poi in
                        Annotation(poi.name, coordinate: CLLocationCoordinate2D(latitude: poi.latitude, longitude: poi.longitude)) {
                            // Custom Annotation View to support gestures
                            VStack {
                                Image(systemName: "mappin.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.red)
                                    .background(.white)
                                    .clipShape(Circle())
                            }
                            // INTERACTION: Tap to Zoom (500m)
                            .onTapGesture {
                                withAnimation {
                                    let center = CLLocationCoordinate2D(latitude: poi.latitude, longitude: poi.longitude)
                                    cameraPosition = .region(MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500))
                                }
                            }
                            // INTERACTION: Context Menu for Google Search
                            .contextMenu {
                                Button {
                                    openGoogleMaps(query: poi.name)
                                } label: {
                                    Label("Search on Google", systemImage: "magnifyingglass")
                                }
                            }
                        }
                    }
                }
                .frame(height: 400) // Fixed height for map, or use geometry reader
                .cornerRadius(20)
                .padding(10)
                
                // 2. LIST SECTION
                VStack(alignment: .leading) {
                    Text("Nearby Attractions")
                        .font(.headline)
                        .padding(.horizontal)
                        .padding(.top, 10)
                    
                    if vm.pois.isEmpty {
                        ContentUnavailableView("No POIs Found", systemImage: "mappin.slash")
                    } else {
                        List(vm.pois) { poi in
                            HStack {
                                Image(systemName: "camera.fill")
                                    .foregroundStyle(.blue)
                                VStack(alignment: .leading) {
                                    Text(poi.name).font(.subheadline).bold()
                                    Text("Lat: \(String(format: "%.4f", poi.latitude))")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right").font(.caption)
                            }
                            .contentShape(Rectangle())
                            // INTERACTION: Tap list item to center map
                            .onTapGesture {
                                withAnimation {
                                    let center = CLLocationCoordinate2D(latitude: poi.latitude, longitude: poi.longitude)
                                    // "Center the map" usually implies a standard zoom, but we can stick to current or zoom in slightly
                                    cameraPosition = .region(MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000))
                                }
                            }
                            .listRowBackground(Color.white.opacity(0.5))
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                }
                .background(Color.white.opacity(0.3)) // Slight tint for list area
            }
        }
        // Gradient Background
        .background(
            LinearGradient(
                colors: [Color(red: 0.74, green: 0.82, blue: 0.95), Color(red: 0.98, green: 0.85, blue: 0.80)],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .navigationTitle("Map")
        .onChange(of: vm.mapRegion.center.latitude) { _, _ in updateCamera() }
        .onAppear { updateCamera() }
    }

    private func updateCamera() {
        // Only update if region is valid
        if vm.mapRegion.span.latitudeDelta > 0 {
            cameraPosition = .region(vm.mapRegion)
        }
    }
    
    private func openGoogleMaps(query: String) {
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: "https://www.google.com/search?q=\(encoded)") {
            UIApplication.shared.open(url)
        }
    }
}
