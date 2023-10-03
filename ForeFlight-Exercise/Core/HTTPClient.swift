//
//  HTTPClient.swift
//  ForeFlight-Exercise
//
//  Created by Michael Mendoza on 10/2/23.
//

import Dependencies
import Foundation

protocol HTTPClient {
    func requestData<Response: Codable>(from url: URL) async throws -> Response
}
