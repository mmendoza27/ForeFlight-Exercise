//
//  Constants.swift
//  ForeFlight-Exercise
//
//  Created by Michael Mendoza on 9/20/23.
//

import Foundation

enum Constants {
    enum LoggingCategory: String {
        case core = "Core"
    }
    
    static var bundleIdentifier: String {
        Bundle.main.bundleIdentifier ?? "com.michaelmendoza.ForeFlight-Exercise"
    }
    
    static var backgroundTaskIdentifier: String {
        "\(bundleIdentifier).refresh"
    }
    
    static func weatherReportURL(with identifier: String) -> String {
        "https://qa.foreflight.com/weather/report/\(identifier)"
    }
    
    static var codingExerciseHTTPHeader: String {
        "ff-coding-exercise"
    }
    
    enum Locations {
        static let navigationTitle = "Locations"
    }
    
    enum Settings {
        static let navigationTitle = "Settings"
        static let fetchSectionTitle = "Automatic Updates"
        static let fetchToggleTitle = "Fetch New Data Automatically"
        static let fetchIntervalTitle = "Framework Type"
        static let preferredFrameworkSectionTitle = "Preferred Framework"
        static let frameworkTypeTitle = "Framework Type"
    }
    
    enum Buttons {
        static let oneMinute = "1 minute"
        static let fiveMinutes = "5 minutes"
        static let fifteenMinutes = "15 minutes"
        static let uiKit = "UIKit"
        static let swiftUI = "SwiftUI"
        static let doneTitle = "Done"
    }
}
