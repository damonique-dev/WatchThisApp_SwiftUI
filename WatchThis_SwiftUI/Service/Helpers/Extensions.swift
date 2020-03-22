//
//  Colors.swift
//  Watch This
//
//  Created by Damonique Thomas on 3/9/18.
//  Copyright © 2018 Damonique Thomas. All rights reserved.
//

import SwiftUI

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    struct AppColors {
        static let Orange = UIColor.rgb(red: 245, green: 166, blue: 35)
        static let Green = UIColor.rgb(red: 23, green: 158, blue: 128)
        static let Grey_Light = UIColor.rgb(red: 171, green: 171, blue: 171)
        static let Grey_Medium = UIColor.rgb(red: 108, green: 108, blue: 108)
        static let Grey_Dark = UIColor.rgb(red: 58, green: 58, blue: 58)
        static let Grey_Darkest = UIColor.rgb(red: 33, green: 33, blue: 33)
        static let Translucent = UIColor(white: 1, alpha: 0.0)
    }
}

extension Color {
    static func rgb(red: Double, green: Double, blue: Double) -> Color {
        return Color(red: red/255, green: green/255, blue: blue/255)
    }
    
    struct AppColors {
        static let Orange = Color.rgb(red: 245, green: 166, blue: 35)
        static let Green = Color.rgb(red: 23, green: 158, blue: 128)
        static let Grey_Light = Color.rgb(red: 171, green: 171, blue: 171)
        static let Grey_Medium = Color.rgb(red: 108, green: 108, blue: 108)
        static let Grey_Dark = Color.rgb(red: 58, green: 58, blue: 58)
        static let Grey_Darkest = Color.rgb(red: 33, green: 33, blue: 33)
        static let Translucent = Color(white: 1, opacity: 0.0)
    }
}

extension String {
    func fromISOtoDateString(format: String = "EEEE, MMM d yyyy h:mm a") -> String? {
        let trimmedIsoString = self.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        guard let date = isoFormatter.date(from: trimmedIsoString) else {
            return nil
        }
                
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = format
        
        return dateFormatterPrint.string(from: date)
    }
}
