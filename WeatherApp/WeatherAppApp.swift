//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Dulneth Bernard on 14/12/2025.
//

import SwiftUI
import SwiftData


@main
struct WeatherAppApp: App {

    // code to set configure ViewModel and ModelContainer
    @StateObject private var vm: MainAppViewModel
    @AppStorage("darkMode") private var isDarkMode: Bool = false
    private let container: ModelContainer
    init() {

        //  Define schema for all models
        let schema = Schema([Place.self, AnnotationModel.self])

        //  Persistent (on-disk) configuration
        let configuration = ModelConfiguration(isStoredInMemoryOnly: false)
        self.container = try! ModelContainer(for: schema, configurations: [configuration])

        //  Create main model context
        let context = ModelContext(container)
        let networkService = DefaultNetwork()
        _vm = StateObject(wrappedValue: MainAppViewModel(context: context, networkService: networkService))


    }

    var body: some Scene {
        WindowGroup {
            NavBarView(isDarkMode: $isDarkMode)
                .environmentObject(vm)
            //  Attach the same persistent container (not a new one!)
                .modelContainer(container)
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }

}
