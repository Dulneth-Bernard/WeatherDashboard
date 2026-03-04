//
//  PreviewHelper.swift
//  WeatherApp
//
//  Created by Dulneth Bernard on 28/12/2025.
//

import Foundation
import SwiftData

extension ModelContainer {
    static var preview: ModelContainer {
        do {
            // Use your models here — add all models you use in SwiftData
            let schema = Schema([Place.self, AnnotationModel.self])
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Failed to create preview container: \(error)")
        }
    }
}
