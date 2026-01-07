//
//  AdvisoryCard.swift
//  WeatherDashboardTemplate
//
//  Created by Dulneth Bernard on 07/01/2026.
//

import SwiftUI

struct AdvisoryCard: View {
    var icon = "cloud.rain"
    var advice: String
    var iconColor: Color
    
    var body: some View {
        
        HStack(spacing: 12) {
            Image(systemName: icon)
                .symbolVariant(.fill)
                .font(.title3)
                .foregroundStyle(iconColor)

            Text(advice)
                .font(.callout)
                .multilineTextAlignment(.leading)
        }
        .padding()
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 14)
        )
    }
}

#Preview {
    AdvisoryCard(advice: "Its raining", iconColor: .brown)
}
