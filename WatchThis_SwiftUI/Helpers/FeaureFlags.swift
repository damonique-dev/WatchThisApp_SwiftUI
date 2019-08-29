//
//  FeaureFlags.swift
//  WatchThis
//
//  Created by Damonique Thomas on 9/7/18.
//  Copyright © 2018 Damonique Thomas. All rights reserved.
//

import UIKit

private let dev = [Environment.Dev]
private let stagingBelow = [Environment.Dev, Environment.Staging]
private let betaBelow = [Environment.Dev, Environment.Staging, Environment.Beta]
private let prodBelow = [Environment.Dev, Environment.Staging, Environment.Beta, Environment.Prod]

struct FeatureFlags {
    static let enabledEnvironmentForFeature = [
        Feature.testFeature: dev
    ]
    
    static func isEnabled(feature: Feature) -> Bool {
        return enabledEnvironmentForFeature[feature]?.contains(configuration.environment) ?? false
    }
}

enum Feature {
    case testFeature
}

enum Environment: String {
    case Dev = "dev"
    case Staging = "staging"
    case Beta = "beta"
    case Prod = "production"
}

struct Configuration {
    lazy var environment: Environment = {
        if let configuration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as? String {
            if configuration.range(of:"DEV") != nil {
                return Environment.Dev
            }
            if configuration.range(of:"STAGING") != nil  {
                return Environment.Staging
            }
            if configuration.range(of:"BETA") != nil  {
                return Environment.Beta
            }
        }
        
        return Environment.Prod
    }()
}
