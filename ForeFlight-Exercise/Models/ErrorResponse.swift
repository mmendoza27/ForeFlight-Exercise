//
//  ErrorResponse.swift
//  ForeFlight-Exercise
//
//  Created by Michael Mendoza on 9/21/23.
//

import Foundation

struct ErrorResponse: Codable {
    var timestamp: Int
    var status: Int
    var error: String
    var path: String
}
