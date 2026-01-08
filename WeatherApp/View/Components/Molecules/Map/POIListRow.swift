//
//  POIListRow.swift
//  WeatherApp
//
//  Created by Dulneth Bernard on 01/01/2026.
//


import SwiftUI
import SwiftData

struct POIListRow: View {
    let poi: AnnotationModel
    
    var body: some View {
        HStack {
            Image(systemName: "camera.fill")
                .foregroundStyle(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading) {
                Text(poi.name)
                    .font(.subheadline)
                    .bold()
                
                Text("Lat: \(String(format: "%.4f", poi.latitude))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .contentShape(Rectangle())
        .padding(.vertical, 4)
    }
}
