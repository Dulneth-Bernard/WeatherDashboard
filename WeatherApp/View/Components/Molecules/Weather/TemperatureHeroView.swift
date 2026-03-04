import SwiftUI

struct TemperatureHeroView: View {
    let temperature: Double
    let iconName: String
    let iconColor: Color

    var body: some View {
        HStack {
            Text("\(Int(temperature))°")
                .font(.system(size: 108, weight: .medium))
                .minimumScaleFactor(0.5)
            
            Spacer()
            
            Image(systemName: iconName)
                .font(.system(size: 68))
                .foregroundStyle(iconColor)
        }
        .padding(.horizontal, 48)
    }
}

#Preview {
    TemperatureHeroView(
        temperature: 25,
        iconName: "sun.max.fill",
        iconColor: .orange
    )
    .background(Color.gray.opacity(0.1))
}
