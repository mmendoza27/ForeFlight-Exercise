//
//  LocationsView.swift
//  ForeFlight-Exercise
//
//  Created by Michael Mendoza on 9/28/23.
//

import ComposableArchitecture
import SwiftUI

struct LocationsView: View {
    let store: StoreOf<AppFeature>
    
    var body: some View {
        NavigationStackStore(store.scope(state: \.path, action: { .path($0 ) })) {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                List(viewStore.weatherReports) { weatherReport in
                    NavigationLink(state: LocationDetailFeature.State(weatherReport: weatherReport)) {
                        Text(weatherReport.forecast.identifier.uppercased())
                        Spacer()
                    }
                }
                .navigationTitle(Constants.Locations.navigationTitle)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: { viewStore.send(.settingsButtonTapped) }) {
                            Image(symbol: .gearshapeCircleFill)
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: { viewStore.send(.addButtonTapped) }) {
                            Image(symbol: .plusCircleFill)
                        }
                    }
                }
                .symbolRenderingMode(.hierarchical)
                .task {
                    await viewStore.send(.retrieveWeatherReports).finish()
                }
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 8.0)
                        .frame(width: 100.0, height: 100.0, alignment: .center)
                        .opacity(0.5)
                        .overlay {
                            ProgressView()
                                .controlSize(.large)
                        }
                        .opacity(viewStore.newLocationRequestInFlight ? 1.0 : 0.0)
                })
            }
        } destination: { store in
            LocationDetailsView(store: store)
        }
        .sheet(store: store.scope(state: \.$settings, action: { .settings($0) })) { settingsStore in
            NavigationStack {
                SettingsView(store: settingsStore)
            }
        }
        .alert(store: store.scope(state: \.$addNewLocationAlert, action: { .alert($0) }))
    }
}

#Preview {
    NavigationStack {
        LocationsView(
            store: Store(initialState: AppFeature.State()) {
                AppFeature()
            }
        )
    }
}
