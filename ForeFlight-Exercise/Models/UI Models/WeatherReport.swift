//
//  WeatherReport.swift
//  ForeFlight-Exercise
//
//  Created by Michael Mendoza on 9/24/23.
//

import CoreLocation
import Foundation

struct WeatherReport: Hashable {
    var conditions: Conditions
    var forecast: Forecast
    var lastUpdated: Date
    
    public init(from dataModel: WeatherReportDataModel) {
        self.conditions = Conditions(from: dataModel.conditions)
        self.forecast = Forecast(from: dataModel.forecast)
        self.lastUpdated = dataModel.lastUpdated
    }
}

struct Conditions: Hashable {
    var text: String
    var identifier: String
    var dateIssued: Date
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var elevation: Double
    var temperature: Double
    var dewpoint: Double
    var pressure: Double
    var humidity: Int
    
    public init(from dataModel: ConditionsDataModel) {
        self.text = dataModel.text
        self.identifier = dataModel.identifier ?? ""
        self.dateIssued = dataModel.dateIssued
        self.latitude = dataModel.latitude
        self.longitude = dataModel.longitude
        self.elevation = dataModel.elevationInFeet
        self.temperature = dataModel.temperatureInCelsius ?? 0.0
        self.dewpoint = dataModel.dewpointInCelsius ?? 0.0
        self.pressure = dataModel.pressureInHg ?? 0.0
        self.humidity = dataModel.relativeHumidity
    }
}

struct Forecast: Hashable {
    var text: String
    var identifier: String
    var dateIssued: Date
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var elevation: Double
    
    public init(from dataModel: ForecastDataModel) {
        self.text = dataModel.text
        self.identifier = dataModel.identifier
        self.dateIssued = dataModel.dateIssued
        self.latitude = dataModel.latitude
        self.longitude = dataModel.longitude
        self.elevation = dataModel.elevationInFeet
    }
}
