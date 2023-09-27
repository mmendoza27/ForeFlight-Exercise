//
//  ConditionsDataModel.swift
//  ForeFlight-Exercise
//
//  Created by Michael Mendoza on 9/21/23.
//

import Foundation

struct ConditionsDataModel: Codable {
    var text: String
    var identifier: String?
    var dateIssued: Date
    var latitude: Double
    var longitude: Double
    var elevationInFeet: Double
    var temperatureInCelsius: Double?
    var dewpointInCelsius: Double?
    var pressureInHg: Double?
    var pressureInHectopascals: Double?
    var reportedAsHectopascals: Bool?
    var densityAltitudeInFeet: Int?
    var relativeHumidity: Int
    var flightRules: String
    var cloudLayers: [CloudInformation]
    var cloudLayersVersion2: [CloudInformation]
    var visibility: VisibilityInformation
    var wind: WindInformation
    var remarks: Remarks?
    var period: Period?
    
    enum CodingKeys: String, CodingKey {
        case text
        case identifier = "ident"
        case dateIssued
        case latitude = "lat"
        case longitude = "lon"
        case elevationInFeet = "elevationFt"
        case temperatureInCelsius = "tempC"
        case dewpointInCelsius = "dewpointC"
        case pressureInHg = "pressureHg"
        case pressureInHectopascals = "pressureHpa"
        case reportedAsHectopascals = "reportedAsHpa"
        case densityAltitudeInFeet = "densityAltitudeFt"
        case relativeHumidity
        case flightRules
        case cloudLayers
        case cloudLayersVersion2 = "cloudLayersV2"
        case visibility
        case wind
        case remarks
        case period
    }
}

struct CloudInformation: Codable {
    var coverage: String
    var altitude: Double
    var ceiling: Bool
    
    enum CodingKeys: String, CodingKey {
        case coverage
        case altitude = "altitudeFt"
        case ceiling
    }
}

struct VisibilityInformation: Codable {
    var distanceInStatuteMiles: Double
    var distanceQualifier: Int?
    var prevailingVisibilityInStatuteMiles: Double
    var prevailingVisibilityDistanceQualifier: Int?
    
    enum CodingKeys: String, CodingKey {
        case distanceInStatuteMiles = "distanceSm"
        case distanceQualifier
        case prevailingVisibilityInStatuteMiles = "prevailingVisSm"
        case prevailingVisibilityDistanceQualifier = "prevailingVisDistanceQualifier"
    }
}

struct WindInformation: Codable {
    var speedInKnots: Double
    var gustSpeedInKnots: Double?
    var direction: Int?
    var from: Int?
    var variable: Bool
    
    enum CodingKeys: String, CodingKey {
        case speedInKnots = "speedKts"
        case gustSpeedInKnots = "gustSpeedKts"
        case direction
        case from
        case variable
    }
}

struct Remarks: Codable {
    var hasPrecipitationDiscriminator: Bool
    var hasHumanObserver: Bool
    var seaLevelPressureInHectopascals: Double
    var temperatureInCelsius: Double
    var dewpointInCelsius: Double
    
    enum CodingKeys: String, CodingKey {
        case hasPrecipitationDiscriminator = "precipitationDiscriminator"
        case hasHumanObserver = "humanObserver"
        case seaLevelPressureInHectopascals = "seaLevelPressure"
        case temperatureInCelsius = "temperature"
        case dewpointInCelsius = "dewpoint"
    }
}

struct Period: Codable {
    var start: Date
    var end: Date
    
    enum CodingKeys: String, CodingKey {
        case start = "dateStart"
        case end = "dateEnd"
    }
}
