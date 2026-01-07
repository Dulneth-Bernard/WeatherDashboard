//
//  VisitedPlacesView.swift
//  WeatherDashboardTemplate
//
//  Created by girish lukka on 18/10/2025.
//

import SwiftUI
import SwiftData

struct VisitedPlacesView: View {

    @EnvironmentObject var vm: MainAppViewModel
    @Environment(\.modelContext) private var context

    var body: some View {
        NavigationStack {
            Group {
                if vm.visited.isEmpty {
                    emptyState
                } else {
                    placesList
                }
            }
            .navigationTitle("Visited Places")
        }
    }
}

// MARK: - Subviews

private extension VisitedPlacesView {

    var placesList: some View {
        List {
            ForEach(vm.visited) { place in
                Button {
                    Task {
                        await vm.loadLocation(from: place)
                    }
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(place.name)
                                .font(.headline)

                            Text(
                                "Last visited: \(place.lastUsedAt.formatted(date: .abbreviated, time: .shortened))"
                            )
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
            .onDelete(perform: delete)
        }
    }

    var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "globe")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)

            Text("No places visited yet")
                .font(.headline)

            Text("Search for a city to see weather information and save it here.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    func delete(at offsets: IndexSet) {
        offsets.map { vm.visited[$0] }.forEach { place in
            vm.delete(place: place)
        }
    }
}

// MARK: - Preview

#Preview {
    let vm = PreviewDependencies.makePreviewViewModel()
    VisitedPlacesView()
        .environmentObject(vm)
}
