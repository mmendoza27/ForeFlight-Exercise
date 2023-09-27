//
//  UIImage+Extensions.swift
//  ForeFlight-Exercise
//
//  Created by Michael Mendoza on 9/20/23.
//

import UIKit

extension UIImage {
    public convenience init?(symbol: Symbols) {
        self.init(systemName: symbol.rawValue.description)
    }
    
    public convenience init?(symbol: Symbols, withConfiguration configuration: UIImage.SymbolConfiguration?) {
        self.init(systemName: symbol.rawValue.description, withConfiguration: configuration)
    }
    
    static var plus: UIImage? {
        let configuration = UIImage.SymbolConfiguration(hierarchicalColor: .accent)
        return UIImage(symbol: .plusCircleFill, withConfiguration: configuration)
    }
    
    static var settings: UIImage? {
        let configuration = UIImage.SymbolConfiguration(hierarchicalColor: .accent)
        return UIImage(symbol: .gearshapeCircleFill, withConfiguration: configuration)
    }
    
    static var chevron: UIImage? {
        let configuration = UIImage.SymbolConfiguration(hierarchicalColor: .accent)
        return UIImage(symbol: .chevonForwardCircleFill, withConfiguration: configuration)
    }
}
