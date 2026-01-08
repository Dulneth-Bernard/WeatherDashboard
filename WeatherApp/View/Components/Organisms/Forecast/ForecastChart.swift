import SwiftUI
import Charts

struct ForecastChart: View {
    let data: [TempData]

    var body: some View {
        VStack(alignment: .leading) {
            Text("8-Day Forecast")
                .font(.headline)
                .padding(.horizontal)
                .padding(.bottom, 5)
            
            Chart(data) { item in
                BarMark(
                    x: .value("Day", item.dayName),
                    yStart: .value("Min", item.min),
                    yEnd: .value("Max", item.max)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [item.category.color.opacity(0.8), item.category.color.opacity(0.3)],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                .cornerRadius(4)
            }
            .chartYAxis { AxisMarks(position: .leading) }
            .frame(height: 220)
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal)
        }
    }
}

#Preview {
    // Mock Data for Preview
    let mockData = [
        TempData(dayName: "Mon", min: 10, max: 20, category: .mild),
        TempData(dayName: "Tue", min: 12, max: 24, category: .warm),
        TempData(dayName: "Wed", min: 8,  max: 15, category: .mild),
        TempData(dayName: "Thu", min: 5,  max: 12, category: .cold)
    ]
    
    ZStack {
        Color.blue.opacity(0.2).ignoresSafeArea()
        ForecastChart(data: mockData)
    }
}
