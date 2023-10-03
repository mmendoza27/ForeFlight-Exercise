//
//  LocationDetailsView.swift
//  ForeFlight-Exercise
//
//  Created by Michael Mendoza on 9/28/23.
//

import ComposableArchitecture
import SwiftUI

struct LocationDetailsView: View {
    let store: StoreOf<LocationDetailFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                Picker("Picker", selection: viewStore.$currentView) {
                    Text("Conditions")
                        .tag(LocationDetailFeature.CurrentView.conditions)
                    Text("Forecast")
                        .tag(LocationDetailFeature.CurrentView.forecast)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 64.0)
                
                LocationDetailsInformationView(
                    currentView: viewStore.$currentView,
                    weatherReport: viewStore.weatherReport
                )
                
                Spacer()
                
                Text("Last updated at \(viewStore.weatherReport.lastUpdated)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .navigationTitle(viewStore.weatherReport.forecast.identifier.uppercased())
            .background(Color(uiColor: .systemGroupedBackground))
        }
    }
}

private struct LocationDetailsInformationView: View {
    @Binding var currentView: LocationDetailFeature.CurrentView
    var weatherReport: WeatherReport
    
    var body: some View {
        switch currentView {
        case .conditions:
            List {
                LocationDetailsInformationRowView(
                    title: "Text",
                    value: weatherReport.conditions.text
                )
                LocationDetailsInformationRowView(
                    title: "Identifier",
                    value: weatherReport.conditions.identifier
                )
                LocationDetailsInformationRowView(
                    title: "Date Issued",
                    value: weatherReport.conditions.dateIssued.description
                )
                LocationDetailsInformationRowView(
                    title: "Latitude",
                    value: weatherReport.conditions.latitude.description
                )
                LocationDetailsInformationRowView(
                    title: "Longitude",
                    value: weatherReport.conditions.longitude.description
                )
                LocationDetailsInformationRowView(
                    title: "Elevation",
                    value: weatherReport.conditions.elevation.description
                )
                LocationDetailsInformationRowView(
                    title: "Temperature",
                    value: weatherReport.conditions.temperature.description
                )
                LocationDetailsInformationRowView(
                    title: "Dewpoint",
                    value: weatherReport.conditions.dewpoint.description
                )
                LocationDetailsInformationRowView(
                    title: "Pressure",
                    value: weatherReport.conditions.pressure.description
                )
                LocationDetailsInformationRowView(
                    title: "Humidity",
                    value: weatherReport.conditions.humidity.description
                )
            }
        case .forecast:
            List {
                LocationDetailsInformationRowView(
                    title: "Text",
                    value: weatherReport.forecast.text
                )
                LocationDetailsInformationRowView(
                    title: "Identifier",
                    value: weatherReport.forecast.identifier
                )
                LocationDetailsInformationRowView(
                    title: "Date Issued",
                    value: weatherReport.forecast.dateIssued.description
                )
                LocationDetailsInformationRowView(
                    title: "Latitude",
                    value: weatherReport.forecast.latitude.description
                )
                LocationDetailsInformationRowView(
                    title: "Longitude",
                    value: weatherReport.forecast.longitude.description
                )
                LocationDetailsInformationRowView(
                    title: "Elevation",
                    value: weatherReport.forecast.elevation.description
                )
            }
        }
    }
}

private struct LocationDetailsInformationRowView: View {
    var title: String
    var value: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .multilineTextAlignment(.trailing)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    LocationDetailsView(
        store: Store(
            initialState: LocationDetailFeature.State(
                weatherReport: WeatherReport(
                    from: PreviewData.sanAntonio
                )
            ), 
            reducer: {
                LocationDetailFeature()
            }
        )
    )
}
