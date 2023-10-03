//
//  WeatherReportClient.swift
//  ForeFlight-Exercise
//
//  Created by Michael Mendoza on 10/2/23.
//

import Dependencies
import Foundation
import IdentifiedCollections

struct WeatherReportClient {
    static var networkClient = NetworkClient()
    
    var retreiveWeatherReport: (_ identifier: String) async throws -> WeatherReport
    var retrieveWeatherReports: (_ identifiers: [String]) async throws -> IdentifiedArrayOf<WeatherReport>
    
    // MARK: - Helper Methods
    private static func getWeatherReport(for airportIdentifier: String) async throws -> WeatherReportResponse {
        let url = URL(string: Constants.weatherReportURL(with: airportIdentifier))
        
        guard let url = url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.setValue("1", forHTTPHeaderField: Constants.codingExerciseHTTPHeader)
        
        return try await networkClient.requestData(from: request)
    }
}

extension WeatherReportClient {
    static var live: WeatherReportClient {
        return WeatherReportClient(
            retreiveWeatherReport: { identifier in
                let response = try await getWeatherReport(for: identifier)
                return WeatherReport(from: response.report)
            },
            retrieveWeatherReports: { identifiers in
                let allResponses = try await withThrowingTaskGroup(of: WeatherReportResponse.self, returning: [WeatherReportResponse].self) { taskGroup in
                    for identifier in identifiers {
                        taskGroup.addTask {
                            try await self.getWeatherReport(for: identifier)
                        }
                    }
                    
                    var responses: [WeatherReportResponse] = []
                    for try await result in taskGroup {
                        responses.append(result)
                    }
                    
                    return responses
                }
                
                let updatedReports = allResponses.map(\.report).map({ WeatherReport(from: $0) })
                return IdentifiedArray(uniqueElements: updatedReports)
            }
        )
    }
    
    static var preview: WeatherReportClient {
        WeatherReportClient(
            retreiveWeatherReport: { _ in WeatherReport(from: PreviewData.sanAntonio) },
            retrieveWeatherReports: { _ in [WeatherReport(from: PreviewData.sanAntonio)] }
        )
    }
    
    static var test: WeatherReportClient {
        WeatherReportClient(
            retreiveWeatherReport: { _ in
                unimplemented(
                    "WeatherReportClient.retrieveWeatherReport is unimplemented.",
                    placeholder: WeatherReport(from: PreviewData.sanAntonio)
                )
            },
            retrieveWeatherReports: { _ in
                unimplemented(
                    "WeatherReportClient.retrieveWeatherReports is unimplemented.",
                    placeholder: []
                )
            }
        )
    }
}

enum WeatherReportClientKey: DependencyKey, TestDependencyKey {
    static let liveValue = WeatherReportClient.live
    static let previewValue = WeatherReportClient.preview
    static let testValue = WeatherReportClient.test
}

extension DependencyValues {
    var weatherReportClient: WeatherReportClient {
        get { self[WeatherReportClientKey.self] }
        set { self[WeatherReportClientKey.self] = newValue }
    }
}
