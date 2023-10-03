//
//  SettingsFeatureTests.swift
//  ForeFlight-ExerciseTests
//
//  Created by Michael Mendoza on 10/2/23.
//

import ComposableArchitecture
import XCTest
@testable import ForeFlight_Exercise

@MainActor
final class SettingsFeatureTests: XCTestCase {
    var store: TestStoreOf<SettingsFeature>!
    
    override func setUp() {
        store = TestStore(initialState: SettingsFeature.State()) {
            SettingsFeature()
        }
        
        store.dependencies.cachingClient.updateSettingsValue = { _, _ in }
    }
    
    override func tearDown() {
        store = nil
    }
    
    func testRetrievalTypeChanged() async {
        await store.send(.retrievalTypeChanged(newValue: .fetch)) {
            $0.retrievalType = .fetch
        }
        
        await store.send(.retrievalTypeChanged(newValue: .pull)) {
            $0.retrievalType = .pull
        }
    }
    
    func testFetchIntervalChanged() async {
        await store.send(.fetchIntervalChanged(newValue: .fiveMinutes)) {
            $0.fetchInterval = .fiveMinutes
        }
        
        await store.send(.fetchIntervalChanged(newValue: .fifteenMinutes)) {
            $0.fetchInterval = .fifteenMinutes
        }
        
        await store.send(.fetchIntervalChanged(newValue: .oneMinute)) {
            $0.fetchInterval = .oneMinute
        }
    }
    
    func testPreferredFrameworkChanged() async {
        await store.send(.preferredFrameworkChanged(newValue: .swiftUI)) {
            $0.preferredFramework = .swiftUI
        }
        
        await store.send(.preferredFrameworkChanged(newValue: .uiKit)) {
            $0.preferredFramework = .uiKit
        }
    }
}
