//
//  SettingsView.swift
//  ForeFlight-Exercise
//
//  Created by Michael Mendoza on 9/28/23.
//

import SwiftUI

struct SettingsView: View {
    @State private var settings = Settings(
        retrievalType: .pull,
        fetchInterval: .oneMinute,
        userInterfaceFramework: .swiftUI
    )
    
    @Environment(\.dismiss) var dismiss
    
    var fetchToggleState: Binding<Bool> {
        Binding(
            get: { settings.retrievalType == .fetch },
            set: { newValue in
                if newValue {
                    settings.retrievalType = .fetch
                } else {
                    settings.retrievalType = .pull
                }
            }
        )
    }
    
    var fetchIntervalTitle: String {
        switch settings.fetchInterval {
        case .oneMinute:
            "1 minute"
        case .fiveMinutes:
            "5 minutes"
        case .fifteenMinutes:
            "15 minutes"
        }
    }
    
    var uiFrameworkTitle: String {
        switch settings.userInterfaceFramework {
        case .uiKit:
            "UI Kit"
        case .swiftUI:
            "Swift UI"
        }
    }
    
    var body: some View {
        List {
            Section("Automatic Updates") {
                Toggle(
                    "Fetch New Data Automatically",
                    isOn: fetchToggleState
                )
                HStack {
                    Text("Fetch Interval")
                    Spacer()
                    Menu(fetchIntervalTitle) {
                        Button("1 minute", action: { settings.fetchInterval = .oneMinute })
                        Button("5 minutes", action: { settings.fetchInterval = .fiveMinutes })
                        Button("15 minutes", action: { settings.fetchInterval = .fifteenMinutes })
                    }
                    .disabled(!fetchToggleState.wrappedValue)
                }
            }
            
            Section("UI Framework") {
                HStack {
                    Text("Type")
                    Spacer()
                    Menu(uiFrameworkTitle) {
                        Button("UIKit", action: { settings.userInterfaceFramework = .uiKit })
                        Button("SwiftUI", action: { settings.userInterfaceFramework = .swiftUI })
                    }
                }
            }
        }
        .navigationTitle("Settings")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done", action: { dismiss() })
                    .bold()
            }
        }
    }
}

private struct MenuItemRow: View {
    var title: String
    
    var body: some View {
        HStack {
            Menu {
                Text("1 minute")
                Text("5 minute")
                Text("15 minute")
            } label: {
                Text(title)
            }

        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
