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
}
