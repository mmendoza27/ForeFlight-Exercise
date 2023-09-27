//
//  WeatherReportDataModel.swift
//  ForeFlight-Exercise
//
//  Created by Michael Mendoza on 9/20/23.
//

import Foundation

struct WeatherReportResponse: Codable {
    var report: WeatherReportDataModel
}

struct WeatherReportDataModel: Codable {
    var conditions: ConditionsDataModel
    var forecast: ForecastDataModel
    var lastUpdated: Date

    enum CodingKeys: String, CodingKey {
        case conditions
        case forecast
        case lastUpdated
    }
    
    public init(conditions: ConditionsDataModel, forecast: ForecastDataModel, lastUpdated: Date) {
        self.conditions = conditions
        self.forecast = forecast
        self.lastUpdated = lastUpdated
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.conditions = try container.decode(ConditionsDataModel.self, forKey: .conditions)
        self.forecast = try container.decode(ForecastDataModel.self, forKey: .forecast)
        self.lastUpdated = .now
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(conditions, forKey: .conditions)
        try container.encode(forecast, forKey: .forecast)
        try container.encode(lastUpdated, forKey: .lastUpdated)
    }
}
