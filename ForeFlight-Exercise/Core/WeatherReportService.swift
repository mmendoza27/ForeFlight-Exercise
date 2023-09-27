//
//  WeatherReportService.swift
//  ForeFlight-Exercise
//
//  Created by Michael Mendoza on 9/20/23.
//

import Foundation

class WeatherReportService {
    // MARK: - Properties
    let networkClient = NetworkClient()
    
    // MARK: - Methods
    func retrieveWeatherReport(for identifier: String) async throws -> Task<WeatherReport, Error> {
        Task { () -> WeatherReport in
            do {
                let response = try await getWeatherReport(for: identifier)
                return WeatherReport(from: response.report)
            }
        }
    }
    
    func retrieveWeatherReports(for identifiers: [String]) async throws -> Task<[WeatherReport], Error> {
        Task { () -> [WeatherReport] in
            do {
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
                return updatedReports
            }
        }
    }
    
    // MARK: - Private Methods
    private func getWeatherReport(for airportIdentifier: String) async throws -> WeatherReportResponse {
        let url = URL(string: Constants.weatherReportURL(with: airportIdentifier))
        
        guard let url = url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.setValue("1", forHTTPHeaderField: "ff-coding-exercise")
        
        return try await networkClient.requestData(from: request)
    }
    
    private func getMockReport(for airportIdentifier: String) async throws -> WeatherReportResponse {
        WeatherReportResponse(report: PreviewData.sanAntonio)
    }
}
