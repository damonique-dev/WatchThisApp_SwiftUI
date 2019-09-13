//
//  Helpers.swift
//  WatchThis_SwiftUI
//
//  Created by Damonique Thomas on 9/12/19.
//  Copyright © 2019 Damonique Thomas. All rights reserved.
//

import Foundation

func formatLargeCurrency(currency: Int) -> String {
    let formatter1 = NumberFormatter()
    formatter1.numberStyle = .currency
    
    let l = "\(currency)".count
    if l < 6 {
        if let formatted = formatter1.string(from: NSNumber(value: currency)) {
            let withoutDecimals = formatted.components(separatedBy: ".")[0]
            return withoutDecimals
        }
        return ""
    }
    let mod = (l/3)*3 - (l % 3 == 0 ? 3: 0)
    let divisor = pow(10, mod)
    let decimal = (Decimal(currency) / divisor) as NSDecimalNumber

    if let formatted = formatter1.string(from: decimal) {
        let withoutDecimals = formatted.components(separatedBy: ".")[0]
        if l < 10 {
            return "\(withoutDecimals)M"
        }
        if l < 13 {
            return "\(withoutDecimals)B"
        }
        if l < 16 {
            return "\(withoutDecimals)T"
        }
    }
    return ""
}
