//
//  CachingClient.swift
//  ForeFlight-Exercise
//
//  Created by Michael Mendoza on 10/2/23.
//

import Dependencies
import Foundation

struct CachingClient {
    var retrieveSettings: () -> Settings
    var updateSettingsValue: (_ value: Int, _ key: UserDefaultsKeys) -> ()
    var retrieveSettingValue: (_ key: UserDefaultsKeys) -> Int
    var retrieveAirportLocations: () -> [String]
    var updateAirportLocations: (_ values: [String]) -> ()
    var removeAirportLocation: (_ identifier: String) -> ()
}

extension CachingClient {
    static var live: CachingClient {
        let userDefaults = UserDefaults.standard
        
        return CachingClient(
            retrieveSettings: {
                let retrievalType = Settings.RetrievalType(
                    rawValue: userDefaults.integer(forKey: UserDefaultsKeys.retrievalType.rawValue)
                )
                let fetchInterval = Settings.FetchInterval(
                    rawValue: userDefaults.integer(forKey: UserDefaultsKeys.fetchInterval.rawValue)
                )
                let userInterfaceFramework = Settings.UserInterfaceFramework(
                    rawValue: userDefaults.integer(forKey: UserDefaultsKeys.userInterfaceFramework.rawValue)
                )
                
                return Settings(
                    retrievalType: retrievalType ?? .pull,
                    fetchInterval: fetchInterval ?? .oneMinute,
                    userInterfaceFramework: userInterfaceFramework ?? .uiKit
                )
            },
            updateSettingsValue: { newValue, key in
                userDefaults.setValue(newValue, forKey: key.rawValue)
            },
            retrieveSettingValue: { key in
                userDefaults.integer(forKey: key.rawValue)
            },
            retrieveAirportLocations: {
                (userDefaults.array(forKey: UserDefaultsKeys.requestedAirports.rawValue) as? [String]) ?? ["KAUS", "KPWM"]
            },
            updateAirportLocations: { newValues in
                let existingValues = userDefaults.array(forKey: UserDefaultsKeys.requestedAirports.rawValue) as? [String]
                var updatedValues: Set<String> = []
                
                if let existingValues {
                    updatedValues.formUnion(existingValues)
                }
                
                updatedValues.formUnion(newValues)
                
                let values = Array(updatedValues)
                userDefaults.setValue(values, forKey: UserDefaultsKeys.requestedAirports.rawValue)
            },
            removeAirportLocation: { valueToRemove in
                let existingValues = userDefaults.array(forKey: UserDefaultsKeys.requestedAirports.rawValue) as? [String]
                var updatedValues: Set<String> = []
                
                if let existingValues {
                    updatedValues.formUnion(existingValues)
                }
                
                updatedValues.subtract([valueToRemove])
                
                let values = Array(updatedValues)
                userDefaults.setValue(values, forKey: UserDefaultsKeys.requestedAirports.rawValue)
            }
        )
    }
    
    static var preview: CachingClient {
        return CachingClient(
            retrieveSettings: {
                return Settings(
                    retrievalType: .pull,
                    fetchInterval: .oneMinute,
                    userInterfaceFramework: .uiKit
                )
            },
            updateSettingsValue: { _, _ in },
            retrieveSettingValue: { _ in 0 },
            retrieveAirportLocations: { ["KAUS", "KPWM"] },
            updateAirportLocations: { _ in },
            removeAirportLocation: { _ in }
        )
    }
    
    static var test: CachingClient {
        CachingClient(
            retrieveSettings: unimplemented("CachingClient.retrieveSettings is unimplemented."),
            updateSettingsValue: unimplemented("CachingClient.updateSettingsValue is unimplemented."),
            retrieveSettingValue: unimplemented("CachingClient.retrieveSettingValue is unimplemented."),
            retrieveAirportLocations: unimplemented("CachingClient.retrieveAirportLocations is unimplemented."),
            updateAirportLocations: unimplemented("CachingClient.updateAirportLocations is unimplemented."),
            removeAirportLocation: unimplemented("CachingClient.removeAirportLocation is unimplemented.")
        )
    }
}

enum CachingClientKey: DependencyKey, TestDependencyKey {
    static let liveValue = CachingClient.live
    static let previewValue = CachingClient.preview
    static let testValue = CachingClient.test
}

extension DependencyValues {
    var cachingClient: CachingClient {
        get { self[CachingClientKey.self] }
        set { self[CachingClientKey.self] = newValue }
    }
}
