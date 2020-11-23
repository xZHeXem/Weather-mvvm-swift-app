//
//  Extension.swift
//  Weather
//
//  Created by 1234 on 22.11.2020.
//

import Foundation

// MARK: - Locale
extension Locale {
    
    static func preferredLocale() -> Locale {
        
        if let preferredIdentifier = Locale.preferredLanguages.first {
            return Locale(identifier: preferredIdentifier)
        }
        
        return Locale.current
    }
    
}
