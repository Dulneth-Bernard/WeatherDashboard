//
//  DetailsViewCard.swift
//  WeatherApp
//
//  Created by Dulneth Bernard on 03/01/2026.
//

import SwiftUI

struct DetailsViewCard: View {
    var current: Current?
    var body: some View {
        VStack(alignment: .leading,spacing: 12) {
            Text("Details")
                .font(.headline)
                .foregroundStyle(.secondary)
                .padding(.bottom, 4)
            
            DetailRow(title: "Pressure", value: "\(current?.pressure ?? 0) hPa", icon: "barometer")
            DetailRow(title: "Sunrise",
                      value: DateFormatterUtils.formattedDate12Hour(
                        from: TimeInterval(current?.sunrise ?? 0)
                      ),
                      icon: "sunrise.fill")
            DetailRow(title: "Sunset",value:  DateFormatterUtils.formattedDate12Hour(
                from: TimeInterval(current?.sunset ?? 0)
            ), icon: "sunset.fill")
            
            
        }
        .padding()
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 16)
        )
    }
}

#Preview {
    DetailsViewCard()
}
