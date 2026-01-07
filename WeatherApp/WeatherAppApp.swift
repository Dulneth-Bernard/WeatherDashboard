//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Dulneth Bernard on 14/12/2025.
//

import SwiftUI
import SwiftData


//struct WeatherAppApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}

@main

struct WeatherAppApp: App {

    // code to set configure ViewModel and ModelContainer
    @StateObject private var vm: MainAppViewModel
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
            NavBarView()
                .environmentObject(vm)
            //  Attach the same persistent container (not a new one!)
                .modelContainer(container)
        }
    }

}
