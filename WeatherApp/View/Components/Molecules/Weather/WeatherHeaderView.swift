import SwiftUI

struct WeatherHeaderView: View {
    let placeName: String
    let timestamp: Int?

    var body: some View {
        HStack(spacing: 4) {
            Text(placeName)
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            Spacer()
            
            if let timestamp = timestamp {
                Text(DateFormatterUtils.formattedDateTime(from: TimeInterval(timestamp)))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.top)
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.2).ignoresSafeArea()
        WeatherHeaderView(placeName: "London", timestamp: 1698754300)
            .padding()
    }
}
