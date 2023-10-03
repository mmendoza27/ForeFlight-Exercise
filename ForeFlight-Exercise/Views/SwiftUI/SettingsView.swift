//
//  SettingsView.swift
//  ForeFlight-Exercise
//
//  Created by Michael Mendoza on 9/28/23.
//

import ComposableArchitecture
import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    let store: StoreOf<SettingsFeature>
    
    struct ViewState: Equatable {
        @BindingViewState var isToggleOn: Bool
        var fetchIntervalTitle: String
        var preferredFrameworkTitle: String
        
        init(_ bindingViewStore: BindingViewStore<SettingsFeature.State>) {
            self._isToggleOn = bindingViewStore.$fetchIsOn
            
            switch bindingViewStore.fetchInterval {
            case .oneMinute:
                self.fetchIntervalTitle = "1 minute"
            case .fiveMinutes:
                self.fetchIntervalTitle = "5 minutes"
            case .fifteenMinutes:
                self.fetchIntervalTitle = "15 minutes"
            }
            
            switch bindingViewStore.preferredFramework {
            case .uiKit:
                self.preferredFrameworkTitle = "UIKit"
            case .swiftUI:
                self.preferredFrameworkTitle = "SwiftUI"
            }
        }
    }
    
    var body: some View {
        WithViewStore(self.store, observe: { ViewState($0) }) { viewStore in
            List {
                Section(Constants.Settings.fetchSectionTitle) {
                    Toggle(Constants.Settings.fetchToggleTitle, isOn: viewStore.$isToggleOn)
                    HStack {
                        Text(Constants.Settings.fetchIntervalTitle)
                        Spacer()
                        Menu(viewStore.fetchIntervalTitle) {
                            Button(Constants.Buttons.oneMinute, action: {
                                viewStore.send(.fetchIntervalChanged(newValue: .oneMinute))
                            })
                            Button(Constants.Buttons.fiveMinutes, action: {
                                viewStore.send(.fetchIntervalChanged(newValue: .fiveMinutes))
                            })
                            Button(Constants.Buttons.fifteenMinutes, action: {
                                viewStore.send(.fetchIntervalChanged(newValue: .fifteenMinutes))
                            })
                        }
                        .disabled(!viewStore.isToggleOn)
                    }
                }
                
                Section(Constants.Settings.preferredFrameworkSectionTitle) {
                    HStack {
                        Text(Constants.Settings.frameworkTypeTitle)
                        Spacer()
                        Menu(viewStore.preferredFrameworkTitle) {
                            Button(Constants.Buttons.uiKit, action: {
                                viewStore.send(.preferredFrameworkChanged(newValue: .uiKit))
                            })
                            Button(Constants.Buttons.swiftUI, action: {
                                viewStore.send(.preferredFrameworkChanged(newValue: .swiftUI))
                            })
                        }
                    }
                }
            }
            .navigationTitle(Constants.Settings.navigationTitle)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(Constants.Buttons.doneTitle, action: { dismiss() })
                        .bold()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView(
            store: Store(initialState: .preview) {
                SettingsFeature()
            }
        )
    }
}
