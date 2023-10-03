//
//  LocationDetailFeature.swift
//  ForeFlight-Exercise
//
//  Created by Michael Mendoza on 10/2/23.
//

import ComposableArchitecture

struct LocationDetailFeature: Reducer {
    enum CurrentView: Int {
        case conditions
        case forecast
    }
    
    struct State: Equatable {
        @BindingState var currentView: CurrentView = .conditions
        var weatherReport: WeatherReport
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case showWeatherConditions
        case showWeatherForecast
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .showWeatherConditions:
                state.currentView = .conditions
                return .none
            
            case .showWeatherForecast:
                state.currentView = .forecast
                return .none
            }
        }
    }
}
