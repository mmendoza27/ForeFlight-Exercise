//
//  PreviewData.swift
//  ForeFlight-Exercise
//
//  Created by Michael Mendoza on 9/21/23.
//

import Foundation

struct PreviewData {
    static var sanAntonio: WeatherReportDataModel {
        WeatherReportDataModel(conditions: PreviewData.conditions, forecast: PreviewData.forecast, lastUpdated: Date.now)
    }
    
    static var conditions: ConditionsDataModel {
        ConditionsDataModel(
            text: "METAR KSAT 211651Z 08003KT 10SM BKN033 BKN250 30/21 A3003 RMK AO2 SLP149 T03000211",
            identifier: "KSAT",
            dateIssued: .now,
            latitude: 29.533958023627164,
            longitude: -98.46905707877525,
            elevationInFeet: 809.0,
            relativeHumidity: 59,
            flightRules: "vfr",
            cloudLayers: [],
            cloudLayersVersion2: [],
            visibility: VisibilityInformation(
                distanceInStatuteMiles: 10.0,
                prevailingVisibilityInStatuteMiles: 10.0
            ),
            wind: WindInformation(
                speedInKnots: 3.0,
                direction: 80,
                from: 80,
                variable: false
            )
        )
    }
    
    static var forecast: ForecastDataModel {
        ForecastDataModel(
            text: "KSAT 211721Z 2118/2224 14009KT P6SM SCT040 FM220200 14010G20KT P6SM FEW070 FM220600 14010KT P6SM SKC FM220800 16007KT P6SM BKN014 FM221600 16008KT P6SM SCT040",
            identifier: "KSAT",
            dateIssued: .now,
            period: Period(
                start: .now.addingTimeInterval(-86_400.0),
                end: .now.addingTimeInterval(86_400.0)
            ),
            latitude: 29.533958023627164,
            longitude: -98.46905707877525,
            elevationInFeet: 809.0,
            conditions: []
        )
    }
}
