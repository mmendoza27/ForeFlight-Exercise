//
//  SettingsFeature.swift
//  ForeFlight-Exercise
//
//  Created by Michael Mendoza on 10/2/23.
//

import ComposableArchitecture

struct SettingsFeature: Reducer {
    struct State: Equatable {
        @BindingState var fetchIsOn: Bool = false
        
        var fetchInterval: Settings.FetchInterval
        var preferredFramework: Settings.UserInterfaceFramework
        var retrievalType: Settings.RetrievalType
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case fetchIntervalChanged(newValue: Settings.FetchInterval)
        case preferredFrameworkChanged(newValue: Settings.UserInterfaceFramework)
        case retrievalTypeChanged(newValue: Settings.RetrievalType)
        
    }
    
    @Dependency(\.cachingClient) var cachingClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case let .fetchIntervalChanged(newValue):
                state.fetchInterval = newValue
                cachingClient.updateSettingsValue(newValue.rawValue, .fetchInterval)
                return .none
                
            case let .preferredFrameworkChanged(newValue):
                state.preferredFramework = newValue
                cachingClient.updateSettingsValue(newValue.rawValue, .userInterfaceFramework)
                return .none
                
            case let .retrievalTypeChanged(newValue):
                state.retrievalType = newValue
                cachingClient.updateSettingsValue(newValue.rawValue, .retrievalType)
                return .none
            }
        }
    }
}

extension SettingsFeature.State {
    static var preview: Self {
        Self(fetchIsOn: false, fetchInterval: .oneMinute, preferredFramework: .swiftUI, retrievalType: .pull)
    }
}
