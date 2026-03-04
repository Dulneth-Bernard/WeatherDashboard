import SwiftUI

struct DetailRow: View {
    var title:String
    var value:String
    var icon:String
    var body: some View {
        HStack {
            
            Image(systemName: icon)
            
            Text(title)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
        }
        .font(.subheadline)
    }
}

#Preview {
    DetailRow(title: "Information", value: "12", icon: "cloud.rain")
}

