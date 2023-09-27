//
//  ForecastDataModel.swift
//  ForeFlight-Exercise
//
//  Created by Michael Mendoza on 9/21/23.
//

import Foundation

struct ForecastDataModel: Codable {
    var text: String
    var identifier: String
    var dateIssued: Date
    var period: Period
    var latitude: Double
    var longitude: Double
    var elevationInFeet: Double
    var conditions: [ConditionsDataModel]
    
    enum CodingKeys: String, CodingKey {
        case text
        case identifier = "ident"
        case dateIssued
        case period
        case latitude = "lat"
        case longitude = "lon"
        case elevationInFeet = "elevationFt"
        case conditions
    }
}
