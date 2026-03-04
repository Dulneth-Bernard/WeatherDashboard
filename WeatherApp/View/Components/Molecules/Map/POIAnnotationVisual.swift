//
//  POIAnnotationVisual.swift
//  WeatherApp
//
//  Created by Dulneth Bernard on 03/01/2026.
//


import SwiftUI

struct POIAnnotationVisual: View {
    var body: some View {
        VStack {
            Image(systemName: "mappin.circle.fill")
                .font(.title)
                .foregroundColor(.red)
                .background(.white)
                .clipShape(Circle())
                .shadow(radius: 2)
        }
    }
}

#Preview {
    POIAnnotationVisual()
}
