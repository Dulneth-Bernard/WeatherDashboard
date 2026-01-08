import SwiftUI
import MapKit

struct AttractionsMap: View {
    @Binding var position: MapCameraPosition
    let pois: [AnnotationModel] // ✅ Correct type
    
    var body: some View {
        Map(position: $position) {
            ForEach(pois) { poi in
                Annotation(poi.name, coordinate: CLLocationCoordinate2D(latitude: poi.latitude, longitude: poi.longitude)) {
                    
                    // Use Molecule
                    POIAnnotationVisual()
                        .onTapGesture {
                            withAnimation {
                                let center = CLLocationCoordinate2D(latitude: poi.latitude, longitude: poi.longitude)
                                position = .region(MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500))
                            }
                        }
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
        .frame(height: 400)
        .cornerRadius(20)
        .padding(10)
    }
    
    private func openGoogleMaps(query: String) {
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: "https://www.google.com/search?q=\(encoded)") {
            UIApplication.shared.open(url)
        }
    }
}