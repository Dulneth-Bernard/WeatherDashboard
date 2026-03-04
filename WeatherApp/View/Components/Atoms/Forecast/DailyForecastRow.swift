import SwiftUI

struct DailyForecastRow: View {
    let day: Daily
    var body: some View {
        HStack {
            
            Text(DateFormatterUtils.formattedDateWithWeekdayAndDay(from: TimeInterval(day.dt)))
                .fontWeight(.medium)
            
            Spacer()
            
            
            if let icon = day.weather.first?.icon {
                AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(icon).png")) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 35, height: 35)
            }
            
            
            Text("\(Int(day.temp.min))° / \(Int(day.temp.max))°")
                .foregroundStyle(.secondary)
                .frame(width: 80, alignment: .trailing)
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.visible)
    }
}

#Preview {
    
    HStack {
        Text("Monday 12")
        Spacer()
        Image(systemName: "sun.max.fill").foregroundStyle(.orange)
        Text("12° / 24°")
    }
    .padding()
    .background(Color.gray.opacity(0.3))
}
