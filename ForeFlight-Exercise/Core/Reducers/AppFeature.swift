//
//  AppFeature.swift
//  ForeFlight-Exercise
//
//  Created by Michael Mendoza on 10/2/23.
//

import ComposableArchitecture

struct AppFeature: Reducer {
    struct State: Equatable {
        @PresentationState var addNewLocationAlert: AlertState<Action.Alert>?
        @PresentationState var settings: SettingsFeature.State?
        
        @BindingState var airportIdentifier: String = ""
        @BindingState var attemptToAddNewLocation: Bool = false
        @BindingState var newLocationRequestInFlight: Bool = false
        
        var path = StackState<LocationDetailFeature.State>()
        var weatherReports: IdentifiedArrayOf<WeatherReport> = []
    }
    
    enum Action {
        case addButtonTapped
        case alert(PresentationAction<Alert>)
        case path(StackAction<LocationDetailFeature.State, LocationDetailFeature.Action>)
        case retrieveWeatherReports
        case settings(PresentationAction<SettingsFeature.Action>)
        case settingsButtonTapped
        case updateWeatherReports(reports: IdentifiedArrayOf<WeatherReport>)
        
        enum Alert: Equatable {
            case cancel
            case attemptToAddNewLocation(airportIdentifier: String)
        }
    }
    
    @Dependency(\.weatherReportClient) var weatherReportClient
    @Dependency(\.cachingClient) var cachingClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                state.addNewLocationAlert = AlertState(
                    title: TextState("Add New Location"),
                    primaryButton: ButtonState(
                        action: .attemptToAddNewLocation(airportIdentifier: "KSAT"),
                        label: { TextState("Add") }
                    ),
                    secondaryButton: ButtonState(
                        role: .cancel,
                        action: .cancel,
                        label: { TextState("Cancel") }
                    )
                )
                
                return .none
            
            case .alert(.dismiss):
                state.addNewLocationAlert = nil
                return .none
                
            case .alert(.presented(.cancel)):
                return .none
                
            case let .alert(.presented(.attemptToAddNewLocation(airportIdentifier))):
                state.newLocationRequestInFlight = true
                
                return .run { send in
                    let report = try await self.weatherReportClient.retreiveWeatherReport(airportIdentifier)
                    await send(.updateWeatherReports(reports: [report]))
                }
            
            case .path:
                return .none
            
            case .retrieveWeatherReports:
                state.newLocationRequestInFlight = true
                return .run { send in
                    let reports = try await self.weatherReportClient.retrieveWeatherReports(["KPWM", "KAUS"])
                    await send(.updateWeatherReports(reports: reports))
                }
                
            case .settings:
                return .none
                
            case .settingsButtonTapped:
                let retrievalType = Settings.RetrievalType(
                    rawValue: cachingClient.retrieveSettingValue(.retrievalType)
                ) ?? .pull
                
                let fetchInterval = Settings.FetchInterval(
                    rawValue: cachingClient.retrieveSettingValue(.fetchInterval)
                ) ?? .oneMinute
                
                let preferredFramework = Settings.UserInterfaceFramework(
                    rawValue: cachingClient.retrieveSettingValue(.userInterfaceFramework)
                ) ?? .uiKit
                
                state.settings = SettingsFeature.State(
                    fetchIsOn: retrievalType == .fetch,
                    fetchInterval: fetchInterval,
                    preferredFramework: preferredFramework,
                    retrievalType: retrievalType
                )
                
                return .none
                
            case let .updateWeatherReports(updatedReports):
                state.weatherReports.append(contentsOf: updatedReports)
                state.newLocationRequestInFlight = false
                return .none
                
            }
        }
        .ifLet(\.$settings, action: /Action.settings) {
            SettingsFeature()
        }
        .forEach(\.path, action: /Action.path) {
            LocationDetailFeature()
        }
    }
    
}
