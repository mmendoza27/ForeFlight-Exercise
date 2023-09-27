//
//  Settings.swift
//  ForeFlight-Exercise
//
//  Created by Michael Mendoza on 9/26/23.
//

import Foundation

struct Settings {
    enum RetrievalType: Int {
        case pull
        case fetch
    }
    
    enum FetchInterval: Int {
        case oneMinute
        case fiveMinutes
        case fifteenMinutes
    }
    
    enum UserInterfaceFramework: Int {
        case uiKit
        case swiftUI
    }

    var retrievalType: RetrievalType
    var fetchInterval: FetchInterval
    var userInterfaceFramework: UserInterfaceFramework
}
