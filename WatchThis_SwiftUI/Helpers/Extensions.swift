//
//  Colors.swift
//  Watch This
//
//  Created by Damonique Thomas on 3/9/18.
//  Copyright © 2018 Damonique Thomas. All rights reserved.
//

import UIKit

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
        
    }
    static let Translucent = UIColor(white: 1, alpha: 0.0)
}
