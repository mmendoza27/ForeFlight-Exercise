//
//  Image+Extensions.swift
//  ForeFlight-Exercise
//
//  Created by Michael Mendoza on 9/28/23.
//

import SwiftUI

extension Image {
    public init(symbol: Symbols) {
        self.init(systemName: symbol.rawValue)
    }
}
