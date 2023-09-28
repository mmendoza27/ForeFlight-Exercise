//
//  LocationDetailsView.swift
//  ForeFlight-Exercise
//
//  Created by Michael Mendoza on 9/28/23.
//

import SwiftUI

struct LocationDetailsView: View {
    enum PickerItem: Int {
        case conditions
        case forecast
    }
    
    var weatherReport: WeatherReport
    
    @State private var selectedPickerIndex = 0
    
    var body: some View {
        VStack {
            Picker("Picker", selection: $selectedPickerIndex) {
                Text("Conditions")
                    .tag(0)
                Text("Forecast")
                    .tag(1)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 64.0)
            
            LocationDetailsInformationView(
                pickerItem: Binding(
                    get: { PickerItem(rawValue: selectedPickerIndex)! },
                    set: { item in selectedPickerIndex = item.rawValue }
                ),
                weatherReport: weatherReport
            )
            
            Spacer()
            
            Text("Last updated at \(weatherReport.lastUpdated)")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .navigationTitle(weatherReport.forecast.identifier.uppercased())
        .background(Color(uiColor: .systemGroupedBackground))
    }
}

private struct LocationDetailsInformationView: View {
    @Binding var pickerItem: LocationDetailsView.PickerItem
    var weatherReport: WeatherReport
    
    var body: some View {
        switch pickerItem {
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
        weatherReport: WeatherReport(
            from: PreviewData.sanAntonio
        )
    )
}
