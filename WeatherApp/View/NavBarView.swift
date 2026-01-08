//
//  NavBarView.swift
//  WeatherDashboardTemplate
//
//  Created by girish lukka on 19/10/2025.
//


import SwiftUI
import SwiftData

struct NavBarView: View {
    @EnvironmentObject var vm: MainAppViewModel
    
    @Binding var isDarkMode: Bool
    
    var body: some View {
        
        NavigationStack {
            TabView(selection: $vm.selectedTab) {
                
                // Tab 0: Now
                CurrentWeatherView()
                    .tabItem { Label("Now", systemImage: "sun.max.fill") }
                    .tag(0)
                
                // Tab 1: Forecast
                ForecastView()
                    .tabItem { Label("Forecast", systemImage: "calendar") }
                    .tag(1)
                
                // Tab 2: Map
                MapView()
                    .tabItem { Label("Map", systemImage: "map") }
                    .tag(2)
                
                // Tab 3: Saved
                VisitedPlacesView()
                    .tabItem { Label("Saved", systemImage: "globe") }
                    .tag(3)
            }    .searchable(
                text: $vm.query,
                placement: .navigationBarDrawer(displayMode: .always), // top visible alwAYS
                prompt: "Search City (e.g. London)"
            ).toolbar {
                ToolbarItem(placement: .automatic) {
                    Button {
                        
                        withAnimation {
                            isDarkMode.toggle()
                        }
                    } label: {
                        // Change icon based on mode
                        Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                            .foregroundStyle(isDarkMode ? .yellow : .orange)
                            .font(.title3)
                    }
                }
            }
            
            
            
            .onSubmit(of: .search) {
                vm.submitQuery()
            }
            
        }
        
        .searchable(
            text: $vm.query,
            placement: .navigationBarDrawer(displayMode: .always), // Forces it to stay expanded
            prompt: "Search City"
        )
        .onSubmit(of: .search) {
            vm.submitQuery()
        }
        
        .overlay {
            if vm.isLoading {
                ZStack {
                    Color.black.opacity(0.3).ignoresSafeArea()
                    ProgressView("Fetching Weather...")
                        .padding()
                        .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        //  Global Error Alert
        .alert(item: $vm.appError) { error in
            Alert(
                title: Text("Error"),
                message: Text(error.localizedDescription),
                dismissButton: .default(Text("OK"))
            )
        }
        //  Info Alert (e.g. "Loaded from Storage")
        .alert("Info", isPresented: $vm.showInfoAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(vm.infoMessage)
        }
        
        
        
    }
}
#Preview {
    let vm = PreviewDependencies.makePreviewViewModel()
    NavBarView(isDarkMode: .constant(false))
        .environmentObject(vm)
}

