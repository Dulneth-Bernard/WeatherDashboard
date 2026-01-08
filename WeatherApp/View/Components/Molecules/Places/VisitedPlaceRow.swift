import SwiftUI

struct VisitedPlaceRow: View {
    let placeName: String
    let lastVisited: Date
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(placeName)
                    .font(.headline)
                
                
                Text("Last visited: \(lastVisited.formatted(date: .abbreviated, time: .shortened))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    VisitedPlaceRow(
        
        placeName: "London",
        lastVisited: Date()
    )
    .padding()
    .background(Color.gray.opacity(0.2))
}
