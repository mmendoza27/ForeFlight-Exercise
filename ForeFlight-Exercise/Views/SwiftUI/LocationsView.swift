//
//  LocationsView.swift
//  ForeFlight-Exercise
//
//  Created by Michael Mendoza on 9/28/23.
//

import SwiftUI

struct LocationsView: View {
    @State private var showSettings: Bool = false
    @State private var attemptToAddLocation: Bool = false
    @State private var newLocationRequestInFlight: Bool = false
    @State private var newLocationInput: String = ""
    @State private var weatherReports: [WeatherReport] = [WeatherReport(from: PreviewData.sanAntonio)]
    
    var weatherReportService = WeatherReportService()
    
    var body: some View {
        NavigationStack {
            List(weatherReports, id: \.forecast.identifier) { weatherReport in
                NavigationLink(weatherReport.forecast.identifier.uppercased(), value: weatherReport)
            }
            .navigationDestination(for: WeatherReport.self, destination: { weatherReport in
                LocationDetailsView(weatherReport: weatherReport)
            })
            .navigationTitle("Locations")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { showSettings.toggle() }) {
                        Image(symbol: .gearshapeCircleFill)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { attemptToAddLocation.toggle() }) {
                        Image(symbol: .plusCircleFill)
                    }
                }
            }
            .symbolRenderingMode(.hierarchical)
            .task {
                do {
                    weatherReports = try await weatherReportService.retrieveWeatherReports(for: ["kwpm", "kaus"]).value
                } catch {
                    /* Do something with the error. */
                }
            }
        }
        .overlay(content: {
            RoundedRectangle(cornerRadius: 8.0)
                .frame(width: 100.0, height: 100.0, alignment: .center)
                .opacity(0.5)
                .overlay {
                    ProgressView()
                        .controlSize(.large)
                }
                .opacity(newLocationRequestInFlight ? 1.0 : 0.0)
        })
        .alert("Add New Location", isPresented: $attemptToAddLocation, actions: {
            TextField("", text: $newLocationInput)
            Button("Cancel", role: .cancel, action: { })
            Button("Add", action: {
                Task {
                    await attemptToAddNewLocation(input: newLocationInput)
                }
            })
        })
        .sheet(isPresented: $showSettings, content: {
            NavigationStack {
                SettingsView()                
            }
        })
    }
    
    func attemptToAddNewLocation(input: String) async {
        do {
            newLocationRequestInFlight = true
            let weatherReport = try await weatherReportService.retrieveWeatherReport(for: input).value
            weatherReports.append(weatherReport)
            newLocationRequestInFlight = false
        } catch {
            /* Do something with the error. */
        }
    }
}

#Preview {
    LocationsView()
}
