import SwiftUI

struct WeatherDescriptionView: View {
    let description: String
    let maxTemp: Double
    let minTemp: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(description.capitalized)
                .font(.title3)
            
            HStack(spacing: 20) {
                Label("\(Int(maxTemp))°", systemImage: "arrow.up")
                Label("\(Int(minTemp))°", systemImage: "arrow.down")
                Spacer()
            }
            .font(.body.weight(.medium))
            .foregroundStyle(.black)
        }
    }
}

#Preview {
    WeatherDescriptionView(
        description: "Scattered Clouds",
        maxTemp: 28,
        minTemp: 18
    )
    .padding()
}
