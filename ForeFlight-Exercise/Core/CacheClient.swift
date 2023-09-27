//
//  CacheClient.swift
//  ForeFlight-Exercise
//
//  Created by Michael Mendoza on 9/26/23.
//

import Foundation
import OSLog

class CacheClient {
    static let shared = CacheClient()
    
    // MARK: - Properties
    public let weatherReportsCache: NSCache<NSString, CacheEntryObject> = NSCache()
    
    private let logger = Logger()
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Caching: Settings
    func restoreSettingsFromCache() -> Settings {
        let retrievalType = Settings.RetrievalType(rawValue: retrieveSetting(for: .retrievalType))
        let fetchInterval = Settings.FetchInterval(rawValue: retrieveSetting(for: .fetchInterval))
        let userInterfaceFramework = Settings.UserInterfaceFramework(rawValue: retrieveSetting(for: .userInterfaceFramework))
        
        return Settings(
            retrievalType: retrievalType ?? .pull,
            fetchInterval: fetchInterval ?? .oneMinute,
            userInterfaceFramework: userInterfaceFramework ?? .uiKit
        )
    }
    
    func updateSetting(_ value: Int, for key: UserDefaultsKeys) {
        userDefaults.setValue(value, forKey: key.rawValue)
    }
    
    func retrieveSetting(for key: UserDefaultsKeys) -> Int {
        userDefaults.integer(forKey: key.rawValue)
    }
    
    // MARK: - Caching: Airport Locations
    func addAirportLocation(_ value: String, for key: UserDefaultsKeys) {
        let existingValues = userDefaults.array(forKey: key.rawValue) as? [String]
        var updatedValues: Set<String> = []
        
        if let existingValues {
            updatedValues.formUnion(existingValues)
        }
        
        updatedValues.insert(value)
        
        let values = Array(updatedValues)
        userDefaults.setValue(values, forKey: key.rawValue)
        logger.log("\(values)")
    }
    
    func addAirportLocations(_ values: [String], for key: UserDefaultsKeys) {
        let existingValues = userDefaults.array(forKey: key.rawValue) as? [String]
        var updatedValues: Set<String> = []
        
        if let existingValues {
            updatedValues.formUnion(existingValues)
        }
        
        updatedValues.formUnion(values)
        
        let values = Array(updatedValues)
        userDefaults.setValue(values, forKey: key.rawValue)
        logger.log("\(values)")
    }
    
    func removeAirportLocation(_ identifier: String, for key: UserDefaultsKeys) {
        let existingValues = userDefaults.array(forKey: key.rawValue) as? [String]
        var updatedValues: Set<String> = []
        
        if let existingValues {
            updatedValues.formUnion(existingValues)
        }
        
        updatedValues.subtract([identifier])
        
        let values = Array(updatedValues)
        userDefaults.setValue(values, forKey: key.rawValue)
        logger.log("\(values)")
    }
    
    func retrieveAirportLocations(for key: UserDefaultsKeys) -> [String] {
        (userDefaults.array(forKey: key.rawValue) as? [String]) ?? ["KAUS", "KPWM"]
    }
}
